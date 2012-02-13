#!/usr/bin/python -tt
#
# package-deep-cleanup.py
#
# Copyright (C) 2010, 2011 Lorenzo Villani
#
# The MIT license:
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


import os
import sys

import yum
import yum.packageSack

from urlgrabber.progress import TextMeter

# Right, it's ugly and it comes directly from Yum's documentation.
sys.path.insert ( 0, '/usr/share/yum-cli' )
import output


class EmptyRPMDBSack ( yum.packageSack.PackageSack ):
    """
    Used in place of RPMDBPackageSack. Simulates an empty rpmdb.
    """
    def fileRequiresData ( self ):
        return ( {}, set (), {} )

    def transactionCacheFileRequires ( self, installedFileRequires,
                                       installedUnresolvedFileRequires,
                                       installedFileProvides, problems ):
        pass

    def returnConflictPackages ( self ):
        return []

    def transactionCacheConflictPackages ( self, pkgs ):
        pass


class Yb(yum.YumBase):
    """
    Wraps yum.YumBase() configuring it to access the local cache.
    """
    def __enter__(self):
        super(Yb, self).__init__()

        # self.conf.cache = os.geteuid() != 1
        self.repos.setProgressBar(TextMeter (fo=sys.stdout))
        self.repos.callback = output.CacheProgressCallback ()
        self.repos.doSetup()
        self.repos.populateSack(mdtype="metadata", cacheonly=0)
        self.repos.populateSack(mdtype="filelists", cacheonly=0)

        return self

    def __exit__ (self, t, v, tb):
        self.close ()

    def get_package(self, name):
        return self.getPackageObject(( name, '', '', '', '' ))


def print_package_list ( header, l ):
    """
    Pretty print list
    """
    print header
    for item in l:
        print "  %s" % item


def list_diff ( left, right ):
    """
    Returns (to_add, to_remove) tuple
    """
    l = set(left)
    r = set(right)

    return (r.difference(l), l.difference(r))


def read_package_list_from_file ( filename ):
    """
    Return a list of entries read from a file
    """
    with open ( filename, 'r') as f:
        ret  = []
        temp = map ( lambda line: line[:-1], f.readlines () )

        for line in temp:
            if len(line) > 0 and not line.startswith("#"):
                ret.append(line)

        return ret


def system_packages ():
    """
    Return a list of currently installed packages (package names only)
    """
    with Yb () as y:
        return map ( lambda pkg: pkg.name, y.rpmdb.returnPackages () )


def full_deps_tree ( packages ):
    """
    From a list of mandatory packages elaborate a complete list of their
    dependencies and return it.
    """
    with Yb () as y:
        # Swap RPMDB sack
        y.rpmdb = EmptyRPMDBSack ()

        for pkg in packages:
            try:
                y.install ( name=pkg )
            except yum.Errors.InstallError:
                print "Could not find %s in repositories" % pkg
                sys.exit ( 1 )

        y.resolveDeps ()
        y.populateTs ()

        return map ( lambda pkg: pkg.N (), y.ts )


def system_size ( package_names ):
    """
    From a list of package names compute their total download and installed
    size (in bytes).
    """
    with Yb () as y:
        def get ( f ):
            return reduce ( lambda a, b: a + b, map ( f, package_names ))

        return ( get ( lambda p: y.get_package ( p ).size ),
                 get ( lambda p: y.get_package ( p ).installedsize ) )


def sync_packages ( install, remove ):
    """
    Used to process the results of list_diff()
    """
    with Yb () as y:
        for pkg in install:
            y.install ( name=pkg )

        for pkg in remove:
            y.remove ( name=pkg )

        y.buildTransaction ()
        y.processTransaction ()


if __name__ == "__main__":
    packages = full_deps_tree ( read_package_list_from_file ( sys.argv[1] ) )

    install, remove = list_diff ( system_packages (), packages )

    download_size, installed_size = system_size ( packages )
    print "System download size: ~%s MB" % ( download_size / 1024 / 1024 )
    print "System installed size: ~%s MB" % ( installed_size / 1024 / 1024 )

    if ( len ( install ) == 0 and len ( remove ) == 0 ):
        print "Nothing to do."
    else:
        print_package_list ( "Install:", sorted ( install ) )
        print_package_list ( "Remove:", sorted ( remove ) )

        raw_input ( "Press Enter to continue or Ctrl+C to abort: " )

        sync_packages ( install, remove )
