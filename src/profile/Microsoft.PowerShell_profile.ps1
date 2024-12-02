# PowerShell Profile
# Author: Charles
# Last Modified: $(Get-Date -Format "yyyy-MM-dd")
# Description: Modular PowerShell profile with configurable loading modes and lazy loading

# Import required assemblies for menu system
using namespace System.Management.Automation.Host

# Profile loading modes:
# - Blank: No modules loaded, basic prompt only
# - Minimal: Core module with essential features (lazy loaded)
# - Full: All modules enabled (lazy loaded)

param(
    [ValidateSet('Blank', 'Minimal', 'Full')]
    [string]$LoadingMode = $env:PSPROFILE_MODE ?? 'Minimal'
)

# Global variables for module state
$script:PSProfileState = @{
    Initialized = $false
    LoadingMode = $LoadingMode
    LoadedModules = @{}
    ModulePath = Join-Path $PSScriptRoot '..\Modules\PSProfile\PSProfile.psd1'
    ErrorLog = Join-Path $PSScriptRoot 'Logs\profile_errors.log'
    LoadTime = $null
    StartTime = Get-Date
    AutoLoadModules = @{
        Minimal = @(
            'Core\Configuration'
            'Core\Logging'
            'UI\Prompt'
        )
        Full = @(
            'Core\Configuration'
            'Core\Logging'
            'Core\Initialize'
            'Features\Git'
            'Features\SSH'
            'Features\VirtualEnv'
            'UI\Menu'
            'UI\Prompt'
        )
    }
}

# Error handling function
function Write-ProfileError {
    param(
        [string]$Message,
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        [string]$Area = 'General'
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $errorMessage = if ($ErrorRecord) {
        "$Message`nError: $($ErrorRecord.Exception.Message)`nStack Trace: $($ErrorRecord.ScriptStackTrace)"
    } else {
        $Message
    }
    
    # Ensure log directory exists
    $logDir = Split-Path $script:PSProfileState.ErrorLog -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    
    # Log error
    "[${timestamp}] [$Area] $errorMessage" | Add-Content $script:PSProfileState.ErrorLog
    Write-Warning $Message
}

# Safe module import function
function Import-ProfileModule {
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName,
        [switch]$Required,
        [switch]$Quiet
    )
    
    try {
        if ($script:PSProfileState.LoadedModules.ContainsKey($ModuleName)) {
            return $true
        }
        
        $modulePath = Join-Path (Split-Path $script:PSProfileState.ModulePath -Parent) $ModuleName
        if (Test-Path $modulePath) {
            Import-Module $modulePath -Force
            $script:PSProfileState.LoadedModules[$ModuleName] = $true
            if (-not $Quiet) {
                Write-Host "Loaded module: $ModuleName" -ForegroundColor Green
            }
            return $true
        }
        elseif ($Required) {
            throw "Required module not found: $ModuleName"
        }
        else {
            Write-ProfileError -Message "Optional module not found: $ModuleName" -Area 'ModuleImport'
            return $false
        }
    }
    catch {
        Write-ProfileError -Message "Failed to import module: $ModuleName" -ErrorRecord $_ -Area 'ModuleImport'
        if ($Required) { throw }
        return $false
    }
}

# Initialize profile based on loading mode
function Initialize-Profile {
    param([string]$Mode)
    
    if ($script:PSProfileState.Initialized) { return }
    
    try {
        $script:PSProfileState.LoadingMode = $Mode
        
        switch ($Mode) {
            'Blank' {
                # Do nothing, use basic prompt only
                Write-Host "Profile loaded in Blank mode. Type 'Show-ProfileMenu' to manage features." -ForegroundColor Cyan
            }
            
            'Minimal' {
                if (Test-Path $script:PSProfileState.ModulePath) {
                    Import-Module $script:PSProfileState.ModulePath -Force
                    Initialize-PSProfile -Minimal
                    
                    # Lazy load minimal modules
                    $script:PSProfileState.AutoLoadModules.Minimal | ForEach-Object {
                        Import-ProfileModule -ModuleName $_ -Quiet
                    }
                    
                    Write-Host "Profile loaded in Minimal mode. Type 'Show-ProfileMenu' to manage features." -ForegroundColor Cyan
                }
            }
            
            'Full' {
                if (Test-Path $script:PSProfileState.ModulePath) {
                    Import-Module $script:PSProfileState.ModulePath -Force
                    Initialize-PSProfile
                    
                    # Lazy load all modules
                    $script:PSProfileState.AutoLoadModules.Full | ForEach-Object {
                        Import-ProfileModule -ModuleName $_ -Quiet
                    }
                    
                    Write-Host "Profile loaded in Full mode. Type 'Show-ProfileMenu' to manage features." -ForegroundColor Cyan
                }
            }
        }
        
        $script:PSProfileState.Initialized = $true
        $script:PSProfileState.LoadTime = (Get-Date) - $script:PSProfileState.StartTime
    }
    catch {
        Write-ProfileError -Message "Failed to initialize profile in $Mode mode" -ErrorRecord $_ -Area 'Initialization'
        throw
    }
}

# Function to enable profile features
function Enable-PSProfile {
    param(
        [ValidateSet('Blank', 'Minimal', 'Full')]
        [string]$Mode = 'Minimal'
    )
    
    $script:PSProfileState.LoadingMode = $Mode
    $script:PSProfileState.Initialized = $false
    $script:PSProfileState.StartTime = Get-Date
    
    try {
        Initialize-Profile -Mode $Mode
        Reset-ProfilePrompt
    }
    catch {
        Write-ProfileError -Message "Failed to enable profile" -ErrorRecord $_ -Area 'ProfileEnable'
        $script:PSProfileState.LoadingMode = 'Blank'
    }
}

# Function to show profile menu
function Show-ProfileMenu {
    if (-not (Import-ProfileModule -ModuleName 'UI\Menu\FeatureMenu' -Required)) {
        return
    }
    
    Show-FeatureMenu -LoadedFeatures $script:PSProfileState.LoadedModules -CurrentMode $script:PSProfileState.LoadingMode
}

# Function to reset profile prompt
function Reset-ProfilePrompt {
    try {
        if ($script:PSProfileState.LoadingMode -eq 'Blank') {
            function prompt { "PS> " }
        }
        else {
            # Try to load custom prompt
            if (Import-ProfileModule -ModuleName 'UI\Prompt' -Quiet) {
                Set-PSProfilePrompt
            }
            else {
                # Fallback to simple prompt
                function prompt {
                    $location = Split-Path (Get-Location) -Leaf
                    "PS $location> "
                }
            }
        }
    }
    catch {
        Write-ProfileError -Message "Failed to reset prompt" -ErrorRecord $_ -Area 'Prompt'
        function prompt { "PS> " }
    }
}

# Initialize profile with loading menu
try {
    # Import loading menu module
    Import-Module (Join-Path (Split-Path $script:PSProfileState.ModulePath -Parent) 'UI\Menu\LoadingMenu.psm1') -Force
    
    # Show loading menu and get selected mode
    $selectedMode = Show-LoadingMenu
    
    # Initialize profile with selected mode
    Initialize-Profile -Mode $selectedMode
    Reset-ProfilePrompt
}
catch {
    # Profile failed to initialize, set up minimal environment
    Write-Warning "Profile initialization failed. Running in Blank mode."
    Write-Warning "Error: $_"
    $script:PSProfileState.LoadingMode = 'Blank'
    function prompt { "PS> " }
}

# Export functions for user access
Export-ModuleMember -Function @(
    'Enable-PSProfile'
    'Show-ProfileMenu'
)
