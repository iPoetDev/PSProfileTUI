using namespace System.Management.Automation
using namespace System.Collections.Generic

# Fallback Prompt Module for PSProfile
# Provides fallback functionality when Starship is not available

class FallbackPrompt {
    [hashtable] $Theme
    [array] $Format
    [hashtable] $Segments

    FallbackPrompt() {
        $this.Initialize()
    }

    [void] Initialize() {
        # Initialize default theme (Starship-compatible)
        $this.Theme = @{
            Symbols = @{
                Windows   = ' '
                Git       = ' '
                Home      = '󰋜 ~'
                Modified  = '󰛿'
                Staged    = '󰐗'
                Untracked = '󰋗'
            }
            Colors  = @{
                Username = 'white bold'
                Hostname = 'yellow bold'
                Git      = 'green bold'
                Path     = 'blue bold'
            }
        }

        # Initialize default format
        $this.Format = @(
            '%os%',
            '%username%',
            '%hostname%',
            '%directory%',
            '%git%'
        )

        # Initialize segments
        $this.Segments = @{
            os        = @{
                enabled = $true
                content = { $this.GetOSSegment() }
            }
            username  = @{
                enabled = $true
                content = { $env:USERNAME }
            }
            hostname  = @{
                enabled = $true
                content = { $env:COMPUTERNAME }
            }
            directory = @{
                enabled = $true
                content = { $this.GetDirectorySegment() }
            }
            git       = @{
                enabled = $true
                content = { $this.GetGitSegment() }
            }
        }
    }

    [string] GetOSSegment() {
        return $this.Theme.Symbols.Windows
    }

    [string] GetDirectorySegment() {
        $path = $PWD.Path
        if ($path.StartsWith($ENV:HOME)) {
            $path = $path.Replace($ENV:HOME, $this.Theme.Symbols.Home)
        }
        return $path
    }

    [string] GetGitSegment() {
        try {
            $branch = git branch --show-current 2>$null
            if ($branch) {
                $status = git status --porcelain 2>$null
                $symbol = $this.Theme.Symbols.Git
                $statusIndicator = ''

                if ($status) {
                    $modified = $status | Where-Object { $_ -match '^ ?M' }
                    $staged = $status | Where-Object { $_ -match '^[MARCD]' }
                    $untracked = $status | Where-Object { $_ -match '^\?\?' }

                    if ($modified) { $statusIndicator += $this.Theme.Symbols.Modified }
                    if ($staged) { $statusIndicator += $this.Theme.Symbols.Staged }
                    if ($untracked) { $statusIndicator += $this.Theme.Symbols.Untracked }
                }

                return "$symbol $branch $statusIndicator"
            }
        }
        catch {
            Write-Debug "Git segment error: $_"
        }
        return ''
    }

    [string] GeneratePrompt() {
        $promptParts = foreach ($segment in $this.Format) {
            $segmentName = $segment -replace '%(.+)%', '$1'
            if ($this.Segments.ContainsKey($segmentName) -and $this.Segments[$segmentName].enabled) {
                & $this.Segments[$segmentName].content
            }
        }

        return ($promptParts -join ' ') + ' '
    }
}

# Module-level instance
$Script:FallbackInstance = [FallbackPrompt]::new()

# Public functions
function Initialize-FallbackPrompt {
    <#
    .SYNOPSIS
    Initializes the fallback prompt system

    .DESCRIPTION
    Sets up the PSProfile fallback prompt when Starship is not available
    #>
    try {
        $function:prompt = { $Script:FallbackInstance.GeneratePrompt() }
        Write-Verbose 'Fallback prompt initialized successfully'
        return $true
    }
    catch {
        Write-Warning "Failed to initialize fallback prompt: $_"
        return $false
    }
}

function Set-FallbackTheme {
    <#
    .SYNOPSIS
    Sets the theme for the fallback prompt

    .PARAMETER Theme
    Hashtable containing theme settings
    #>
    param(
        [Parameter(Mandatory)]
        [hashtable]$Theme
    )

    $Script:FallbackInstance.Theme = $Theme
}

function Set-FallbackFormat {
    <#
    .SYNOPSIS
    Sets the format for the fallback prompt

    .PARAMETER Format
    Array of format segments
    #>
    param(
        [Parameter(Mandatory)]
        [array]$Format
    )

    $Script:FallbackInstance.Format = $Format
}

function Get-FallbackConfiguration {
    <#
    .SYNOPSIS
    Gets the current fallback prompt configuration
    #>
    return @{
        Theme    = $Script:FallbackInstance.Theme
        Format   = $Script:FallbackInstance.Format
        Segments = $Script:FallbackInstance.Segments
    }
}

# Export functions
Export-ModuleMember -Function @(
    'Initialize-FallbackPrompt',
    'Set-FallbackTheme',
    'Set-FallbackFormat',
    'Get-FallbackConfiguration'
)
