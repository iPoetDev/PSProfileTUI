# Menu Configuration Manager Module
using namespace System.Management.Automation.Host

class MenuConfig {
    [hashtable]$Config
    [string]$ConfigPath
    [bool]$Modified
    
    MenuConfig([string]$configPath) {
        $this.ConfigPath = $configPath
        $this.Modified = $false
        $this.LoadConfig()
    }
    
    [void]LoadConfig() {
        try {
            if (Test-Path $this.ConfigPath) {
                $this.Config = Import-PowerShellDataFile -Path $this.ConfigPath
            }
            else {
                $this.Config = $this.GetDefaultConfig()
                $this.SaveConfig()
            }
        }
        catch {
            Write-Warning "Failed to load menu configuration: $_"
            $this.Config = $this.GetDefaultConfig()
        }
    }
    
    [void]SaveConfig() {
        try {
            $configDir = Split-Path $this.ConfigPath -Parent
            if (-not (Test-Path $configDir)) {
                New-Item -ItemType Directory -Path $configDir -Force | Out-Null
            }
            
            $this.Config | Export-PowerShellData -Path $this.ConfigPath
            $this.Modified = $false
        }
        catch {
            Write-Warning "Failed to save menu configuration: $_"
        }
    }
    
    [hashtable]GetDefaultConfig() {
        # Load the default configuration from MenuConfig.psd1
        $defaultConfigPath = Join-Path (Split-Path $this.ConfigPath -Parent) 'MenuConfig.psd1'
        if (Test-Path $defaultConfigPath) {
            return Import-PowerShellDataFile -Path $defaultConfigPath
        }
        
        # Fallback to basic configuration if default file not found
        return @{
            General = @{
                DefaultMode = 'Minimal'
                ShowLoadingMenu = $true
                RememberLastMode = $true
                AutoHideDelay = 2
                ShowStatusInPrompt = $true
            }
            Visual = @{
                Colors = @{
                    Title = 'Cyan'
                    MenuItems = 'White'
                    Description = 'DarkGray'
                }
            }
        }
    }
    
    [object]GetSetting([string[]]$path) {
        $current = $this.Config
        foreach ($key in $path) {
            if ($current.ContainsKey($key)) {
                $current = $current[$key]
            }
            else {
                return $null
            }
        }
        return $current
    }
    
    [void]SetSetting([string[]]$path, [object]$value) {
        $current = $this.Config
        $last = $path[-1]
        $path[0..($path.Length-2)] | ForEach-Object {
            if (-not $current.ContainsKey($_)) {
                $current[$_] = @{}
            }
            $current = $current[$_]
        }
        $current[$last] = $value
        $this.Modified = $true
    }
    
    [void]ResetToDefault() {
        $this.Config = $this.GetDefaultConfig()
        $this.Modified = $true
        $this.SaveConfig()
    }
    
    [string]GetColor([string]$element) {
        return $this.GetSetting(@('Visual', 'Colors', $element)) ?? 'White'
    }
    
    [string]GetStatusColor([string]$status) {
        return $this.GetSetting(@('Visual', 'Colors', 'Status', $status)) ?? 'White'
    }
    
    [string]GetIcon([string]$type) {
        if ($this.GetSetting(@('Visual', 'Style', 'UseIcons'))) {
            return $this.GetSetting(@('Visual', 'Style', 'Icons', $type)) ?? ''
        }
        return ''
    }
    
    [hashtable]GetFeatureConfig([string]$featureName) {
        return $this.GetSetting(@('Features', $featureName))
    }
    
    [array]GetCategoryFeatures([string]$category) {
        return $this.GetSetting(@('Categories', $category, 'Features'))
    }
    
    [bool]IsFeatureRequired([string]$featureName, [string]$mode) {
        $feature = $this.GetFeatureConfig($featureName)
        return $feature -and $feature.RequiredInModes -contains $mode
    }
}

# Export configuration manager
function Get-MenuConfig {
    [CmdletBinding()]
    param(
        [string]$ConfigPath = (Join-Path $PSScriptRoot 'UserMenuConfig.psd1')
    )
    
    return [MenuConfig]::new($ConfigPath)
}

function Export-PowerShellData {
    param(
        [Parameter(Mandatory)]
        [hashtable]$InputObject,
        
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    $output = "@{`n"
    
    function Format-Value {
        param($Value, $Indent = 1)
        
        $indentStr = "    " * $Indent
        
        switch ($Value.GetType().Name) {
            "Boolean" { return "`$$Value" }
            "String" { return "'$($Value -replace "'", "''")'" }
            "Int32" { return "$Value" }
            "Object[]" { 
                $items = $Value | ForEach-Object { Format-Value $_ ($Indent + 1) }
                return "@(`n$indentStr    " + ($items -join ",`n$indentStr    ") + "`n$indentStr)"
            }
            "Hashtable" {
                $pairs = $Value.GetEnumerator() | Sort-Object Key | ForEach-Object {
                    "$indentStr    $($_.Key) = $(Format-Value $_.Value ($Indent + 1))"
                }
                return "@{`n" + ($pairs -join "`n") + "`n$indentStr}"
            }
            default { return "'$Value'" }
        }
    }
    
    $pairs = $InputObject.GetEnumerator() | Sort-Object Key | ForEach-Object {
        "    $($_.Key) = $(Format-Value $_.Value)"
    }
    
    $output += $pairs -join "`n"
    $output += "`n}"
    
    Set-Content -Path $Path -Value $output -Encoding UTF8
}

Export-ModuleMember -Function @(
    'Get-MenuConfig'
)
