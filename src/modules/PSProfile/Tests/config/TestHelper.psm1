# TestHelper.psm1
using namespace System.IO

$script:TestConfig = $null

function Initialize-TestEnvironment {
    [CmdletBinding()]
    param(
        [string]$ConfigPath = (Join-Path $PSScriptRoot "TestConfig.psd1"),
        [switch]$Force
    )

    if ($script:TestConfig -and -not $Force) {
        return $script:TestConfig
    }

    # Load configuration
    $script:TestConfig = Import-PowerShellDataFile -Path $ConfigPath

    # Create test directories
    $tempRoot = $script:TestConfig.TestEnvironment.TempRoot
    if (Test-Path $tempRoot) {
        if ($Force) {
            Remove-Item $tempRoot -Recurse -Force
        }
    }
    
    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
    
    foreach ($dir in $script:TestConfig.TestEnvironment.Paths.GetEnumerator()) {
        $path = Join-Path $tempRoot $dir.Value
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }

    return $script:TestConfig
}

function Get-TestConfig {
    [CmdletBinding()]
    param()
    
    if (-not $script:TestConfig) {
        Initialize-TestEnvironment
    }
    
    return $script:TestConfig
}

function Get-TestPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Root', 'Logs', 'Config', 'Modules', 'VirtualEnvs', 'SSH', 'Git')]
        [string]$PathType
    )

    $config = Get-TestConfig
    $root = $config.TestEnvironment.TempRoot
    
    if ($PathType -eq 'Root') {
        return $root
    }
    
    return Join-Path $root $config.TestEnvironment.Paths[$PathType]
}

function New-MockGitConfig {
    [CmdletBinding()]
    param()
    
    $config = Get-TestConfig
    return $config.MockData.Git.Config
}

function New-MockGitStatus {
    [CmdletBinding()]
    param()
    
    $config = Get-TestConfig
    return $config.MockData.Git.Status
}

function New-MockSSHKey {
    [CmdletBinding()]
    param(
        [int]$Index = 0
    )
    
    $config = Get-TestConfig
    return $config.MockData.SSH.Keys[$Index]
}

function New-MockVirtualEnv {
    [CmdletBinding()]
    param(
        [int]$Index = 0
    )
    
    $config = Get-TestConfig
    return $config.MockData.VirtualEnv.Environments[$Index]
}

function New-MockWSLDistribution {
    [CmdletBinding()]
    param(
        [int]$Index = 0
    )
    
    $config = Get-TestConfig
    return $config.MockData.WSL.Distributions[$Index]
}

function Get-TestTimeout {
    [CmdletBinding()]
    param(
        [ValidateSet('Default', 'LongRunning', 'Network')]
        [string]$Type = 'Default'
    )
    
    $config = Get-TestConfig
    return $config.TestParameters.Timeouts[$Type]
}

function Test-ShouldRun {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Unit', 'Integration', 'Performance')]
        [string]$Category
    )
    
    $config = Get-TestConfig
    return $config.TestParameters.Categories[$Category].Enabled
}

function Invoke-TestWithRetry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock,
        
        [int]$MaxAttempts = (Get-TestConfig).TestParameters.Retry.MaxAttempts,
        [int]$DelaySeconds = (Get-TestConfig).TestParameters.Retry.DelaySeconds
    )
    
    $attempt = 1
    $success = $false
    $lastError = $null
    
    while (-not $success -and $attempt -le $MaxAttempts) {
        try {
            $result = & $ScriptBlock
            $success = $true
            return $result
        }
        catch {
            $lastError = $_
            Write-Verbose "Attempt $attempt of $MaxAttempts failed: $_"
            if ($attempt -lt $MaxAttempts) {
                Start-Sleep -Seconds $DelaySeconds
            }
            $attempt++
        }
    }
    
    throw "All $MaxAttempts attempts failed. Last error: $lastError"
}

function Initialize-TestReport {
    [CmdletBinding()]
    param(
        [string]$TestRunName = "PSProfile_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    )
    
    $config = Get-TestConfig
    $reportConfig = $config.Reporting
    
    # Create report directories
    $reportPaths = @{
        Base = Join-Path (Get-TestPath -PathType Root) "Reports"
        HTML = Join-Path (Get-TestPath -PathType Root) "Reports/HTML"
        NUnit = Join-Path (Get-TestPath -PathType Root) "Reports/NUnit"
        Logs = Join-Path (Get-TestPath -PathType Root) "Reports/Logs"
    }
    
    foreach ($path in $reportPaths.Values) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
    
    return @{
        Name = $TestRunName
        Paths = $reportPaths
        Config = $reportConfig
    }
}

function Cleanup-TestEnvironment {
    [CmdletBinding()]
    param(
        [switch]$KeepReports
    )
    
    $config = Get-TestConfig
    
    if ($config.TestEnvironment.Cleanup.EnableAutoCleanup) {
        $tempRoot = $config.TestEnvironment.TempRoot
        
        if (Test-Path $tempRoot) {
            if ($KeepReports) {
                # Move reports to a safe location
                $reportsPath = Join-Path $tempRoot "Reports"
                if (Test-Path $reportsPath) {
                    $archivePath = Join-Path ([Path]::GetTempPath()) "PSProfile_TestReports_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                    Move-Item -Path $reportsPath -Destination $archivePath
                    Write-Verbose "Test reports archived to: $archivePath"
                }
            }
            
            Remove-Item -Path $tempRoot -Recurse -Force
        }
    }
}

# Export functions
Export-ModuleMember -Function @(
    'Initialize-TestEnvironment'
    'Get-TestConfig'
    'Get-TestPath'
    'New-MockGitConfig'
    'New-MockGitStatus'
    'New-MockSSHKey'
    'New-MockVirtualEnv'
    'New-MockWSLDistribution'
    'Get-TestTimeout'
    'Test-ShouldRun'
    'Invoke-TestWithRetry'
    'Initialize-TestReport'
    'Cleanup-TestEnvironment'
)
