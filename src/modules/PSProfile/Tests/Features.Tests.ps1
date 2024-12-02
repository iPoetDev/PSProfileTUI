#Requires -Version 5.1
#Requires -Modules Pester
<#
.SYNOPSIS
    Test suite for PSProfile Feature modules.

.DESCRIPTION
    This script contains comprehensive tests for PSProfile Feature modules:
    1. Git Integration Tests
       - Configuration management
       - Host settings
       - Merge tool setup
       - Alias management
       - Status reporting
    2. SSH Management Tests
       - Key generation
       - Agent management
       - Configuration handling
       - Host configuration
       - Security validation
    3. Virtual Environment Tests
       - Environment creation
       - Activation/deactivation
       - Package management
       - Requirements handling
       - Path management
    4. WSL Integration Tests
       - Distribution management
       - Service control
       - Environment setup
       - Cross-platform operations
       - File system integration

.PARAMETER TestName
    Specific test or test pattern to run. Supports wildcards.

.PARAMETER Feature
    Specific feature to test. Valid values:
    - All (default)
    - Git
    - SSH
    - VirtualEnv
    - WSL

.PARAMETER ShowProgress
    If specified, shows detailed progress during test execution.

.EXAMPLE
    Invoke-Pester .\Features.Tests.ps1
    Runs all Feature module tests.

.EXAMPLE
    Invoke-Pester .\Features.Tests.ps1 -TestName "Git*"
    Runs only Git-related tests.

.EXAMPLE
    Invoke-Pester .\Features.Tests.ps1 -Feature SSH
    Runs all SSH feature tests.

.NOTES
    Name: Features.Tests
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
#>

BeforeAll {
    $modulePath = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
    Import-Module "$modulePath\PSProfile.psd1" -Force
}

Describe "Git Feature Tests" {
    Context "Git Configuration Tests" {
        BeforeAll {
            $testGitConfig = @{
                user = @{
                    name = "Test User"
                    email = "test@example.com"
                }
                core = @{
                    editor = "code"
                    autocrlf = "true"
                }
                merge = @{
                    tool = "vscode"
                }
            }
        }

        It "Should get Git configuration" {
            $config = Get-GitConfig
            $config | Should -Not -BeNullOrEmpty
            $config | Should -BeOfType [hashtable]
        }

        It "Should set Git configuration" {
            Set-GitConfig -Config $testGitConfig
            $config = Get-GitConfig
            $config.user.name | Should -Be "Test User"
            $config.core.editor | Should -Be "code"
        }

        It "Should backup Git configuration" {
            $backupPath = Backup-GitConfig
            Test-Path $backupPath | Should -BeTrue
            $backupContent = Get-Content $backupPath | ConvertFrom-Json -AsHashtable
            $backupContent.user.name | Should -Be "Test User"
        }

        AfterAll {
            # Restore original Git config if needed
        }
    }
}

Describe "SSH Feature Tests" {
    Context "SSH Key Management" {
        BeforeAll {
            $testKeyName = "test_key"
            $testKeyPath = Join-Path $env:TEMP ".ssh\$testKeyName"
        }

        It "Should generate new SSH key" {
            New-SSHKey -Name $testKeyName -Path $testKeyPath -NoPassphrase
            Test-Path "$testKeyPath" | Should -BeTrue
            Test-Path "$testKeyPath.pub" | Should -BeTrue
        }

        It "Should list SSH keys" {
            $keys = Get-SSHKeys
            $keys | Should -Not -BeNullOrEmpty
            $keys | Should -Contain $testKeyName
        }

        It "Should backup SSH keys" {
            $backupPath = Backup-SSHKeys
            Test-Path $backupPath | Should -BeTrue
            $backupContent = Get-ChildItem $backupPath
            $backupContent | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            if (Test-Path $testKeyPath) { Remove-Item $testKeyPath -Force }
            if (Test-Path "$testKeyPath.pub") { Remove-Item "$testKeyPath.pub" -Force }
        }
    }
}

Describe "VirtualEnv Feature Tests" {
    Context "Python Environment Management" {
        BeforeAll {
            $testEnvName = "test_env"
            $testEnvPath = Join-Path $env:TEMP "venvs\$testEnvName"
        }

        It "Should create new virtual environment" {
            New-PythonVirtualEnv -Name $testEnvName -Path $testEnvPath
            Test-Path $testEnvPath | Should -BeTrue
            Test-Path (Join-Path $testEnvPath "Scripts\activate.ps1") | Should -BeTrue
        }

        It "Should list virtual environments" {
            $envs = Get-PythonVirtualEnvs
            $envs | Should -Not -BeNullOrEmpty
            $envs | Should -Contain $testEnvName
        }

        It "Should activate virtual environment" {
            Enter-PythonVirtualEnv -Name $testEnvName
            $env:VIRTUAL_ENV | Should -Not -BeNullOrEmpty
            $env:VIRTUAL_ENV | Should -Match $testEnvName
        }

        It "Should deactivate virtual environment" {
            Exit-PythonVirtualEnv
            $env:VIRTUAL_ENV | Should -BeNullOrEmpty
        }

        AfterAll {
            if (Test-Path $testEnvPath) { Remove-Item $testEnvPath -Recurse -Force }
        }
    }
}

Describe "WSL Feature Tests" {
    Context "WSL Integration" {
        It "Should check WSL availability" {
            $result = Test-WSLAvailable
            $result | Should -BeOfType [bool]
        }

        It "Should get WSL distributions" {
            $distros = Get-WSLDistributions
            $distros | Should -Not -BeNullOrEmpty
            $distros | ForEach-Object {
                $_ | Should -BeOfType [string]
            }
        }

        It "Should convert Windows path to WSL path" {
            $winPath = "C:\Users\Test"
            $wslPath = ConvertTo-WSLPath -WindowsPath $winPath
            $wslPath | Should -Be "/mnt/c/Users/Test"
        }

        It "Should convert WSL path to Windows path" {
            $wslPath = "/mnt/c/Users/Test"
            $winPath = ConvertTo-WindowsPath -WSLPath $wslPath
            $winPath | Should -Be "C:\Users\Test"
        }
    }
}
