#Requires -Version 5.1
<#
.SYNOPSIS
    Python Virtual Environment integration module for PSProfile.

.DESCRIPTION
    The VirtualEnv module provides comprehensive Python virtual environment management, including:
    - Environment creation and activation
    - Package management
    - Environment switching
    - Project-specific environments
    - Requirements file handling

.NOTES
    Name: VirtualEnv
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
    Requires: Python 3.x and virtualenv package
#>

using module ..\..\Core\Logging.psm1

function New-VirtualEnvironment {
    <#
    .SYNOPSIS
        Creates a new Python virtual environment.

    .DESCRIPTION
        This function creates a new Python virtual environment with specified settings.
        It supports:
        - Multiple Python versions
        - Requirements file installation
        - System packages inclusion/exclusion
        - Project-specific configurations

    .PARAMETER Name
        Name of the virtual environment.

    .PARAMETER Path
        Path where the environment should be created.

    .PARAMETER PythonVersion
        Version of Python to use (default: current system version).

    .PARAMETER Requirements
        Path to requirements.txt file.

    .PARAMETER IncludeSystemPackages
        If specified, includes system site packages.

    .EXAMPLE
        New-VirtualEnvironment -Name "myproject"
        Creates a new virtual environment named "myproject".

    .EXAMPLE
        New-VirtualEnvironment -Name "django-app" -PythonVersion "3.9" -Requirements "requirements.txt"
        Creates a new virtual environment with Python 3.9 and installs requirements.
    #>
    [CmdletBinding()]
    param (
        [string]$Name = 'venv',
        [switch]$Force,
        [string]$Python = 'python',
        [string]$Requirements
    )
    
    try {
        # Check if Python is available
        if (-not (Get-Command $Python -ErrorAction SilentlyContinue)) {
            throw "Python executable '$Python' not found"
        }
        
        # Check if directory exists
        if (Test-Path $Name) {
            if ($Force) {
                Remove-Item $Name -Recurse -Force
            }
            else {
                throw "Directory '$Name' already exists. Use -Force to overwrite"
            }
        }
        
        # Create virtual environment
        & $Python -m venv $Name
        
        if ($Requirements -and (Test-Path $Requirements)) {
            # Activate and install requirements
            $activateScript = Join-Path $Name "Scripts\Activate.ps1"
            . $activateScript
            
            & pip install -r $Requirements
            
            # Deactivate
            deactivate
        }
        
        Write-Host "Virtual environment created successfully at: $Name" -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'VirtualEnv'
        throw
    }
}

function Enter-VirtualEnvironment {
    <#
    .SYNOPSIS
        Activates a Python virtual environment.

    .DESCRIPTION
        This function activates a Python virtual environment and sets up the environment.
        It handles:
        - Environment activation
        - Path modifications
        - Shell prompt updates
        - Environment variable management

    .PARAMETER Name
        Name of the virtual environment to activate.

    .PARAMETER Path
        Path to the virtual environment (if not in default location).

    .PARAMETER NoPrompt
        If specified, doesn't modify the shell prompt.

    .EXAMPLE
        Enter-VirtualEnvironment -Name "myproject"
        Activates the "myproject" virtual environment.

    .EXAMPLE
        Enter-VirtualEnvironment -Name "django-app" -Path "D:\Projects\Django" -NoPrompt
        Activates a specific virtual environment without modifying the prompt.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    try {
        $activateScript = Join-Path $Path "Scripts\Activate.ps1"
        if (-not (Test-Path $activateScript)) {
            throw "Virtual environment not found at: $Path"
        }
        
        . $activateScript
        Write-Host "Activated virtual environment: $Path" -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'VirtualEnv'
        throw
    }
}

function Exit-VirtualEnvironment {
    <#
    .SYNOPSIS
        Deactivates the current Python virtual environment.

    .DESCRIPTION
        This function deactivates the current Python virtual environment and restores
        the original environment settings.

    .PARAMETER Force
        Forces deactivation even if environment appears inactive.

    .EXAMPLE
        Exit-VirtualEnvironment
        Deactivates the current virtual environment.

    .EXAMPLE
        Exit-VirtualEnvironment -Force
        Forces deactivation of the virtual environment.
    #>
    [CmdletBinding()]
    param()
    
    try {
        if (Test-Path Function:\deactivate) {
            deactivate
            Write-Host "Deactivated virtual environment" -ForegroundColor Green
        }
        else {
            Write-Warning "No active virtual environment found"
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'VirtualEnv'
        throw
    }
}

# Export functions
Export-ModuleMember -Function @(
    'New-VirtualEnvironment'
    'Enter-VirtualEnvironment'
    'Exit-VirtualEnvironment'
)
