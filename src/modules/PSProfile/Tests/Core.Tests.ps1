#Requires -Version 5.1
#Requires -Modules Pester
<#
.SYNOPSIS
    Test suite for PSProfile Core modules.

.DESCRIPTION
    This script contains comprehensive tests for PSProfile Core modules:
    1. Logging Module Tests
       - Error logging functionality
       - Debug logging
       - Log file management
       - Performance timing
       - Log rotation
    2. Configuration Module Tests
       - Configuration loading/saving
       - Default settings
       - User preferences
       - Configuration validation
       - Import/Export functionality
    3. Initialize Module Tests
       - System initialization
       - Module loading
       - Feature activation
       - Dependency checks
       - Error handling

.PARAMETER TestName
    Specific test or test pattern to run. Supports wildcards.

.PARAMETER ShowProgress
    If specified, shows detailed progress during test execution.

.EXAMPLE
    Invoke-Pester .\Core.Tests.ps1
    Runs all Core module tests.

.EXAMPLE
    Invoke-Pester .\Core.Tests.ps1 -TestName "Logging*"
    Runs only logging-related tests.

.NOTES
    Name: Core.Tests
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
#>

BeforeAll {
    $modulePath = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
    Import-Module "$modulePath\PSProfile.psd1" -Force
}

Describe "Core Module Tests" {
    Context "Logging Tests" {
        BeforeAll {
            $logPath = Join-Path $env:TEMP "PSProfile_Test.log"
            if (Test-Path $logPath) { Remove-Item $logPath }
        }

        It "Should create new log file" {
            Write-PSProfileLog -Message "Test message" -LogPath $logPath
            Test-Path $logPath | Should -BeTrue
        }

        It "Should append to existing log file" {
            $initialContent = Get-Content $logPath
            Write-PSProfileLog -Message "Another test" -LogPath $logPath
            $newContent = Get-Content $logPath
            $newContent.Count | Should -BeGreaterThan $initialContent.Count
        }

        It "Should include timestamp in log entry" {
            Write-PSProfileLog -Message "Timestamp test" -LogPath $logPath
            $lastEntry = Get-Content $logPath | Select-Object -Last 1
            $lastEntry | Should -Match '^\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\]'
        }

        AfterAll {
            if (Test-Path $logPath) { Remove-Item $logPath }
        }
    }

    Context "Configuration Tests" {
        BeforeAll {
            $testConfig = @{
                Features = @{
                    Git = $true
                    SSH = $true
                    VirtualEnv = $false
                }
                Paths = @{
                    Logs = "TestLogs"
                    Data = "TestData"
                }
            }
            $configPath = Join-Path $env:TEMP "PSProfile_test_config.json"
            $testConfig | ConvertTo-Json | Set-Content $configPath
        }

        It "Should load configuration from file" {
            $config = Get-PSProfileConfig -ConfigPath $configPath
            $config | Should -Not -BeNullOrEmpty
            $config.Features.Git | Should -BeTrue
            $config.Paths.Logs | Should -Be "TestLogs"
        }

        It "Should create default configuration if none exists" {
            $tempPath = Join-Path $env:TEMP "nonexistent_config.json"
            $config = Get-PSProfileConfig -ConfigPath $tempPath
            $config | Should -Not -BeNullOrEmpty
            $config.Features | Should -Not -BeNullOrEmpty
        }

        It "Should merge configurations correctly" {
            $defaultConfig = @{
                Features = @{
                    Git = $false
                    SSH = $false
                    WSL = $false
                }
                Paths = @{
                    Logs = "DefaultLogs"
                }
            }
            $userConfig = @{
                Features = @{
                    Git = $true
                }
                Paths = @{
                    Data = "UserData"
                }
            }
            $merged = Merge-PSProfileConfig -DefaultConfig $defaultConfig -UserConfig $userConfig
            $merged.Features.Git | Should -BeTrue
            $merged.Features.SSH | Should -BeFalse
            $merged.Paths.Logs | Should -Be "DefaultLogs"
            $merged.Paths.Data | Should -Be "UserData"
        }

        AfterAll {
            if (Test-Path $configPath) { Remove-Item $configPath }
        }
    }

    Context "Prompt Configuration" {
        BeforeAll {
            $defaultConfig = Get-PSProfileConfig
        }

        It "Should have default prompt configuration" {
            $defaultConfig.UI.Prompt | Should -Not -BeNullOrEmpty
            $defaultConfig.UI.Prompt.Type | Should -BeIn @('Starship', 'PSProfile')
        }

        It "Should allow switching prompt types" {
            Set-PSProfilePromptType -Type 'PSProfile'
            $config = Get-PSProfileConfig
            $config.UI.Prompt.Type | Should -Be 'PSProfile'

            Set-PSProfilePromptType -Type 'Starship'
            $config = Get-PSProfileConfig
            $config.UI.Prompt.Type | Should -Be 'Starship'
        }

        It "Should update Starship configuration" {
            $testConfig = @{
                ConfigPath = '~/.config/test-starship.toml'
                CachePath = '~/.starship/test-cache'
            }
            
            Update-PSProfilePromptConfig -Type 'Starship' -Settings $testConfig
            $config = Get-PSProfileConfig
            
            $config.UI.Prompt.Config.Starship.ConfigPath | Should -Be $testConfig.ConfigPath
            $config.UI.Prompt.Config.Starship.CachePath | Should -Be $testConfig.CachePath
        }

        It "Should update PSProfile prompt settings" {
            $testSettings = @{
                ShowGitStatus = $true
                ShowPath = $true
                ShowTime = $false
                ColorScheme = @{
                    Path = 'Blue'
                    Git = 'Green'
                    Error = 'Red'
                }
            }
            
            Update-PSProfilePromptConfig -Type 'PSProfile' -Settings $testSettings
            $config = Get-PSProfileConfig
            
            $config.UI.Prompt.Config.PSProfile.ShowGitStatus | Should -Be $testSettings.ShowGitStatus
            $config.UI.Prompt.Config.PSProfile.ShowPath | Should -Be $testSettings.ShowPath
            $config.UI.Prompt.Config.PSProfile.ShowTime | Should -Be $testSettings.ShowTime
            $config.UI.Prompt.Config.PSProfile.ColorScheme.Path | Should -Be $testSettings.ColorScheme.Path
            $config.UI.Prompt.Config.PSProfile.ColorScheme.Git | Should -Be $testSettings.ColorScheme.Git
            $config.UI.Prompt.Config.PSProfile.ColorScheme.Error | Should -Be $testSettings.ColorScheme.Error
        }

        It "Should validate color schemes" {
            { Update-PSProfilePromptConfig -Type 'PSProfile' -Settings @{
                ColorScheme = @{ Path = 'InvalidColor' }
            }} | Should -Throw
        }

        It "Should handle missing Starship gracefully" {
            Mock Test-Path { return $false }
            Set-PSProfilePromptType -Type 'Starship'
            $config = Get-PSProfileConfig
            $config.UI.Prompt.Type | Should -Be 'PSProfile'
        }
    }

    Context "Initialization Tests" {
        It "Should initialize all required paths" {
            $paths = Initialize-PSProfilePaths
            $paths | Should -Not -BeNullOrEmpty
            $paths.Root | Should -Not -BeNullOrEmpty
            $paths.Modules | Should -Not -BeNullOrEmpty
            $paths.Logs | Should -Not -BeNullOrEmpty
        }

        It "Should create missing directories" {
            $testPath = Join-Path $env:TEMP "PSProfile_Test_Init"
            $paths = Initialize-PSProfilePaths -Root $testPath
            Test-Path $paths.Root | Should -BeTrue
            Test-Path $paths.Modules | Should -BeTrue
            Test-Path $paths.Logs | Should -BeTrue
        }
    }
}
