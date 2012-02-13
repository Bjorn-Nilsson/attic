# Tasks.psm1 - Post installation tasks
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


# --- File system
# NTFS
# - Disable legacy 8.3 names;
# - Don't update last access time (akin to Linux "noatime" mount option);
# - Enable local symlinks only;
function NTFS ()
{
    fsutil behavior set Disable8dot3 1 | Out-Null
    fsutil behavior set DisableLastAccess 1 | Out-Null
    fsutil behavior set SymlinkEvaluation L2L:1 L2R:0 R2R:0 R2L:0 | Out-Null
}

# Disable paging file.
# - Also disables kernel dumps and hibernation.
function DisablePageFile ()
{
    Set-ItemProperty `
        -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" `
        -Name PagingFiles -Value "" -Type MultiString
}
# ---



# --- Networking
# Turn on Firewall for all profiles and block all incoming connections.
function DropIncomingConnections ()
{
    netsh advfirewall set allprofiles state on | Out-Null
    netsh advfirewall set allprofiles firewallpolicy `
        "blockinboundalways,allowoutbound" | Out-Null
}

# Disable Administrative Shares
# http://support.microsoft.com/kb/954422
function DisableAdministrativeShares ()
{
    Set-ItemProperty `
        -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
        -Name AutoShareServer -Value 0 -Type dword
}
# ---



# --- UI
# Requires users to pass through the C-M-Canc trap before entering credentials.
function TrustedPath ()
{
    if (!(Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI"))
    {
        New-Item "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI" `
            -ItemType Registry
    }
    Set-ItemProperty `
        -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI" `
        -Name EnableSecureCredentialPrompting -Value 1 -Type dword
}
# ---


Export-ModuleMember -Function ForceDEP, EnableSEHOP, ForceASLR, NTFS, `
    DisablePageFile, DropIncomingConnections, DisableAdministrativeShares, `
    TrustedPath
