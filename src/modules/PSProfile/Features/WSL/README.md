# WSL Module for PSProfile

## Overview
The WSL (Windows Subsystem for Linux) module provides seamless integration between PowerShell and WSL environments, offering advanced management capabilities and cross-platform functionality.

## Features

### 1. Distribution Management
```powershell
# List available distributions
Get-WSLDistribution

# Start a specific distribution
Start-WSLDistribution -Name "Ubuntu"

# Stop a running distribution
Stop-WSLDistribution -Name "Ubuntu"

# Set default distribution
Set-WSLDefaultDistribution -Name "Ubuntu"
```

### 2. Service Control
```powershell
# Start WSL service
Start-WSLService

# Stop WSL service
Stop-WSLService

# Get WSL service status
Get-WSLServiceStatus
```

### 3. Environment Management
```powershell
# Get WSL environment variables
Get-WSLEnvironment

# Set WSL environment variable
Set-WSLEnvironment -Name "DISPLAY" -Value ":0"

# Remove WSL environment variable
Remove-WSLEnvironment -Name "DISPLAY"
```

### 4. File System Integration
```powershell
# Convert Windows path to WSL path
Convert-ToWSLPath -WindowsPath "C:\Users\Example"

# Convert WSL path to Windows path
Convert-ToWindowsPath -WSLPath "/home/user"

# Get WSL home directory
Get-WSLHomeDirectory
```

### 5. Cross-Platform Operations
```powershell
# Execute Linux command
Invoke-WSLCommand -Command "ls -la"

# Run script in WSL
Invoke-WSLScript -ScriptPath "./script.sh"

# Copy files between Windows and WSL
Copy-ToWSL -Source "C:\file.txt" -Destination "/home/user/"
Copy-FromWSL -Source "/home/user/file.txt" -Destination "C:\"
```

## Configuration

### Default Settings
```powershell
$WSLConfig = @{
    DefaultDistribution = "Ubuntu"
    AutoStartService = $true
    MountOptions = @{
        EnableCase = $true
        Metadata = $true
    }
    NetworkSettings = @{
        EnableBridge = $true
        HostName = "wsl.local"
    }
}
```

### Custom Configuration
```powershell
# Set custom configuration
Set-WSLConfiguration -Config $WSLConfig

# Get current configuration
Get-WSLConfiguration

# Reset to defaults
Reset-WSLConfiguration
```

## Requirements

### System Requirements
- Windows 10 version 2004 and higher (Build 19041 and higher)
- Windows Subsystem for Linux enabled
- At least one WSL distribution installed

### PowerShell Requirements
- PowerShell 5.1 or higher
- Administrator rights for some operations

## Installation

### 1. Enable WSL
```powershell
# Enable WSL feature
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# Enable Virtual Machine Platform
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

# Set WSL 2 as default
wsl --set-default-version 2
```

### 2. Install Distribution
```powershell
# List available distributions
wsl --list --online

# Install Ubuntu (example)
wsl --install -d Ubuntu
```

## Usage Examples

### Basic Usage
```powershell
# Start WSL and get status
Start-WSLService
Get-WSLServiceStatus

# List distributions
Get-WSLDistribution

# Execute command
Invoke-WSLCommand "uname -a"
```

### Advanced Scenarios
```powershell
# Set up development environment
Initialize-WSLDevelopment -Distribution "Ubuntu" -Packages @("git", "nodejs", "python3")

# Configure network
Set-WSLNetworking -EnableBridge -HostName "dev.local"

# Mount additional drives
Add-WSLMount -DriveLetter "D" -MountPoint "/mnt/data"
```

## Troubleshooting

### Common Issues

1. **WSL Service Not Starting**
   ```powershell
   # Check service status
   Get-Service LxssManager
   
   # Restart service
   Restart-Service LxssManager
   ```

2. **Distribution Not Found**
   ```powershell
   # Verify installation
   wsl --list --verbose
   
   # Repair distribution
   Repair-WSLDistribution -Name "Ubuntu"
   ```

3. **Network Issues**
   ```powershell
   # Reset WSL network
   Reset-WSLNetwork
   
   # Check WSL network status
   Test-WSLNetwork
   ```

### Logging
```powershell
# Enable debug logging
Set-WSLLogLevel -Level Debug

# View logs
Get-WSLLogs

# Export logs
Export-WSLLogs -Path "C:\WSLLogs"
```

## Best Practices

1. **Performance Optimization**
   - Use WSL 2 for better performance
   - Optimize file system operations
   - Configure memory limits

2. **Security**
   - Keep distributions updated
   - Use secure configurations
   - Manage user permissions

3. **Integration**
   - Use consistent paths
   - Handle cross-platform line endings
   - Maintain environment variables

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support
- Report issues on GitHub
- Check WSL documentation
- Contact maintainers

## License
Same as PSProfile module
