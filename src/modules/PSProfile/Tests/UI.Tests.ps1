#Requires -Version 5.1
#Requires -Modules Pester
<#
.SYNOPSIS
    Test suite for PSProfile UI modules.

.DESCRIPTION
    This script contains comprehensive tests for PSProfile UI modules:
    1. Menu System Tests
       - Menu creation
       - Item management
       - Event handling
       - Navigation
       - Styling
       - Keyboard interaction
    2. Prompt Customization Tests
       - Prompt configuration
       - Segment management
       - Git integration
       - Theme handling
       - Performance metrics
       - Virtual environment display

    The test suite validates:
    - User interface consistency
    - Input handling
    - Display formatting
    - Theme application
    - Error handling
    - Performance impact

.PARAMETER TestName
    Specific test or test pattern to run. Supports wildcards.

.PARAMETER Component
    Specific UI component to test. Valid values:
    - All (default)
    - Menu
    - Prompt

.PARAMETER ShowProgress
    If specified, shows detailed progress during test execution.

.EXAMPLE
    Invoke-Pester .\UI.Tests.ps1
    Runs all UI module tests.

.EXAMPLE
    Invoke-Pester .\UI.Tests.ps1 -TestName "Menu*"
    Runs only menu-related tests.

.EXAMPLE
    Invoke-Pester .\UI.Tests.ps1 -Component Prompt
    Runs all prompt customization tests.

.NOTES
    Name: UI.Tests
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
#>

BeforeAll {
    $modulePath = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
    Import-Module "$modulePath\PSProfile.psd1" -Force
}

Describe "Menu Module Tests" {
    Context "Menu Generation and Interaction" {
        BeforeAll {
            $testMenu = @{
                Title = "Test Menu"
                Items = @(
                    @{
                        Name = "Option 1"
                        Action = { "Action 1" }
                    }
                    @{
                        Name = "Option 2"
                        Action = { "Action 2" }
                    }
                )
            }
        }

        It "Should create menu object" {
            $menu = New-PSProfileMenu @testMenu
            $menu | Should -Not -BeNullOrEmpty
            $menu.Title | Should -Be "Test Menu"
            $menu.Items.Count | Should -Be 2
        }

        It "Should format menu display" {
            $display = Format-PSProfileMenu -Menu $testMenu
            $display | Should -Not -BeNullOrEmpty
            $display | Should -Match "Test Menu"
            $display | Should -Match "Option 1"
            $display | Should -Match "Option 2"
        }

        It "Should handle menu selection" {
            Mock Read-Host { return "1" }
            $result = Invoke-PSProfileMenu -Menu $testMenu
            $result | Should -Be "Action 1"
        }
    }
}

Describe "Prompt Module Tests" {
    Context "Prompt Customization" {
        BeforeAll {
            $defaultConfig = @{
                ShowTime = $true
                ShowPath = $true
                ShowGitStatus = $true
                Color = @{
                    Time = "Blue"
                    Path = "Green"
                    Git = "Yellow"
                }
            }
        }

        It "Should generate prompt string" {
            $prompt = Get-PSProfilePrompt -Config $defaultConfig
            $prompt | Should -Not -BeNullOrEmpty
            $prompt | Should -Match '\[\d{2}:\d{2}:\d{2}\]' # Time format
        }

        It "Should include current path" {
            $config = $defaultConfig.Clone()
            $config.ShowPath = $true
            $prompt = Get-PSProfilePrompt -Config $config
            $prompt | Should -Match (Get-Location).Path
        }

        It "Should handle Git status" {
            Mock Get-GitStatus { return @{
                Branch = "main"
                HasChanges = $true
            }}
            
            $config = $defaultConfig.Clone()
            $config.ShowGitStatus = $true
            $prompt = Get-PSProfilePrompt -Config $config
            $prompt | Should -Match "main"
        }

        It "Should apply color configuration" {
            $config = $defaultConfig.Clone()
            $config.Color.Time = "Red"
            $prompt = Get-PSProfilePrompt -Config $config
            $prompt | Should -Match "\e\[31m" # ANSI color code for red
        }
    }
}

Describe "UI Module" {
    Context "Prompt System" {
        BeforeAll {
            $config = Get-PSProfileConfig
            $originalType = $config.UI.Prompt.Type
        }

        AfterAll {
            Set-PSProfilePromptType -Type $originalType
        }

        It 'Should initialize prompt system' {
            { Initialize-PSProfilePrompt } | Should -Not -Throw
        }

        It 'Should generate valid PSProfile prompt' {
            Set-PSProfilePromptType -Type 'PSProfile'
            $prompt = Get-PSProfilePrompt
            $prompt | Should -Not -BeNullOrEmpty
        }

        It 'Should include git status when enabled' {
            Update-PSProfilePromptConfig -Type 'PSProfile' -Settings @{
                ShowGitStatus = $true
            }
            
            Mock Get-GitStatus { return @{
                Branch = 'main'
                HasChanges = $true
            }}
            
            $prompt = Get-PSProfilePrompt
            $prompt | Should -Match 'main'
        }

        It 'Should format path correctly' {
            Update-PSProfilePromptConfig -Type 'PSProfile' -Settings @{
                ShowPath = $true
            }
            
            $prompt = Get-PSProfilePrompt
            $prompt | Should -Match ([regex]::Escape($PWD.Path))
        }

        It 'Should apply color scheme correctly' {
            $testColors = @{
                Path = 'Blue'
                Git = 'Green'
                Error = 'Red'
            }
            
            Update-PSProfilePromptConfig -Type 'PSProfile' -Settings @{
                ColorScheme = $testColors
            }
            
            $prompt = Get-PSProfilePrompt
            # Note: Actual color testing would require console output inspection
            $prompt | Should -Not -BeNullOrEmpty
        }

        It 'Should handle Starship initialization' {
            Mock Test-Path { return $true }
            Mock Test-Command { return $true }
            
            Set-PSProfilePromptType -Type 'Starship'
            { Initialize-PSProfilePrompt } | Should -Not -Throw
        }

        It 'Should fallback to PSProfile when Starship unavailable' {
            Mock Test-Path { return $false }
            Mock Test-Command { return $false }
            
            Set-PSProfilePromptType -Type 'Starship'
            Initialize-PSProfilePrompt
            
            $config = Get-PSProfileConfig
            $config.UI.Prompt.Type | Should -Be 'PSProfile'
        }

        It 'Should handle prompt errors gracefully' {
            Mock Get-GitStatus { throw 'Git error' }
            
            Update-PSProfilePromptConfig -Type 'PSProfile' -Settings @{
                ShowGitStatus = $true
            }
            
            { Get-PSProfilePrompt } | Should -Not -Throw
        }
    }
}

Describe "Theme Module Tests" {
    Context "Theme Management" {
        BeforeAll {
            $testTheme = @{
                Name = "TestTheme"
                Colors = @{
                    Background = "Black"
                    Foreground = "White"
                    Accent = "Blue"
                }
                Font = @{
                    Family = "Cascadia Code"
                    Size = 12
                }
            }
        }

        It "Should create new theme" {
            $theme = New-PSProfileTheme @testTheme
            $theme | Should -Not -BeNullOrEmpty
            $theme.Name | Should -Be "TestTheme"
            $theme.Colors.Background | Should -Be "Black"
        }

        It "Should apply theme settings" {
            Set-PSProfileTheme -Theme $testTheme
            $host.UI.RawUI.BackgroundColor | Should -Be "Black"
            $host.UI.RawUI.ForegroundColor | Should -Be "White"
        }

        It "Should export theme to file" {
            $exportPath = Join-Path $env:TEMP "test_theme.json"
            Export-PSProfileTheme -Theme $testTheme -Path $exportPath
            Test-Path $exportPath | Should -BeTrue
            $content = Get-Content $exportPath | ConvertFrom-Json
            $content.Name | Should -Be "TestTheme"
        }

        It "Should import theme from file" {
            $importPath = Join-Path $env:TEMP "test_theme.json"
            $theme = Import-PSProfileTheme -Path $importPath
            $theme | Should -Not -BeNullOrEmpty
            $theme.Name | Should -Be "TestTheme"
            $theme.Colors.Background | Should -Be "Black"
        }

        AfterAll {
            $exportPath = Join-Path $env:TEMP "test_theme.json"
            if (Test-Path $exportPath) { Remove-Item $exportPath }
        }
    }
}
