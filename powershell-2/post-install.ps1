# post-install.ps1 - Perform post intallation steps
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


Remove-Module Post-Install
Import-Module Post-Install


$workflow = @{
    "DEP"                         = $null
    "ASLR"                        = $null
    "SEHOP"                       = $null
    "NTFS"                        = $null
    "DisablePageFile"             = $null
    "DropIncomingConnections"     = $null
    "DisableAdministrativeShares" = $null
    "TrustedPath"                 = $null
    "Services" = @{
        # --- Required services ---
        "AudioSrv"         = "Automatic" # Windows Audio
        "COMSysApp"        = "Automatic" # COM+
        "eventlog"         = "Automatic" # Event viewer (syslog)
        "MpsSvc"           = "Automatic" # Windows Firewall
        "MsMpSvc"          = "Automatic" # Microsoft AntiMalware
        "Netman"           = "Automatic" # Connections folder
        "netprofm"         = "Automatic" # Network management
        "NlaSvc"           = "Automatic" # Network management
        "nsi"              = "Automatic" # Network management
        "PlugPlay"         = "Automatic" # Hardware recognition
        "ProtectedStorage" = "Automatic" # Protected identities storage
        "RpcSs"            = "Automatic" # RPC (required by COM services)
        "SamSs"            = "Automatic" # SAM
        "Themes"           = "Automatic" # Themes
        "ProfSvc"          = "Automatic" # (Un)Loads user profiles
        "UxSms"            = "Automatic" # Desktop Window Manager
        "WinDefend"        = "Automatic" # Windows Defender
        "wuauserv"         = "Automatic" # Windows update
        "Appinfo"          = "Manual"    # "Run as administrator" menu entry
        "BITS"             = "Manual"    # Required by Windows Update
        "msiserver"        = "Manual"    # Windows Installer
        "TrustedInstaller" = "Manual"    # Manage Windows Components and Windows Updates
        "sppsvc"           = "Manual"    # Manage Windows Licenses
        "wscsvc"           = "Manual"    # Security center
        "WatAdminSvc"      = "Manual"    # Performs Windows 7 Activation
        # --- Optional services ---
        "Dhcp"             = "Automatic" # DHCP client
        "Dnscache"         = "Automatic" # DNS cache
        "FontCache"        = "Automatic" # Font cache
        "FontCache3.0.0.0" = "Automatic" # Font cache for WPF applications
        "hidserv"          = "Automatic" # HID buttons
        "Power"            = "Automatic" # Power management
        "SysMain"          = "Automatic" # SuperFetch
        "clr_optimization_v2.0.50727_64" = "Manual" # NGEN
        "clr_optimization_v2.0.50727_32" = "Manual" # Ditto
        "clr_optimization_v4.0.30319_64" = "Manual" # Ditto
        "clr_optimization_v4.0.30319_32" = "Manual" # Ditto
    }
}


foreach ( $task in $workflow.Keys )
{
    echo ( "=> " + $task )
    & $task $workflow[$task]
}
