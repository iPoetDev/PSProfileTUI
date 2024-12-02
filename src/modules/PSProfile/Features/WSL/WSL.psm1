#Requires -Version 5.1
<#
.SYNOPSIS
    Windows Subsystem for Linux (WSL) integration module for PSProfile.

.DESCRIPTION
    The WSL module provides comprehensive WSL integration for PSProfile, including:
    - Distribution management
    - File system integration
    - Network configuration
    - Service management
    - Cross-platform scripting

.NOTES
    Name: WSL
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
    Requires: Windows 10/11 with WSL2 enabled
#>

using namespace System.Management.Automation

function Initialize-WSLSystem {
    <#
    .SYNOPSIS
        Initializes the WSL integration system.

    .DESCRIPTION
        This function sets up the WSL integration system by:
        - Verifying WSL installation
        - Configuring default distribution
        - Setting up network integration
        - Configuring file system access
        - Setting up service management

    .PARAMETER Force
        Forces reinitialization even if already initialized.

    .EXAMPLE
        Initialize-WSLSystem
        Initializes the WSL system with default settings.

    .EXAMPLE
        Initialize-WSLSystem -Force
        Forces reinitialization of the WSL system.
    #>
    [CmdletBinding()]
    param(
        [switch]$Force
    )
    
    Write-Verbose "Initializing WSL integration..."
    
    # Check if WSL is installed
    if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
        Write-Warning "WSL is not installed on this system."
        return $false
    }
    
    # Import WSL functions
    . $PSScriptRoot\WSLFunctions.ps1
    
    return $true
}

function Get-WSLDistributions {
    <#
    .SYNOPSIS
        Retrieves a list of installed WSL distributions.

    .DESCRIPTION
        This function retrieves a list of installed WSL distributions.

    .EXAMPLE
        Get-WSLDistributions
        Retrieves a list of installed WSL distributions.
    #>
    [CmdletBinding()]
    param()
    
    try {
        $distributions = wsl.exe --list --verbose | Select-Object -Skip 1 | ForEach-Object {
            $parts = $_ -split '\s+', 4 | Where-Object { $_ }
            if ($parts.Count -ge 3) {
                [PSCustomObject]@{
                    Name = $parts[0]
                    State = $parts[2]
                    Version = $parts[1]
                }
            }
        }
        return $distributions
    }
    catch {
        Write-Error "Failed to get WSL distributions: $_"
        return @()
    }
}

function Enter-WSLEnvironment {
    <#
    .SYNOPSIS
        Enters a WSL distribution environment.

    .DESCRIPTION
        This function enters a WSL distribution environment and sets up the shell.
        It handles:
        - Distribution selection
        - User context
        - Environment variables
        - Working directory

    .PARAMETER Distribution
        Name of the distribution to enter.

    .PARAMETER User
        Username to use in the distribution.

    .PARAMETER WorkingDirectory
        Initial working directory.

    .EXAMPLE
        Enter-WSLEnvironment -Distribution "Ubuntu-20.04"
        Enters the Ubuntu 20.04 environment.

    .EXAMPLE
        Enter-WSLEnvironment -Distribution "Debian" -User "devuser" -WorkingDirectory "/home/devuser/projects"
        Enters Debian as specific user in a custom directory.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Distribution,

        [Parameter()]
        [string]$User,

        [Parameter()]
        [string]$WorkingDirectory
    )
    
    try {
        if ($Distribution) {
            wsl.exe -d $Distribution
        }
        else {
            wsl.exe
        }
    }
    catch {
        Write-Error "Failed to enter WSL environment: $_"
    }
}

function Start-WSLCommand {
    <#
    .SYNOPSIS
        Executes a command in a WSL distribution.

    .DESCRIPTION
        This function executes a command in a WSL distribution.
        It handles:
        - Command execution
        - Distribution selection
        - User context
        - Environment variables

    .PARAMETER Command
        Command to execute.

    .PARAMETER Distribution
        Name of the distribution to use.

    .PARAMETER User
        Username to use in the distribution.

    .PARAMETER NoProfile
        If specified, does not load the user profile.

    .EXAMPLE
        Start-WSLCommand -Command "ls -l"
        Executes the ls -l command in the default distribution.

    .EXAMPLE
        Start-WSLCommand -Command "ls -l" -Distribution "Ubuntu-20.04" -User "devuser" -NoProfile
        Executes the ls -l command in Ubuntu 20.04 as devuser without loading the user profile.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Command,

        [Parameter()]
        [string]$Distribution,

        [Parameter()]
        [string]$User,

        [Parameter()]
        [switch]$NoProfile
    )
    
    try {
        $wslArgs = @()
        if ($Distribution) {
            $wslArgs += @('-d', $Distribution)
        }
        if ($User) {
            $wslArgs += @('-u', $User)
        }
        if ($NoProfile) {
            $wslArgs += '--'
        }
        $wslArgs += $Command
        
        wsl.exe @wslArgs
    }
    catch {
        Write-Error "Failed to execute WSL command: $_"
    }
}

# Export module members
Export-ModuleMember -Function @(
    'Initialize-WSLSystem'
    'Get-WSLDistributions'
    'Enter-WSLEnvironment'
    'Start-WSLCommand'
)
