#Requires -Version 5.1
using namespace System.Management.Automation.Host
using module ..\..\..\Core\Configuration\Configuration.psm1

<#
.SYNOPSIS
    Prompt configuration menu for PSProfile.
.DESCRIPTION
    Provides an interactive menu for configuring the PSProfile prompt system,
    including Starship and fallback prompt settings.
#>

function Show-PromptConfigMenu {
    [CmdletBinding()]
    param()
    
    $promptConfig = Get-PSProfilePromptConfig
    
    while ($true) {
        Clear-Host
        Write-Host "`n=== PSProfile Prompt Configuration ===" -ForegroundColor Cyan
        Write-Host "`nCurrent Prompt Type: $($promptConfig.Type)" -ForegroundColor Yellow
        Write-Host "`nOptions:"
        Write-Host "1. Switch Prompt Type (Current: $($promptConfig.Type))"
        Write-Host "2. Configure $($promptConfig.Type) Settings"
        Write-Host "3. View Current Configuration"
        Write-Host "4. Back to Main Menu"
        Write-Host "Q. Exit"
        
        $choice = Read-Host "`nSelect an option"
        
        switch ($choice) {
            "1" {
                $newType = $promptConfig.Type -eq 'Starship' ? 'PSProfile' : 'Starship'
                Set-PSProfilePromptType -Type $newType
                $promptConfig = Get-PSProfilePromptConfig
                Write-Host "`nPrompt type changed to $newType" -ForegroundColor Green
                Start-Sleep -Seconds 1
            }
            "2" {
                switch ($promptConfig.Type) {
                    'Starship' { Show-StarshipConfigMenu }
                    'PSProfile' { Show-PSProfilePromptConfigMenu }
                }
            }
            "3" { 
                Show-CurrentPromptConfig
                Read-Host "Press Enter to continue"
            }
            "4" { return }
            "Q" { exit }
            default {
                Write-Host "`nInvalid option. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}

function Show-StarshipConfigMenu {
    [CmdletBinding()]
    param()
    
    $promptConfig = Get-PSProfilePromptConfig
    
    while ($true) {
        Clear-Host
        Write-Host "`n=== Starship Configuration ===" -ForegroundColor Cyan
        Write-Host "`nCurrent Settings:"
        Write-Host "Config Path: $($promptConfig.Config.Starship.ConfigPath)"
        Write-Host "Cache Path: $($promptConfig.Config.Starship.CachePath)"
        
        Write-Host "`nOptions:"
        Write-Host "1. Change Config Path"
        Write-Host "2. Change Cache Path"
        Write-Host "3. Open Config in Editor"
        Write-Host "4. Back to Prompt Menu"
        Write-Host "Q. Exit"
        
        $choice = Read-Host "`nSelect an option"
        
        switch ($choice) {
            "1" {
                $newPath = Read-Host "Enter new config path"
                Update-PSProfilePromptConfig -Type Starship -Settings @{
                    ConfigPath = $newPath
                }
                $promptConfig = Get-PSProfilePromptConfig
            }
            "2" {
                $newPath = Read-Host "Enter new cache path"
                Update-PSProfilePromptConfig -Type Starship -Settings @{
                    CachePath = $newPath
                }
                $promptConfig = Get-PSProfilePromptConfig
            }
            "3" {
                if (Test-Path $promptConfig.Config.Starship.ConfigPath) {
                    Start-Process notepad $promptConfig.Config.Starship.ConfigPath
                } else {
                    Write-Host "`nConfig file not found!" -ForegroundColor Red
                    Start-Sleep -Seconds 1
                }
            }
            "4" { return }
            "Q" { exit }
            default {
                Write-Host "`nInvalid option. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}

function Show-PSProfilePromptConfigMenu {
    [CmdletBinding()]
    param()
    
    $promptConfig = Get-PSProfilePromptConfig
    
    while ($true) {
        Clear-Host
        Write-Host "`n=== PSProfile Prompt Configuration ===" -ForegroundColor Cyan
        Write-Host "`nCurrent Settings:"
        Write-Host "Show Git Status: $($promptConfig.Config.PSProfile.ShowGitStatus)"
        Write-Host "Show Path: $($promptConfig.Config.PSProfile.ShowPath)"
        Write-Host "Show Time: $($promptConfig.Config.PSProfile.ShowTime)"
        
        Write-Host "`nColor Scheme:"
        $promptConfig.Config.PSProfile.ColorScheme.GetEnumerator() | ForEach-Object {
            Write-Host "$($_.Key): $($_.Value)"
        }
        
        Write-Host "`nOptions:"
        Write-Host "1. Toggle Git Status"
        Write-Host "2. Toggle Path Display"
        Write-Host "3. Toggle Time Display"
        Write-Host "4. Modify Colors"
        Write-Host "5. Back to Prompt Menu"
        Write-Host "Q. Exit"
        
        $choice = Read-Host "`nSelect an option"
        
        switch ($choice) {
            "1" {
                Update-PSProfilePromptConfig -Type PSProfile -Settings @{
                    ShowGitStatus = !$promptConfig.Config.PSProfile.ShowGitStatus
                }
                $promptConfig = Get-PSProfilePromptConfig
            }
            "2" {
                Update-PSProfilePromptConfig -Type PSProfile -Settings @{
                    ShowPath = !$promptConfig.Config.PSProfile.ShowPath
                }
                $promptConfig = Get-PSProfilePromptConfig
            }
            "3" {
                Update-PSProfilePromptConfig -Type PSProfile -Settings @{
                    ShowTime = !$promptConfig.Config.PSProfile.ShowTime
                }
                $promptConfig = Get-PSProfilePromptConfig
            }
            "4" { Show-ColorConfigMenu }
            "5" { return }
            "Q" { exit }
            default {
                Write-Host "`nInvalid option. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}

function Show-ColorConfigMenu {
    [CmdletBinding()]
    param()
    
    $promptConfig = Get-PSProfilePromptConfig
    $validColors = [System.ConsoleColor].GetEnumNames()
    
    while ($true) {
        Clear-Host
        Write-Host "`n=== Color Configuration ===" -ForegroundColor Cyan
        Write-Host "`nCurrent Colors:"
        $promptConfig.Config.PSProfile.ColorScheme.GetEnumerator() | ForEach-Object {
            Write-Host "$($_.Key): $($_.Value)"
        }
        
        Write-Host "`nOptions:"
        Write-Host "1. Change Path Color"
        Write-Host "2. Change Git Color"
        Write-Host "3. Change Error Color"
        Write-Host "4. Back to PSProfile Config"
        Write-Host "Q. Exit"
        
        $choice = Read-Host "`nSelect an option"
        
        switch ($choice) {
            "1" { Set-PromptColor -Element "Path" -ValidColors $validColors }
            "2" { Set-PromptColor -Element "Git" -ValidColors $validColors }
            "3" { Set-PromptColor -Element "Error" -ValidColors $validColors }
            "4" { return }
            "Q" { exit }
            default {
                Write-Host "`nInvalid option. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}

function Set-PromptColor {
    [CmdletBinding()]
    param(
        [string]$Element,
        [string[]]$ValidColors
    )
    
    Clear-Host
    Write-Host "`nAvailable Colors:"
    $ValidColors | ForEach-Object { Write-Host $_ -ForegroundColor $_ }
    
    $color = Read-Host "`nEnter color name"
    if ($ValidColors -contains $color) {
        $settings = @{
            ColorScheme = @{ $Element = $color }
        }
        Update-PSProfilePromptConfig -Type PSProfile -Settings $settings
    } else {
        Write-Host "`nInvalid color name!" -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}

function Show-CurrentPromptConfig {
    $config = Get-PSProfilePromptConfig
    Clear-Host
    Write-Host "`n=== Current Prompt Configuration ===" -ForegroundColor Cyan
    Write-Host "`nPrompt Type: $($config.Type)"
    
    Write-Host "`nStarship Settings:"
    Write-Host "Config Path: $($config.Config.Starship.ConfigPath)"
    Write-Host "Cache Path: $($config.Config.Starship.CachePath)"
    
    Write-Host "`nPSProfile Settings:"
    Write-Host "Show Git Status: $($config.Config.PSProfile.ShowGitStatus)"
    Write-Host "Show Path: $($config.Config.PSProfile.ShowPath)"
    Write-Host "Show Time: $($config.Config.PSProfile.ShowTime)"
    
    Write-Host "`nColor Scheme:"
    $config.Config.PSProfile.ColorScheme.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key): $($_.Value)" -ForegroundColor $_.Value
    }
}

Export-ModuleMember -Function Show-PromptConfigMenu
