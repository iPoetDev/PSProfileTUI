#Requires -Version 5.1
#Requires -Modules Pester
<#
.SYNOPSIS
    Interactive menu system for running PSProfile tests.

.DESCRIPTION
    Provides a user-friendly interface to run different categories of PSProfile tests.
    Supports running individual test categories or all tests at once.

.EXAMPLE
    .\TestMenu.ps1
    Shows the interactive test menu.

.NOTES
    Name: TestMenu
    Author: Charles Fowler
    Version: 1.0.0
#>

function Show-TestMenu {
    $continue = $true
    while ($continue) {
        Clear-Host
        Write-Host "`n=== PSProfile Test Menu ===" -ForegroundColor Cyan
        Write-Host "1. Run All Tests"
        Write-Host "2. Core Module Tests"
        Write-Host "3. Feature Module Tests"
        Write-Host "4. UI Module Tests"
        Write-Host "5. Show Test Results"
        Write-Host "Q. Quit"
        Write-Host "`nSelect an option: " -NoNewline

        $choice = Read-Host

        switch ($choice.ToUpper()) {
            '1' {
                Clear-Host
                Write-Host "`nRunning all tests..." -ForegroundColor Yellow
                Invoke-Pester "$PSScriptRoot\*.Tests.ps1" -Output Detailed
                Write-Host "`nPress any key to continue..."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
            '2' {
                Clear-Host
                Write-Host "`nRunning Core module tests..." -ForegroundColor Yellow
                Invoke-Pester "$PSScriptRoot\Core.Tests.ps1" -Output Detailed
                Write-Host "`nPress any key to continue..."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
            '3' {
                Clear-Host
                Write-Host "`nRunning Feature module tests..." -ForegroundColor Yellow
                Invoke-Pester "$PSScriptRoot\Features.Tests.ps1" -Output Detailed
                Write-Host "`nPress any key to continue..."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
            '4' {
                Clear-Host
                Write-Host "`nRunning UI module tests..." -ForegroundColor Yellow
                Invoke-Pester "$PSScriptRoot\UI.Tests.ps1" -Output Detailed
                Write-Host "`nPress any key to continue..."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
            '5' {
                Clear-Host
                if (Test-Path "$PSScriptRoot\TestResults") {
                    Write-Host "`nMost recent test results:" -ForegroundColor Yellow
                    Get-ChildItem "$PSScriptRoot\TestResults" | 
                        Sort-Object LastWriteTime -Descending | 
                        Select-Object -First 1 | 
                        Get-Content
                } else {
                    Write-Host "`nNo test results found." -ForegroundColor Yellow
                }
                Write-Host "`nPress any key to continue..."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
            'Q' {
                $continue = $false
            }
            default {
                Write-Host "`nInvalid option. Press any key to continue..."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
        }
    }
}

# Run the menu if the script is called directly
if ($MyInvocation.InvocationName -ne '.') {
    Show-TestMenu
}
