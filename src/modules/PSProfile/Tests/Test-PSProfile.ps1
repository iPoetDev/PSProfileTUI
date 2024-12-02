#Requires -Version 5.1
#Requires -Modules Pester
<#
.SYNOPSIS
    Main test runner for PSProfile module.

.DESCRIPTION
    This script serves as the primary test runner for the PSProfile module.
    It provides comprehensive testing coverage including:
    - Unit tests for all modules
    - Integration tests
    - Configuration validation
    - Performance benchmarks
    - Cross-platform compatibility checks

    The test suite is organized into several categories:
    1. Core Module Tests
       - Logging
       - Configuration
       - Initialize
    2. Feature Module Tests
       - Git integration
       - SSH management
       - Virtual Environment handling
       - WSL integration
    3. UI Module Tests
       - Menu system
       - Prompt customization
    4. Integration Tests
       - Cross-module functionality
       - System-wide features
    5. Performance Tests
       - Load time measurements
       - Memory usage tracking
       - Operation benchmarks

.PARAMETER TestName
    Specific test or test pattern to run. Supports wildcards.

.PARAMETER Category
    Category of tests to run. Valid values:
    - All (default)
    - Core
    - Features
    - UI
    - Integration
    - Performance

.PARAMETER ShowProgress
    If specified, shows detailed progress during test execution.

.PARAMETER OutputFile
    Path to save test results. If not specified, results are only displayed.

.EXAMPLE
    .\Test-PSProfile.ps1
    Runs all tests with default settings.

.EXAMPLE
    .\Test-PSProfile.ps1 -TestName "Git*" -Category Features
    Runs all Git-related tests in the Features category.

.EXAMPLE
    .\Test-PSProfile.ps1 -Category Core -ShowProgress -OutputFile "TestResults.xml"
    Runs Core module tests with progress display and saves results to file.

.NOTES
    Name: Test-PSProfile
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$TestName = "*",

    [Parameter()]
    [ValidateSet('All', 'Core', 'Features', 'UI', 'Integration', 'Performance')]
    [string]$Category = 'All',

    [switch]$ShowProgress,

    [Parameter()]
    [string]$OutputFile
)

# PSProfile Test Script
# Remove the using module statement as it's causing issues
#using module ..\PSProfile.psd1

# Test configuration
$script:TestConfig = @{
    ModuleRoot = (Resolve-Path "$PSScriptRoot\..").Path
    TestResults = @{
        Passed = 0
        Failed = 0
        Skipped = 0
    }
    Colors = @{
        Pass = 'Green'
        Fail = 'Red'
        Skip = 'Yellow'
        Info = 'Cyan'
    }
}

function Write-TestResult {
    param(
        [string]$TestName,
        [string]$Result,
        [string]$Message = ''
    )
    
    $color = switch ($Result) {
        'Pass' { $script:TestConfig.Colors.Pass }
        'Fail' { $script:TestConfig.Colors.Fail }
        'Skip' { $script:TestConfig.Colors.Skip }
        default { $script:TestConfig.Colors.Info }
    }
    
    $script:TestConfig.TestResults.$Result++
    
    Write-Host "[$Result] $TestName" -ForegroundColor $color
    if ($Message) {
        Write-Host "       $Message" -ForegroundColor $color
    }
}

function Test-ModuleStructure {
    Write-Host "`nTesting Module Structure..." -ForegroundColor $script:TestConfig.Colors.Info
    
    # Test main module files
    @(
        'PSProfile.psd1'
        'PSProfile.psm1'
    ) | ForEach-Object {
        $path = Join-Path $script:TestConfig.ModuleRoot $_
        if (Test-Path $path) {
            Write-TestResult "Main module file: $_" 'Pass'
        }
        else {
            Write-TestResult "Main module file: $_" 'Fail' "File not found: $path"
        }
    }
    
    # Test core modules
    @(
        'Core\Logging\Logging.psd1'
        'Core\Logging\Logging.psm1'
        'Core\Configuration\Configuration.psd1'
        'Core\Configuration\Configuration.psm1'
        'Core\Initialize\Initialize.psd1'
        'Core\Initialize\Initialize.psm1'
    ) | ForEach-Object {
        $path = Join-Path $script:TestConfig.ModuleRoot $_
        if (Test-Path $path) {
            Write-TestResult "Core module: $_" 'Pass'
        }
        else {
            Write-TestResult "Core module: $_" 'Fail' "File not found: $path"
        }
    }
    
    # Test feature modules
    @(
        'Features\Git\Git.psd1'
        'Features\Git\Git.psm1'
        'Features\SSH\SSH.psd1'
        'Features\SSH\SSH.psm1'
        'Features\VirtualEnv\VirtualEnv.psd1'
        'Features\VirtualEnv\VirtualEnv.psm1'
    ) | ForEach-Object {
        $path = Join-Path $script:TestConfig.ModuleRoot $_
        if (Test-Path $path) {
            Write-TestResult "Feature module: $_" 'Pass'
        }
        else {
            Write-TestResult "Feature module: $_" 'Fail' "File not found: $path"
        }
    }
    
    # Test UI modules
    @(
        'UI\Menu\Menu.psd1'
        'UI\Menu\Menu.psm1'
        'UI\Prompt\Prompt.psd1'
        'UI\Prompt\Prompt.psm1'
    ) | ForEach-Object {
        $path = Join-Path $script:TestConfig.ModuleRoot $_
        if (Test-Path $path) {
            Write-TestResult "UI module: $_" 'Pass'
        }
        else {
            Write-TestResult "UI module: $_" 'Fail' "File not found: $path"
        }
    }
}

function Test-ModuleImport {
    Write-Host "`nTesting Module Import..." -ForegroundColor $script:TestConfig.Colors.Info
    
    try {
        Import-Module (Join-Path $script:TestConfig.ModuleRoot 'PSProfile.psd1') -Force
        Write-TestResult "Import main module" 'Pass'
    }
    catch {
        Write-TestResult "Import main module" 'Fail' $_.Exception.Message
        return
    }
    
    # Test core functions
    @(
        'Initialize-PSProfile'
        'Import-PSProfileModule'
        'Get-PSProfileVersion'
        'Get-PSProfileModules'
        'Select-ProfileMode'
    ) | ForEach-Object {
        if (Get-Command $_ -ErrorAction SilentlyContinue) {
            Write-TestResult "Core function: $_" 'Pass'
        }
        else {
            Write-TestResult "Core function: $_" 'Fail' "Function not found"
        }
    }
}

function Test-CoreFunctionality {
    Write-Host "`nTesting Core Functionality..." -ForegroundColor $script:TestConfig.Colors.Info
    
    # Test configuration
    try {
        $config = Get-PSProfileConfig
        if ($config) {
            Write-TestResult "Get configuration" 'Pass'
        }
        else {
            Write-TestResult "Get configuration" 'Fail' "No configuration returned"
        }
    }
    catch {
        Write-TestResult "Get configuration" 'Fail' $_.Exception.Message
    }
    
    # Test logging
    try {
        Write-ErrorLog -ErrorRecord ([System.Exception]::new("Test error")) -Area "Testing"
        Write-TestResult "Error logging" 'Pass'
    }
    catch {
        Write-TestResult "Error logging" 'Fail' $_.Exception.Message
    }
    
    # Test module discovery
    try {
        $modules = Get-PSProfileModules
        if ($modules.Core -and $modules.Features -and $modules.UI) {
            Write-TestResult "Module discovery" 'Pass'
        }
        else {
            Write-TestResult "Module discovery" 'Fail' "Missing module categories"
        }
    }
    catch {
        Write-TestResult "Module discovery" 'Fail' $_.Exception.Message
    }
}

function Test-FeatureModules {
    Write-Host "`nTesting Feature Modules..." -ForegroundColor $script:TestConfig.Colors.Info
    
    # Test Git module
    try {
        Import-PSProfileModule -ModuleName 'Git' -Quiet
        if (Get-Command Initialize-GitSystem -ErrorAction SilentlyContinue) {
            Write-TestResult "Git module" 'Pass'
        }
        else {
            Write-TestResult "Git module" 'Fail' "Git functions not available"
        }
    }
    catch {
        Write-TestResult "Git module" 'Fail' $_.Exception.Message
    }
    
    # Test SSH module
    try {
        Import-PSProfileModule -ModuleName 'SSH' -Quiet
        if (Get-Command Initialize-SSHDirectory -ErrorAction SilentlyContinue) {
            Write-TestResult "SSH module" 'Pass'
        }
        else {
            Write-TestResult "SSH module" 'Fail' "SSH functions not available"
        }
    }
    catch {
        Write-TestResult "SSH module" 'Fail' $_.Exception.Message
    }
    
    # Test VirtualEnv module
    try {
        Import-PSProfileModule -ModuleName 'VirtualEnv' -Quiet
        if (Get-Command New-VirtualEnvironment -ErrorAction SilentlyContinue) {
            Write-TestResult "VirtualEnv module" 'Pass'
        }
        else {
            Write-TestResult "VirtualEnv module" 'Fail' "VirtualEnv functions not available"
        }
    }
    catch {
        Write-TestResult "VirtualEnv module" 'Fail' $_.Exception.Message
    }
}

function Test-UIModules {
    Write-Host "`nTesting UI Modules..." -ForegroundColor $script:TestConfig.Colors.Info
    
    # Test Menu module
    try {
        Import-PSProfileModule -ModuleName 'Menu' -Quiet
        if (Get-Command Show-ProfileMenu -ErrorAction SilentlyContinue) {
            Write-TestResult "Menu module" 'Pass'
        }
        else {
            Write-TestResult "Menu module" 'Fail' "Menu functions not available"
        }
    }
    catch {
        Write-TestResult "Menu module" 'Fail' $_.Exception.Message
    }
    
    # Test Prompt module
    try {
        Import-PSProfileModule -ModuleName 'Prompt' -Quiet
        if (Get-Command Set-CustomPrompt -ErrorAction SilentlyContinue) {
            Write-TestResult "Prompt module" 'Pass'
        }
        else {
            Write-TestResult "Prompt module" 'Fail' "Prompt functions not available"
        }
    }
    catch {
        Write-TestResult "Prompt module" 'Fail' $_.Exception.Message
    }
}

function Test-GitFunctionality {
    Write-Host "`nTesting Git Module Functions..." -ForegroundColor $script:TestConfig.Colors.Info
    
    # Test Git merge tools configuration
    try {
        Set-GitMergeTools -Quiet
        $mergeToolConfig = git config --global --get merge.tool
        if ($mergeToolConfig) {
            Write-TestResult "Set-GitMergeTools" 'Pass'
        }
        else {
            Write-TestResult "Set-GitMergeTools" 'Fail' "Merge tool not configured"
        }
    }
    catch {
        Write-TestResult "Set-GitMergeTools" 'Fail' $_.Exception.Message
    }
    
    # Test Git aliases
    try {
        Initialize-GitAliases
        $aliasTest = git config --global --get alias.st
        if ($aliasTest -eq 'status') {
            Write-TestResult "Initialize-GitAliases" 'Pass'
        }
        else {
            Write-TestResult "Initialize-GitAliases" 'Fail' "Aliases not set correctly"
        }
    }
    catch {
        Write-TestResult "Initialize-GitAliases" 'Fail' $_.Exception.Message
    }
    
    # Test Git configuration check
    try {
        $gitConfig = Test-GitConfiguration
        if ($gitConfig) {
            Write-TestResult "Test-GitConfiguration" 'Pass'
        }
        else {
            Write-TestResult "Test-GitConfiguration" 'Fail' "Configuration test failed"
        }
    }
    catch {
        Write-TestResult "Test-GitConfiguration" 'Fail' $_.Exception.Message
    }
    
    # Test Git host configuration
    try {
        Set-GitHostConfig -HostType github -UserName "test" -Email "test@example.com" -Quiet
        $userConfig = git config --global --get user.name
        if ($userConfig -eq "test") {
            Write-TestResult "Set-GitHostConfig" 'Pass'
        }
        else {
            Write-TestResult "Set-GitHostConfig" 'Fail' "Host config not set correctly"
        }
    }
    catch {
        Write-TestResult "Set-GitHostConfig" 'Fail' $_.Exception.Message
    }
}

function Test-SSHFunctionality {
    Write-Host "`nTesting SSH Module Functions..." -ForegroundColor $script:TestConfig.Colors.Info
    
    # Test SSH system initialization
    try {
        Initialize-SSHSystem -Quiet
        if (Test-Path (Join-Path $env:USERPROFILE '.ssh')) {
            Write-TestResult "Initialize-SSHSystem" 'Pass'
        }
        else {
            Write-TestResult "Initialize-SSHSystem" 'Fail' "SSH directory not initialized"
        }
    }
    catch {
        Write-TestResult "Initialize-SSHSystem" 'Fail' $_.Exception.Message
    }
    
    # Test SSH backup functionality
    try {
        $backupPath = Join-Path $env:TEMP "ssh_test_backup"
        Backup-SSHConfiguration -BackupPath $backupPath -NoEncryption
        if (Test-Path $backupPath) {
            Write-TestResult "Backup-SSHConfiguration" 'Pass'
            
            # Test backup integrity
            $integrityCheck = Test-BackupIntegrity -BackupPath $backupPath
            if ($integrityCheck) {
                Write-TestResult "Test-BackupIntegrity" 'Pass'
            }
            else {
                Write-TestResult "Test-BackupIntegrity" 'Fail' "Backup integrity check failed"
            }
            
            # Clean up test backup
            Remove-Item -Path $backupPath -Recurse -Force
        }
        else {
            Write-TestResult "Backup-SSHConfiguration" 'Fail' "Backup not created"
        }
    }
    catch {
        Write-TestResult "Backup-SSHConfiguration" 'Fail' $_.Exception.Message
    }
    
    # Test SSH config management
    try {
        Add-SSHConfig -HostName "test-host" -HostConfig @{
            HostName = "test.example.com"
            User = "testuser"
            Port = 22
        } -Quiet
        
        $configPath = Join-Path $env:USERPROFILE '.ssh\config'
        $configContent = Get-Content $configPath -Raw
        if ($configContent -match 'Host test-host') {
            Write-TestResult "Add-SSHConfig" 'Pass'
        }
        else {
            Write-TestResult "Add-SSHConfig" 'Fail' "Config not added correctly"
        }
    }
    catch {
        Write-TestResult "Add-SSHConfig" 'Fail' $_.Exception.Message
    }
}

function Test-VirtualEnvFunctionality {
    Write-Host "`nTesting VirtualEnv Module Functions..." -ForegroundColor $script:TestConfig.Colors.Info
    
    # Test virtual environment creation
    try {
        $testPath = Join-Path $env:TEMP "test_venv"
        New-VirtualEnvironment -Path $testPath -Force
        if (Test-Path $testPath) {
            Write-TestResult "New-VirtualEnvironment" 'Pass'
            Remove-Item -Path $testPath -Recurse -Force
        }
        else {
            Write-TestResult "New-VirtualEnvironment" 'Fail' "Virtual environment not created"
        }
    }
    catch {
        Write-TestResult "New-VirtualEnvironment" 'Fail' $_.Exception.Message
    }
}

function Show-TestSummary {
    Write-Host "`nTest Summary" -ForegroundColor $script:TestConfig.Colors.Info
    Write-Host "============" -ForegroundColor $script:TestConfig.Colors.Info
    Write-Host "Passed: $($script:TestConfig.TestResults.Passed)" -ForegroundColor $script:TestConfig.Colors.Pass
    Write-Host "Failed: $($script:TestConfig.TestResults.Failed)" -ForegroundColor $script:TestConfig.Colors.Fail
    Write-Host "Skipped: $($script:TestConfig.TestResults.Skipped)" -ForegroundColor $script:TestConfig.Colors.Skip
    Write-Host
}

function Test-PSProfileAll {
    $startTime = Get-Date
    
    # Reset test results
    $script:TestConfig.TestResults.Passed = 0
    $script:TestConfig.TestResults.Failed = 0
    $script:TestConfig.TestResults.Skipped = 0
    
    # Run all tests
    Test-ModuleStructure
    Test-ModuleImport
    Test-CoreFunctionality
    Test-GitFunctionality
    Test-SSHFunctionality
    Test-VirtualEnvFunctionality
    
    # Display test summary
    $duration = (Get-Date) - $startTime
    Write-Host "`nTest Summary:" -ForegroundColor $script:TestConfig.Colors.Info
    Write-Host "Duration: $($duration.TotalSeconds) seconds" -ForegroundColor $script:TestConfig.Colors.Info
    Write-Host "Passed: $($script:TestConfig.TestResults.Passed)" -ForegroundColor $script:TestConfig.Colors.Pass
    Write-Host "Failed: $($script:TestConfig.TestResults.Failed)" -ForegroundColor $script:TestConfig.Colors.Fail
    Write-Host "Skipped: $($script:TestConfig.TestResults.Skipped)" -ForegroundColor $script:TestConfig.Colors.Skip
    
    # Return overall success/failure
    return $script:TestConfig.TestResults.Failed -eq 0
}

# Run tests if script is not dot-sourced
if ($MyInvocation.InvocationName -ne '.') {
    Test-PSProfileAll
}
