#Requires -Version 5.1
<#
.SYNOPSIS
    Provides logging functionality for PSProfile.

.DESCRIPTION
    The Logging module provides comprehensive logging capabilities for PSProfile,
    including error logging, debug logging, and performance tracking.

.NOTES
    Name: Logging
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
#>

# Script Variables
$script:LogPath = Join-Path $env:USERPROFILE '.pwsh\Logs'
$script:LogFile = Join-Path $script:LogPath 'PSProfile.log'

function Write-ErrorLog {
    <#
    .SYNOPSIS
        Writes an error message to the PSProfile log file.

    .DESCRIPTION
        This function writes detailed error information to the PSProfile log file,
        including stack trace, error message, and category info.

    .PARAMETER ErrorRecord
        The PowerShell error record to log.

    .PARAMETER Area
        The area of the code where the error occurred.

    .PARAMETER AdditionalInfo
        Additional message to include with the error.

    .EXAMPLE
        try {
            # Some code that might fail
        }
        catch {
            Write-ErrorLog -ErrorRecord $_ -Area 'Configuration'
        }

        Logs an error that occurred in the Configuration area.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,

        [Parameter()]
        [string]$Area = 'General',

        [Parameter()]
        [string]$AdditionalInfo
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $errorFile = Join-Path $script:LogPath "error_${Area}_${timestamp}.log"
    
    $errorLog = @"
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Area: $Area
Error Message: $($ErrorRecord.Exception.Message)
Error Type: $($ErrorRecord.Exception.GetType().FullName)
Command: $($ErrorRecord.InvocationInfo.MyCommand)
Line Number: $($ErrorRecord.InvocationInfo.ScriptLineNumber)
Position: $($ErrorRecord.InvocationInfo.PositionMessage)
Stack Trace:
$($ErrorRecord.ScriptStackTrace)

Additional Info:
$AdditionalInfo

Full Error Record:
$($ErrorRecord | Format-List * | Out-String)
"@

    $errorLog | Out-File -FilePath $errorFile -Encoding utf8
    Write-Warning "Error logged to: $errorFile"
}

function Write-DebugLog {
    <#
    .SYNOPSIS
        Writes a debug message to the PSProfile log file.

    .DESCRIPTION
        This function writes debug information to the PSProfile log file,
        useful for troubleshooting and development.

    .PARAMETER Message
        The debug message to log.

    .PARAMETER Area
        The area of the code generating the debug message.

    .PARAMETER Level
        The debug level (1-5, where 5 is most verbose).

    .EXAMPLE
        Write-DebugLog -Message "Loading configuration" -Area "Initialize" -Level 2
        Logs a debug message about loading configuration.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [Parameter()]
        [string]$Area = 'General',

        [Parameter()]
        [ValidateRange(1,5)]
        [int]$Level = 1
    )
    {{ ... }}
}

function Start-LogTimer {
    <#
    .SYNOPSIS
        Starts a performance timer for logging purposes.

    .DESCRIPTION
        This function starts a timer to measure the performance of operations.
        Used in conjunction with Stop-LogTimer.

    .PARAMETER Name
        The name of the timer.

    .EXAMPLE
        Start-LogTimer -Name "ConfigLoad"
        # Some operation to time
        Stop-LogTimer -Name "ConfigLoad"

        Times how long it takes to load configuration.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )
    {{ ... }}
}

function Stop-LogTimer {
    <#
    .SYNOPSIS
        Stops a performance timer and logs the duration.

    .DESCRIPTION
        This function stops a timer started by Start-LogTimer and logs
        the duration of the operation.

    .PARAMETER Name
        The name of the timer to stop.

    .EXAMPLE
        Start-LogTimer -Name "ModuleLoad"
        Import-Module SomeModule
        Stop-LogTimer -Name "ModuleLoad"

        Measures and logs how long it takes to import a module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )
    {{ ... }}
}

function Clear-PSProfileLogs {
    <#
    .SYNOPSIS
        Clears the PSProfile log files.

    .DESCRIPTION
        This function clears all or specific PSProfile log files.

    .PARAMETER LogType
        The type of logs to clear. Valid values are:
        - All: Clears all logs
        - Error: Clears only error logs
        - Debug: Clears only debug logs
        - Performance: Clears only performance logs

    .PARAMETER DaysToKeep
        Number of days of logs to keep. Older logs will be removed.

    .EXAMPLE
        Clear-PSProfileLogs -LogType All
        Clears all PSProfile logs.

    .EXAMPLE
        Clear-PSProfileLogs -LogType Error -DaysToKeep 7
        Clears error logs older than 7 days.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('All', 'Error', 'Debug', 'Performance')]
        [string]$LogType = 'All',

        [Parameter()]
        [int]$DaysToKeep = 30
    )
    {{ ... }}
}

function Write-PerformanceLog {
    [CmdletBinding()]
    param(
        [string]$Operation,
        [double]$Duration,
        [hashtable]$Metrics = @{},
        [string]$Area = 'Performance'
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $perfFile = Join-Path $script:LogPath "perf_${Area}_${timestamp}.log"
    
    $perfLog = @"
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Operation: $Operation
Duration: $Duration ms
Metrics:
$($Metrics | ConvertTo-Json)
"@

    $perfLog | Out-File -FilePath $perfFile -Encoding utf8
}

# Export functions
Export-ModuleMember -Function @(
    'Write-ErrorLog'
    'Write-DebugLog'
    'Start-LogTimer'
    'Stop-LogTimer'
    'Clear-PSProfileLogs'
    'Write-PerformanceLog'
)
