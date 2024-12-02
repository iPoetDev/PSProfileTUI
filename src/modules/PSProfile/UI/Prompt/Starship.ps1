using namespace System.Management.Automation
using namespace System.Collections.Generic

# Starship Integration Module for PSProfile
# Provides primary prompt functionality using Starship with PSProfile fallback

class StarshipPrompt {
    [string] $StarshipExe
    [string] $ConfigPath
    [string] $CachePath
    [bool] $IsAvailable
    [hashtable] $DefaultConfig

    StarshipPrompt() {
        $this.Initialize()
    }

    [void] Initialize() {
        # Set default paths
        $this.StarshipExe = 'C:/Program Files/starship/bin/starship.exe'
        $this.ConfigPath = 'D:/Code/Lab/build/the-lab-v1/.config/starship.toml'
        $this.CachePath = "$ENV:HOME/.starship/cache"

        # Set default configuration
        $this.DefaultConfig = @{
            add_newline     = $false
            command_timeout = 1000
            format          = '$os$username$hostname$kubernetes$directory$git_branch$git_status'
        }

        # Check availability
        $this.IsAvailable = $this.TestStarshipInstallation()
    }

    [bool] TestStarshipInstallation() {
        return (Test-Path $this.StarshipExe)
    }

    [void] SetEnvironmentVariables() {
        $ENV:STARSHIP_CONFIG = $this.ConfigPath
        $ENV:STARSHIP_CACHE = $this.CachePath
    }

    [void] Enable() {
        if (-not $this.IsAvailable) {
            throw "Starship is not installed at $($this.StarshipExe)"
        }

        $this.SetEnvironmentVariables()
        Invoke-Expression (&$this.StarshipExe init powershell)
    }

    [void] ValidateConfig() {
        if (-not (Test-Path $this.ConfigPath)) {
            Write-Warning "Starship config not found at $($this.ConfigPath)"
            $this.CreateDefaultConfig()
        }
    }

    [void] CreateDefaultConfig() {
        $configDir = Split-Path $this.ConfigPath -Parent
        if (-not (Test-Path $configDir)) {
            New-Item -Path $configDir -ItemType Directory -Force | Out-Null
        }

        $this.ExportDefaultConfig() | Set-Content -Path $this.ConfigPath -Force
    }

    [string] ExportDefaultConfig() {
        return @'
# PSProfile Starship Configuration
add_newline = false
command_timeout = 1000
format = """$os$username$hostname$kubernetes$directory$git_branch$git_status"""

[character]
success_symbol = ""
error_symbol = ""

[os]
format = "[$symbol](bold white) "
disabled = false

[os.symbols]
Windows = " "
Arch = "󰣇"
Ubuntu = ""
Macos = "󰀵"

[username]
style_user = "white bold"
style_root = "black bold"
format = "[$user]($style) "
disabled = false
show_always = true

[hostname]
ssh_only = false
format = "on [$hostname](bold yellow) "
disabled = false

[directory]
truncation_length = 1
truncation_symbol = "…/"
home_symbol = "󰋜 ~"
read_only_style = "197"
read_only = "  "
format = "at [$path]($style)[$read_only]($read_only_style) "

[git_branch]
symbol = " "
format = "via [$symbol$branch]($style)"
truncation_symbol = "…/"
style = "bold green"

[git_status]
format = "([ \( $all_status$ahead_behind\)]($style) )"
style = "bold green"
conflicted = "[ confliced=${count}](red) "
up_to_date = "[󰘽 up-to-date](green) "
untracked = "[󰋗 untracked=${count}](red) "
ahead = " ahead=${count}"
diverged = " ahead=${ahead_count}  behind=${behind_count}"
behind = " behind=${count}"
stashed = "[ stashed=${count}](green) "
modified = "[󰛿 modified=${count}](yellow) "
staged = "[󰐗 staged=${count}](green) "
renamed = "[󱍸 renamed=${count}](yellow) "
deleted = "[󰍶 deleted=${count}](red) "

[kubernetes]
format = "via [󱃾 $context\($namespace\)](bold purple) "
disabled = false
'@
    }
}

# Module-level instance
$Script:StarshipInstance = [StarshipPrompt]::new()

# Public functions
function Initialize-Starship {
    <#
    .SYNOPSIS
    Initializes Starship prompt integration

    .DESCRIPTION
    Sets up Starship as the primary prompt system with necessary configuration and environment variables
    #>
    try {
        $Script:StarshipInstance.ValidateConfig()
        $Script:StarshipInstance.Enable()
        Write-Verbose 'Starship prompt initialized successfully'
        return $true
    }
    catch {
        Write-Warning "Failed to initialize Starship: $_"
        return $false
    }
}

function Test-StarshipAvailable {
    <#
    .SYNOPSIS
    Tests if Starship is available on the system

    .DESCRIPTION
    Checks if Starship is installed and properly configured
    #>
    return $Script:StarshipInstance.IsAvailable
}

function Get-StarshipConfig {
    <#
    .SYNOPSIS
    Gets the current Starship configuration

    .DESCRIPTION
    Returns the path and content of the current Starship configuration
    #>
    return @{
        Path    = $Script:StarshipInstance.ConfigPath
        Content = if (Test-Path $Script:StarshipInstance.ConfigPath) {
            Get-Content $Script:StarshipInstance.ConfigPath -Raw
        }
        else {
            $null
        }
    }
}

function Reset-StarshipConfig {
    <#
    .SYNOPSIS
    Resets Starship configuration to default

    .DESCRIPTION
    Creates or overwrites the Starship configuration file with default settings
    #>
    $Script:StarshipInstance.CreateDefaultConfig()
}

function Import-StarshipConfig {
    <#
    .SYNOPSIS
    Imports a Starship configuration from a file

    .PARAMETER Path
    Path to the configuration file to import
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Test-Path $Path) {
        Copy-Item -Path $Path -Destination $Script:StarshipInstance.ConfigPath -Force
        return $true
    }
    return $false
}

function Export-StarshipConfig {
    <#
    .SYNOPSIS
    Exports the current Starship configuration to a file

    .PARAMETER Path
    Path where to export the configuration
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Test-Path $Script:StarshipInstance.ConfigPath) {
        Copy-Item -Path $Script:StarshipInstance.ConfigPath -Destination $Path -Force
        return $true
    }
    return $false
}

# Export functions
Export-ModuleMember -Function @(
    'Initialize-Starship',
    'Test-StarshipAvailable',
    'Get-StarshipConfig',
    'Reset-StarshipConfig',
    'Import-StarshipConfig',
    'Export-StarshipConfig'
)
