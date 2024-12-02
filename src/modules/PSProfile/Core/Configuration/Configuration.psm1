#Requires -Version 5.1
<#
.SYNOPSIS
    Core configuration management for PSProfile.

.DESCRIPTION
    The Configuration module provides the core configuration management functionality for PSProfile.
    It handles loading, saving, and validating configuration settings, including:
    - Profile modes and settings
    - Feature states and configurations
    - Module loading preferences
    - UI customization options

.NOTES
    Name: Configuration
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
#>

using module .\Logging.psm1

# Configuration paths
$script:ConfigDir = Join-Path $env:USERPROFILE '.psprofile'
$script:ConfigPath = Join-Path $script:ConfigDir 'config.psd1'
$script:ConfigCache = @{}

# Default configuration
$script:DefaultConfig = @{
    Mode = 'Standard'  # Standard, Minimal, Full
    Features = @{
        Git = $true
        SSH = $true
        WSL = $false
        VirtualEnv = $false
    }
    Logging = @{
        Enabled = $true
        Path = Join-Path $env:USERPROFILE 'PowerShell\Logs'
        RetentionDays = 30
    }
    Performance = @{
        TrackStartup = $true
        LazyLoading = $true
    }
    UI = @{
        ShowStartupTime = $true
        ColorScheme = @{
            Success = 'Green'
            Warning = 'Yellow'
            Error = 'Red'
            Info = 'Cyan'
        }
        Prompt = @{
            Type = 'Starship'  # Starship or PSProfile
            Config = @{
                Starship = @{
                    ConfigPath = Join-Path $env:USERPROFILE '.config\starship.toml'
                    CachePath = Join-Path $env:USERPROFILE '.starship\cache'
                }
                PSProfile = @{
                    ShowGitStatus = $true
                    ShowPath = $true
                    ShowTime = $true
                    ColorScheme = @{
                        Path = 'Blue'
                        Git = 'Green'
                        Error = 'Red'
                    }
                }
            }
        }
    }
}

function Initialize-Configuration {
    <#
    .SYNOPSIS
        Initializes the PSProfile configuration system.

    .DESCRIPTION
        This function initializes the configuration system by creating necessary
        directories and files, and loading or creating default configuration.

    .PARAMETER Force
        Forces reinitialization even if configuration already exists.

    .EXAMPLE
        Initialize-Configuration
        Initializes the configuration system with default settings.

    .EXAMPLE
        Initialize-Configuration -Force
        Reinitializes the configuration system, resetting to defaults.
    #>
    [CmdletBinding()]
    param(
        [switch]$Force
    )
    
    try {
        # Create config directory if it doesn't exist
        if (-not (Test-Path $script:ConfigDir)) {
            New-Item -ItemType Directory -Path $script:ConfigDir -Force | Out-Null
        }
        
        # Create or update config file
        if ($Force -or -not (Test-Path $script:ConfigPath)) {
            $script:DefaultConfig | Export-PowerShellData -Path $script:ConfigPath
            Write-Host "Configuration initialized at: $($script:ConfigPath)" -ForegroundColor Green
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'Configuration'
        throw
    }
}

function Get-PSProfileConfig {
    <#
    .SYNOPSIS
        Retrieves the current PSProfile configuration.

    .DESCRIPTION
        This function loads the current configuration settings from the configuration file.

    .EXAMPLE
        Get-PSProfileConfig
        Retrieves the current configuration.
    #>
    [CmdletBinding()]
    param()
    
    try {
        # Check if config is cached and still valid
        if (-not $script:ConfigCache.LastLoad -or 
            ((Get-Date) - $script:ConfigCache.LastLoad).TotalMinutes -gt 5) {
            
            if (-not (Test-Path $script:ConfigPath)) {
                Initialize-Configuration
            }
            
            $script:ConfigCache.Config = Import-PowerShellDataFile $script:ConfigPath
            $script:ConfigCache.LastLoad = Get-Date
        }
        
        $script:ConfigCache.Config
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'Configuration'
        $script:DefaultConfig.Clone()
    }
}

function Set-PSProfileConfig {
    <#
    .SYNOPSIS
        Sets the PSProfile configuration.

    .DESCRIPTION
        This function updates the configuration settings with the provided values.

    .PARAMETER Configuration
        A hashtable containing the configuration settings to update.

    .EXAMPLE
        $config = @{
            Mode = 'Minimal'
            Features = @{
                Git = $false
            }
        }
        Set-PSProfileConfig -Configuration $config
        Updates the configuration with the provided settings.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Configuration
    )
    
    try {
        # Merge with existing config
        $currentConfig = Get-PSProfileConfig
        $mergedConfig = Merge-Hashtables $currentConfig $Configuration
        
        # Save configuration
        $mergedConfig | Export-PowerShellData -Path $script:ConfigPath
        
        # Clear cache
        $script:ConfigCache.Remove('Config')
        $script:ConfigCache.Remove('LastLoad')
        
        Write-Host "Configuration updated successfully" -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'Configuration'
        throw
    }
}

function Reset-PSProfileConfig {
    <#
    .SYNOPSIS
        Resets the PSProfile configuration to defaults.

    .DESCRIPTION
        This function resets the configuration settings to their default values.

    .PARAMETER Force
        Forces reset even if configuration file exists.

    .EXAMPLE
        Reset-PSProfileConfig
        Resets the configuration to defaults.

    .EXAMPLE
        Reset-PSProfileConfig -Force
        Forces reset of the configuration to defaults.
    #>
    [CmdletBinding()]
    param(
        [switch]$Force
    )
    
    try {
        if ($Force -or (Test-Path $script:ConfigPath)) {
            $script:DefaultConfig | Export-PowerShellData -Path $script:ConfigPath
            
            # Clear cache
            $script:ConfigCache.Remove('Config')
            $script:ConfigCache.Remove('LastLoad')
            
            Write-Host "Configuration reset to defaults" -ForegroundColor Green
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'Configuration'
        throw
    }
}

function Get-PSProfilePromptConfig {
    <#
    .SYNOPSIS
        Gets the current prompt configuration.
    
    .DESCRIPTION
        Retrieves the current prompt configuration settings from PSProfile.
    #>
    [CmdletBinding()]
    param()
    
    $config = Get-PSProfileConfig
    return $config.UI.Prompt
}

function Set-PSProfilePromptType {
    <#
    .SYNOPSIS
        Sets the prompt type to use.
    
    .DESCRIPTION
        Changes the prompt type between Starship and PSProfile.
    
    .PARAMETER Type
        The type of prompt to use. Must be either 'Starship' or 'PSProfile'.
    #>
    [CmdletBinding()]
    param(
        [ValidateSet('Starship', 'PSProfile')]
        [string]$Type
    )
    
    $config = Get-PSProfileConfig
    $config.UI.Prompt.Type = $Type
    Save-PSProfileConfig -Config $config
    
    # Reload prompt
    . $PSScriptRoot\..\..\UI\Prompt\PromptManager.ps1
    Initialize-PSProfilePrompt
}

function Update-PSProfilePromptConfig {
    <#
    .SYNOPSIS
        Updates prompt-specific configuration settings.
    
    .DESCRIPTION
        Modifies the configuration for either Starship or PSProfile prompt.
    
    .PARAMETER Type
        The type of prompt configuration to update.
    
    .PARAMETER Settings
        A hashtable of settings to update.
    #>
    [CmdletBinding()]
    param(
        [ValidateSet('Starship', 'PSProfile')]
        [string]$Type,
        [hashtable]$Settings
    )
    
    $config = Get-PSProfileConfig
    
    foreach ($key in $Settings.Keys) {
        $config.UI.Prompt.Config.$Type.$key = $Settings[$key]
    }
    
    Save-PSProfileConfig -Config $config
    
    # Reload prompt if necessary
    if ($config.UI.Prompt.Type -eq $Type) {
        . $PSScriptRoot\..\..\UI\Prompt\PromptManager.ps1
        Initialize-PSProfilePrompt
    }
}

function Export-PowerShellData {
    <#
    .SYNOPSIS
        Exports a PowerShell object to a file.

    .DESCRIPTION
        This function exports a PowerShell object to a file in a format that can be
        imported using the Import-PowerShellDataFile cmdlet.

    .PARAMETER InputObject
        The object to export.

    .PARAMETER Path
        The path to the file where the object will be exported.

    .EXAMPLE
        $config = @{
            Mode = 'Standard'
            Features = @{
                Git = $true
            }
        }
        Export-PowerShellData -InputObject $config -Path 'C:\config.psd1'
        Exports the configuration to a file.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [hashtable]$InputObject,
        
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    process {
        try {
            $output = "@{`n"
            foreach ($key in $InputObject.Keys) {
                $value = $InputObject[$key]
                $output += "    $key = "
                
                switch ($value.GetType().Name) {
                    'Boolean' { $output += "`$$value" }
                    'String' { $output += "'$value'" }
                    'Int32' { $output += $value }
                    'Hashtable' {
                        $output += "@{`n"
                        foreach ($subKey in $value.Keys) {
                            $subValue = $value[$subKey]
                            $output += "        $subKey = "
                            
                            switch ($subValue.GetType().Name) {
                                'Boolean' { $output += "`$$subValue" }
                                'String' { $output += "'$subValue'" }
                                'Int32' { $output += $subValue }
                                'Hashtable' { $output += $subValue | ConvertTo-PSDString -Indent 8 }
                                default { $output += "'$subValue'" }
                            }
                            $output += "`n"
                        }
                        $output += "    }"
                    }
                    default { $output += "'$value'" }
                }
                $output += "`n"
            }
            $output += "}"
            
            $output | Out-File -FilePath $Path -Encoding utf8 -Force
        }
        catch {
            Write-ErrorLog -ErrorRecord $_ -Area 'Configuration'
            throw
        }
    }
}

function Merge-Hashtables {
    <#
    .SYNOPSIS
        Merges two hashtables.

    .DESCRIPTION
        This function merges two hashtables, updating the first with the values from the second.

    .PARAMETER Original
        The original hashtable.

    .PARAMETER Update
        The hashtable containing the updated values.

    .EXAMPLE
        $original = @{
            Mode = 'Standard'
            Features = @{
                Git = $true
            }
        }
        $update = @{
            Mode = 'Minimal'
            Features = @{
                Git = $false
            }
        }
        Merge-Hashtables -Original $original -Update $update
        Merges the two hashtables.
    #>
    param(
        [hashtable]$Original,
        [hashtable]$Update
    )
    
    $result = $Original.Clone()
    
    foreach ($key in $Update.Keys) {
        $value = $Update[$key]
        
        if ($value -is [hashtable] -and $Original.ContainsKey($key) -and $Original[$key] -is [hashtable]) {
            $result[$key] = Merge-Hashtables $Original[$key] $value
        }
        else {
            $result[$key] = $value
        }
    }
    
    $result
}

# Export functions
Export-ModuleMember -Function Initialize-Configuration, Get-PSProfileConfig, 
                             Set-PSProfileConfig, Reset-PSProfileConfig, 
                             Get-PSProfilePromptConfig, Set-PSProfilePromptType, 
                             Update-PSProfilePromptConfig