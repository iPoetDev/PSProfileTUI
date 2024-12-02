#Requires -Version 5.1
<#
.SYNOPSIS
    Core initialization system for PSProfile.

.DESCRIPTION
    The Initialize module provides the core initialization functionality for PSProfile.
    It handles the startup process, including:
    - Environment setup
    - Module loading
    - Feature initialization
    - Profile configuration
    - Error handling during startup

.NOTES
    Name: Initialize
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
#>

using module .\Logging.psm1
using module .\Configuration.psm1

$script:ProfileInitialized = $false

function Initialize-PSProfile {
    <#
    .SYNOPSIS
        Initializes the PSProfile environment.

    .DESCRIPTION
        This function sets up the basic environment required for PSProfile to operate,
        including directory structure and environment variables.

    .PARAMETER Force
        Forces reinitialization even if environment is already set up.

    .PARAMETER Quiet
        Suppresses output during initialization.

    .EXAMPLE
        Initialize-PSProfile
        Sets up the PSProfile environment.

    .EXAMPLE
        Initialize-PSProfile -Force
        Forces environment setup even if already initialized.

    .EXAMPLE
        Initialize-PSProfile -Quiet
        Initializes the environment without output.
    #>
    [CmdletBinding()]
    param(
        [switch]$Force,
        [switch]$Quiet
    )
    
    try {
        if ($script:ProfileInitialized -and -not $Force) {
            Write-Warning "Profile already initialized. Use -Force to reinitialize."
            return
        }
        
        $startTime = Get-Date
        
        # Initialize configuration
        $config = Get-PSProfileConfig
        
        # Load features based on configuration
        if ($config.Features.Git) {
            Import-Module (Join-Path $PSScriptRoot '..\Features\Git\Git.psm1') -Global
            if (-not $Quiet) { Write-Host "Loaded Git feature" -ForegroundColor $config.UI.ColorScheme.Success }
        }
        
        if ($config.Features.SSH) {
            Import-Module (Join-Path $PSScriptRoot '..\Features\SSH\SSH.psm1') -Global
            if (-not $Quiet) { Write-Host "Loaded SSH feature" -ForegroundColor $config.UI.ColorScheme.Success }
        }
        
        if ($config.Features.WSL) {
            Import-Module (Join-Path $PSScriptRoot '..\Features\WSL\WSL.psm1') -Global
            if (-not $Quiet) { Write-Host "Loaded WSL feature" -ForegroundColor $config.UI.ColorScheme.Success }
        }
        
        if ($config.Features.VirtualEnv) {
            Import-Module (Join-Path $PSScriptRoot '..\Features\VirtualEnv\VirtualEnv.psm1') -Global
            if (-not $Quiet) { Write-Host "Loaded VirtualEnv feature" -ForegroundColor $config.UI.ColorScheme.Success }
        }
        
        # Load UI components
        Import-Module (Join-Path $PSScriptRoot '..\UI\Menu\Menu.psm1') -Global
        Import-Module (Join-Path $PSScriptRoot '..\UI\Prompt\Prompt.psm1') -Global
        
        $script:ProfileInitialized = $true
        
        # Track performance if enabled
        if ($config.Performance.TrackStartup) {
            $duration = ((Get-Date) - $startTime).TotalMilliseconds
            Write-PerformanceLog -Operation 'ProfileInitialization' -Duration $duration
            
            if ($config.UI.ShowStartupTime) {
                Write-Host "Profile initialized in ${duration}ms" -ForegroundColor $config.UI.ColorScheme.Info
            }
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'Initialization'
        throw
    }
}

function Test-ProfileInitialized {
    <#
    .SYNOPSIS
        Tests if the PSProfile is initialized.

    .DESCRIPTION
        This function checks if the PSProfile has been initialized.

    .EXAMPLE
        Test-ProfileInitialized
        Returns $true if the profile is initialized, $false otherwise.
    #>
    [CmdletBinding()]
    param()
    
    $script:ProfileInitialized
}

function Get-ProfileFeatures {
    <#
    .SYNOPSIS
        Retrieves the enabled PSProfile features.

    .DESCRIPTION
        This function returns the list of enabled features based on the current configuration.

    .EXAMPLE
        Get-ProfileFeatures
        Returns the list of enabled features.
    #>
    [CmdletBinding()]
    param()
    
    try {
        $config = Get-PSProfileConfig
        $config.Features
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'Features'
        throw
    }
}

# Export functions
Export-ModuleMember -Function Initialize-PSProfile, Test-ProfileInitialized, Get-ProfileFeatures

function Initialize-PowerShellProfile {
    <#
    .SYNOPSIS
        Initializes the PowerShell profile.

    .DESCRIPTION
        This function initializes the PowerShell profile, including:
        - Environment setup
        - Module loading
        - Feature initialization
        - Profile configuration
        - Error handling during startup

    .PARAMETER Quiet
        Suppresses output during initialization.

    .EXAMPLE
        Initialize-PowerShellProfile
        Initializes the PowerShell profile.

    .EXAMPLE
        Initialize-PowerShellProfile -Quiet
        Initializes the profile without output.
    #>
    [CmdletBinding()]
    param(
        [switch]$Quiet
    )
    
    $startTime = Get-Date
    
    try {
        # Initialize only enabled systems
        if ($script:ConfigFlags.EnableLogging) {
            Initialize-LoggingSystem
        }
        
        if ($script:ConfigFlags.EnableModules) {
            Initialize-ModuleSystem
        }
        
        # Initialize basic aliases only if not in Standard mode
        if (-not $Quiet) {
            Initialize-SafeAliases
        }
        
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalMilliseconds
        if (-not $Quiet) {
            Write-Host "Profile initialization took $($duration)ms." -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Failed to initialize PowerShell profile: $($_.Exception.Message)"
        Write-Error "Profile initialization failed. Check logs at: $script:LogPath"
    }
}
