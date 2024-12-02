# PSProfile Logging System

## Overview
The Logging module provides a robust, flexible logging system for PSProfile, offering comprehensive logging capabilities with multiple output targets, log levels, and formatting options. It serves as the central logging infrastructure for all PSProfile components.

## Features

### 1. Log Levels
```powershell
# Available log levels
Write-PSProfileLog -Level Debug -Message "Detailed debugging information"
Write-PSProfileLog -Level Info -Message "General information"
Write-PSProfileLog -Level Warning -Message "Warning conditions"
Write-PSProfileLog -Level Error -Message "Error conditions"
Write-PSProfileLog -Level Critical -Message "Critical conditions"
```

### 2. Output Targets
```powershell
# File logging
Set-LogTarget -Type File -Path "~/.psprofile/logs/profile.log"

# Console output
Set-LogTarget -Type Console -Enabled $true

# Event Log
Set-LogTarget -Type EventLog -Source "PSProfile"

# Custom target
Set-LogTarget -Type Custom -Handler {
    param($LogEntry)
    # Custom logging logic
}
```

### 3. Log Formatting
```powershell
# Default format
$LogFormat = @{
    TimeStamp = "yyyy-MM-dd HH:mm:ss"
    Template = "{Timestamp} [{Level}] {Message}"
    IncludeSource = $true
    IncludeStack = $false
}

# Set format
Set-LogFormat -Format $LogFormat
```

### 4. Performance Logging
```powershell
# Start timing
Start-LogTimer -Name "Operation"

# Stop and log
Stop-LogTimer -Name "Operation"

# Performance snapshot
Get-LogPerformance | Export-LogReport
```

## Configuration

### Default Settings
```powershell
$LoggingConfig = @{
    DefaultLevel = "Info"
    MaxLogSize = "10MB"
    RetentionDays = 30
    AutoRotate = $true
    AsyncLogging = $true
    IncludeTimestamp = $true
    IncludeSource = $true
}
```

### Custom Configuration
```powershell
# Set configuration
Set-LoggingConfiguration -Config $LoggingConfig

# Get current configuration
Get-LoggingConfiguration

# Reset to defaults
Reset-LoggingConfiguration
```

## Log File Management

### 1. Log Rotation
```powershell
# Configure rotation
Set-LogRotation -MaxSize "10MB" -MaxFiles 5

# Manual rotation
Start-LogRotation

# Clean old logs
Clear-OldLogs -DaysToKeep 30
```

### 2. Log Analysis
```powershell
# Search logs
Search-Logs -Pattern "error" -LastHours 24

# Get log statistics
Get-LogStats -TimeRange "Today"

# Export log report
Export-LogReport -Path "./report.html"
```

## Usage Examples

### Basic Logging
```powershell
# Simple logging
Write-PSProfileLog "Operation completed successfully"

# Structured logging
Write-PSProfileLog -Level Info -Message "User logged in" -Data @{
    Username = $env:USERNAME
    Time = Get-Date
}

# Error logging with stack trace
Write-PSProfileLog -Level Error -Message "Operation failed" -Exception $_ -IncludeStack
```

### Advanced Scenarios
```powershell
# Transaction logging
Start-LogTransaction -Name "UserOperation"
try {
    # Operation steps
    Write-PSProfileLog "Step 1 completed"
    Write-PSProfileLog "Step 2 completed"
    Complete-LogTransaction
} catch {
    Undo-LogTransaction
}

# Performance monitoring
Measure-LoggedOperation -Name "DatabaseQuery" -ScriptBlock {
    # Long running operation
}

# Batch logging
Start-LogBatch
Write-PSProfileLog "Multiple"
Write-PSProfileLog "Log"
Write-PSProfileLog "Entries"
Complete-LogBatch
```

## Integration

### 1. Module Integration
```powershell
# Register module logger
Register-ModuleLogger -Name "MyModule" -MinLevel "Debug"

# Module-specific logging
$ModuleLogger = Get-ModuleLogger -Name "MyModule"
$ModuleLogger.Log("Operation completed")
```

### 2. Error Handling
```powershell
# Error logging
try {
    # Operation
} catch {
    Write-PSProfileLog -Level Error -Message $_.Exception.Message -Exception $_
}

# Warning conditions
if ($condition) {
    Write-PSProfileLog -Level Warning -Message "Unusual condition detected"
}
```

### 3. Event Integration
```powershell
# Log event handler
Register-LogEventHandler -Event "ConfigChanged" -Action {
    Write-PSProfileLog "Configuration changed"
}

# Custom event logging
New-LogEvent -Name "CustomEvent" -Data @{
    EventType = "UserAction"
    Details = "Custom operation"
}
```

## Best Practices

### 1. Log Levels
- DEBUG: Detailed debugging information
- INFO: General information
- WARNING: Warning conditions
- ERROR: Error conditions
- CRITICAL: Critical conditions

### 2. Message Guidelines
- Be specific and descriptive
- Include relevant data
- Use consistent formatting
- Avoid sensitive information
- Include correlation IDs

### 3. Performance
- Use async logging when possible
- Batch related log entries
- Configure appropriate log levels
- Implement log rotation
- Monitor log size

## Troubleshooting

### Common Issues
1. **Log File Access**
   ```powershell
   # Test log path
   Test-LogPath -Path $logPath
   
   # Fix permissions
   Repair-LogPermissions
   ```

2. **Performance Issues**
   ```powershell
   # Check log stats
   Get-LogPerformance
   
   # Optimize settings
   Optimize-LogConfiguration
   ```

3. **Disk Space**
   ```powershell
   # Clean old logs
   Clear-OldLogs
   
   # Compress logs
   Compress-Logs
   ```

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support
- Report issues on GitHub
- Check documentation
- Contact maintainers

## License
Same as PSProfile module
