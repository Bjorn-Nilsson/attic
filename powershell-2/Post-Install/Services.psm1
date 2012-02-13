# Services.psm1 - Manage services whitelist
#
# The MIT License
#
# Copyright (c) 2010 Lorenzo Villani.
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


# Windows doesn't allow users to modify these services.
$skipList = @("DcomLaunch", "gpsvc", "RpcEptMapper", "RpcSs", "Schedule")


# Manage the service list
function Services ( [hashtable]$serviceTable )
{
    $initialCount = $serviceTable.Count

    CheckDependencies $serviceTable

    echo ( "   " + $initialCount + " (+ " `
           + ( $serviceTable.Count - $initialCount ) + " dependencies)" `
           + " services" )

    foreach ( $service in ( Get-Service ) )
    {
        $name = $service.Name

        if ( -not ( $skipList -contains $name ) )
        {
            if ( $serviceTable[$name] )
            {
                Set-Service -Name $name -StartupType $serviceTable[$name]
            }
            else
            {
                Set-Service -Name $name -StartupType Disabled
            }
        }
    }
}


# Add dependencies to $serviceTable
function CheckDependencies ( [hashtable]$serviceTable )
{
    foreach ( $service in @($serviceTable.Keys) )
    {
        $dependencies = Get-Service -Name $service -RequiredServices

        foreach ( $dependency in $dependencies )
        {
            $depName = $dependency.Name

            if ( $depName -and -not $serviceTable[$depName] )
            {
                $serviceTable[$depName] = "Manual"
                echo ( "   adding " + $depName + " <= " + $service )
            }
        }
    }
}


Export-ModuleMember -Function Services
