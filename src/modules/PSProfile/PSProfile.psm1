#Requires -Version 5.1
<#
.SYNOPSIS
    A modular PowerShell profile management system.

.DESCRIPTION
    PSProfile is a comprehensive PowerShell profile management system that provides:
    - Modular loading system with multiple profile modes (Minimal, Standard, Full)
    - Feature management with lazy loading
    - Configurable menu system
    - Extensive logging and error handling
    - Cross-platform compatibility

.NOTES
    Name: PSProfile
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20

.LINK
    https://github.com/ipoetdev/PSProfile

.EXAMPLE
    Import-Module PSProfile
    Initialize-PSProfile -Mode Minimal

    Initializes PSProfile in minimal mode with core functionality only.

.EXAMPLE
    Import-Module PSProfile
    Initialize-PSProfile -Mode Full

    Initializes PSProfile in full mode with all features enabled.
#>

using module .\Core\Logging\Logging.psm1
using module .\Core\Configuration\Configuration.psm1
using module .\Core\Initialize\Initialize.psm1

# Version information
$script:Version = '1.0.0'
$script:ModuleRoot = $PSScriptRoot

# Feature module paths
$script:FeatureModules = @{
    Git = Join-Path $ModuleRoot 'Features\Git\Git.psm1'
    SSH = Join-Path $ModuleRoot 'Features\SSH\SSH.psm1'
    WSL = Join-Path $ModuleRoot 'Features\WSL\WSL.psm1'
    VirtualEnv = Join-Path $ModuleRoot 'Features\VirtualEnv\VirtualEnv.psm1'
}

# UI module paths
$script:UIModules = @{
    Menu = Join-Path $ModuleRoot 'UI\Menu\Menu.psm1'
    Prompt = Join-Path $ModuleRoot 'UI\Prompt\Prompt.psm1'
}

function Import-PSProfileModule {
    <#
    .SYNOPSIS
        Imports a PSProfile module.

    .DESCRIPTION
        This function imports a PSProfile module based on the specified module name.
        It handles the loading of feature modules and UI components.

    .PARAMETER ModuleName
        The name of the module to import.

    .PARAMETER Force
        Forces reimporting even if already imported.

    .PARAMETER Quiet
        Suppresses the import success message.

    .EXAMPLE
        Import-PSProfileModule -ModuleName Git
        Imports the Git feature module.

    .EXAMPLE
        Import-PSProfileModule -ModuleName Menu -Force
        Reimports the Menu UI module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName,
        [switch]$Force,
        [switch]$Quiet
    )
    
    try {
        $modulePath = switch -Regex ($ModuleName) {
            '^(Git|SSH|WSL|VirtualEnv)$' { 
                $script:FeatureModules[$ModuleName]
            }
            '^(Menu|Prompt)$' {
                $script:UIModules[$ModuleName]
            }
            default {
                throw "Unknown module: $ModuleName"
            }
        }
        
        if (Test-Path $modulePath) {
            Import-Module $modulePath -Force:$Force -Global
            if (-not $Quiet) {
                Write-Host "Imported module: $ModuleName" -ForegroundColor Green
            }
            return $true
        }
        else {
            Write-Warning "Module not found: $modulePath"
            return $false
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area "ModuleImport"
        throw
    }
}

function Get-PSProfileVersion {
    <#
    .SYNOPSIS
        Retrieves the current PSProfile version.

    .DESCRIPTION
        Gets the current version of PSProfile.

    .EXAMPLE
        Get-PSProfileVersion
        Returns the current PSProfile version.
    #>
    [CmdletBinding()]
    param()
    
    $script:Version
}

function Get-PSProfileModules {
    <#
    .SYNOPSIS
        Retrieves the available PSProfile modules.

    .DESCRIPTION
        Gets the available PSProfile modules, including feature modules and UI components.

    .EXAMPLE
        Get-PSProfileModules
        Returns the available PSProfile modules.
    #>
    [CmdletBinding()]
    param()
    
    try {
        $modules = @{
            Core = @(
                'Logging'
                'Configuration'
                'Initialize'
            )
            Features = @(
                'Git'
                'SSH'
                'WSL'
                'VirtualEnv'
            )
            UI = @(
                'Menu'
                'Prompt'
            )
        }
        
        # Add availability status
        $modules.Features = $modules.Features | ForEach-Object {
            @{
                Name = $_
                Available = Test-Path $script:FeatureModules[$_]
                Enabled = (Get-PSProfileConfig).Features.$_
            }
        }
        
        $modules.UI = $modules.UI | ForEach-Object {
            @{
                Name = $_
                Available = Test-Path $script:UIModules[$_]
            }
        }
        
        $modules
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area "ModuleDiscovery"
        throw
    }
}

function Select-ProfileMode {
    <#
    .SYNOPSIS
        Selects the PSProfile mode.

    .DESCRIPTION
        This function sets the PSProfile mode, which determines the features and modules to load.

    .PARAMETER Mode
        The profile mode to select. Valid values are:
        - Minimal: Core functionality only
        - Standard: Core + commonly used features
        - Full: All features enabled

    .EXAMPLE
        Select-ProfileMode -Mode Minimal
        Sets the profile mode to minimal.

    .EXAMPLE
        Select-ProfileMode -Mode Full
        Sets the profile mode to full.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Minimal', 'Standard', 'Full')]
        [string]$Mode
    )
    
    try {
        $config = Get-PSProfileConfig
        
        # Update features based on mode
        switch ($Mode) {
            'Minimal' {
                $config.Features = @{
                    Git = $false
                    SSH = $false
                    WSL = $false
                    VirtualEnv = $false
                }
            }
            'Standard' {
                $config.Features = @{
                    Git = $true
                    SSH = $true
                    WSL = $false
                    VirtualEnv = $false
                }
            }
            'Full' {
                $config.Features = @{
                    Git = $true
                    SSH = $true
                    WSL = $true
                    VirtualEnv = $true
                }
            }
        }
        
        $config.Mode = $Mode
        Set-PSProfileConfig -Configuration $config
        
        # Reinitialize profile with new configuration
        Initialize-PSProfile -Force
        
        Write-Host "Profile mode set to: $Mode" -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area "ProfileMode"
        throw
    }
}

function Test-PSProfileMenu {
    <#
    .SYNOPSIS
        Opens the interactive PSProfile test menu.

    .DESCRIPTION
        Provides quick access to the PSProfile test menu system.
        This is an alias function that launches the test menu interface.

    .EXAMPLE
        Test-PSProfileMenu
        Opens the interactive test menu.

    .EXAMPLE
        tpm
        Using the alias also opens the test menu.

    .NOTES
        This is a convenience function that provides an alias to the test menu system.
    #>
    & "$PSScriptRoot\Tests\TestMenu.ps1"
}

# Add alias for the test menu
New-Alias -Name tpm -Value Test-PSProfileMenu

# Initialize on module import
try {
    # Ensure core modules are loaded
    Import-Module (Join-Path $PSScriptRoot 'Core\Logging\Logging.psm1') -Force -Global
    Import-Module (Join-Path $PSScriptRoot 'Core\Configuration\Configuration.psm1') -Force -Global
    Import-Module (Join-Path $PSScriptRoot 'Core\Initialize\Initialize.psm1') -Force -Global
    
    # Initialize profile if not already initialized
    if (-not (Test-ProfileInitialized)) {
        Initialize-PSProfile
    }
}
catch {
    Write-Warning "Failed to initialize PSProfile: $_"
    throw
}

# Export functions
Export-ModuleMember -Function @(
    # Core functions
    'Initialize-PSProfile'
    'Import-PSProfileModule'
    'Get-PSProfileVersion'
    'Get-PSProfileModules'
    'Select-ProfileMode'
    'Test-PSProfileMenu'
    
    # Configuration functions
    'Get-PSProfileConfig'
    'Set-PSProfileConfig'
    'Reset-PSProfileConfig'
    
    # Feature discovery
    'Get-ProfileFeatures'
    'Test-ProfileInitialized'
) -Alias @(
    'tpm'
)
