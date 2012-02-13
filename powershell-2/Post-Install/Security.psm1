# Security.psm1 - Enforce Windows 7 security features
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


# Enable ASLR for all processes
# This is documented only on Wikipedia and (apparently)
# Windows Internals: Including Windows Server 2008 and Windows Vista, 5tn ed
# Take it with a grain of salt.
function ASLR ()
{
    Set-ItemProperty `
        -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" `
        -Name MoveImages -Value 1 -Type dword
}


# Enforce Data Execution Prevention for all applications regardless of opt-out
# lists.
function DEP ()
{
    bcdedit.exe /set nx AlwaysOn | Out-Null
}


# Enable SEHOP
# http://support.microsoft.com/kb/956607
function SEHOP ()
{
    Set-ItemProperty `
        -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" `
        -Name DisableExceptionChainValidation -Value 0 -Type dword
}


Export-ModuleMember -Function ASLR, DEP, SEHOP
