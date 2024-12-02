# SSH Module for PSProfile

## Overview
The SSH module provides comprehensive SSH key and agent management within PowerShell, offering secure and efficient handling of SSH connections, keys, and configurations. It integrates seamlessly with Windows OpenSSH and provides enhanced functionality for Git operations.

## Features

### 1. SSH Key Management
```powershell
# Generate new SSH key
New-SSHKey -Type "ed25519" -Comment "user@example.com"

# List SSH keys
Get-SSHKeys

# Import existing key
Import-SSHKey -Path "~/.ssh/id_ed25519"

# Export key (public)
Export-SSHPublicKey -KeyFile "id_ed25519" -Path "./keys"
```

### 2. SSH Agent Control
```powershell
# Start SSH agent
Start-SSHAgent

# Add key to agent
Add-SSHKey -KeyFile "id_ed25519"

# List keys in agent
Get-SSHAgentKeys

# Remove key from agent
Remove-SSHKey -KeyFile "id_ed25519"
```

### 3. Configuration Management
```powershell
# Get SSH config
Get-SSHConfig

# Add SSH host
Add-SSHHost -Name "github" -HostName "github.com" -User "git"

# Set SSH options
Set-SSHOption -Host "github" -Option "IdentityFile" -Value "~/.ssh/github_key"

# Test SSH configuration
Test-SSHConfig
```

### 4. Connection Management
```powershell
# Test SSH connection
Test-SSHConnection -Host "github.com"

# Get connection status
Get-SSHStatus -Host "github.com"

# Save known host
Add-SSHKnownHost -Host "github.com"

# Clear known hosts
Clear-SSHKnownHosts
```

## Configuration

### Default Settings
```powershell
$SSHConfig = @{
    DefaultKeyType = "ed25519"
    KeysDirectory = "~/.ssh"
    AutoStartAgent = $true
    AddKeysOnStart = $true
    ShowAgentStatus = $true
    ConfigFile = "~/.ssh/config"
}
```

### Custom Configuration
```powershell
# Set configuration
Set-SSHConfiguration -Config $SSHConfig

# Get current configuration
Get-SSHConfiguration

# Reset to defaults
Reset-SSHConfiguration
```

## Requirements

### System Requirements
- Windows 10 1809 or later
- PowerShell 5.1 or PowerShell Core 7.x
- Windows OpenSSH (installed by default on recent Windows versions)

### Optional Components
- Git for Windows
- Windows Terminal
- Visual Studio Code

## Installation

### 1. OpenSSH Setup
```powershell
# Install OpenSSH Client (if needed)
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install OpenSSH Server (optional)
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start SSH Agent service
Set-Service -Name ssh-agent -StartupType Automatic
Start-Service ssh-agent
```

### 2. Module Configuration
```powershell
# Initialize module
Initialize-SSHModule

# Configure defaults
Set-SSHDefaults

# Test setup
Test-SSHSetup
```

## Usage Examples

### Basic Setup
```powershell
# Generate and configure key
New-SSHKey -Type "ed25519" -Comment "work@company.com"
Add-SSHKey -KeyFile "id_ed25519"

# Configure for GitHub
Add-SSHHost -Name "github" -HostName "github.com" -User "git"
Add-SSHKnownHost -Host "github.com"
```

### Advanced Usage
```powershell
# Multiple identity setup
New-SSHKey -Type "ed25519" -Name "personal" -Comment "personal@email.com"
New-SSHKey -Type "ed25519" -Name "work" -Comment "work@company.com"

# Configure host-specific keys
Set-SSHOption -Host "github" -Option "IdentityFile" -Value "~/.ssh/personal"
Set-SSHOption -Host "gitlab" -Option "IdentityFile" -Value "~/.ssh/work"
```

### Git Integration
```powershell
# Configure Git SSH
Set-GitSSH

# Test GitHub connection
Test-SSHConnection -Host "github.com"

# Add deploy key
Add-GitDeployKey -Repo "user/repo" -KeyFile "deploy_key"
```

## Troubleshooting

### Common Issues

1. **Agent Not Starting**
   ```powershell
   # Check agent service
   Get-Service ssh-agent
   
   # Restart agent
   Restart-SSHAgent
   ```

2. **Key Permission Issues**
   ```powershell
   # Fix key permissions
   Repair-SSHKeyPermissions
   
   # Verify permissions
   Test-SSHKeyPermissions
   ```

3. **Connection Problems**
   ```powershell
   # Debug connection
   Test-SSHConnection -Host "github.com" -Verbose
   
   # Check known hosts
   Test-SSHKnownHost -Host "github.com"
   ```

### Logging
```powershell
# Enable debug logging
Set-SSHLogLevel -Level Debug

# View logs
Get-SSHLogs

# Export logs
Export-SSHLogs -Path "./logs"
```

## Best Practices

1. **Key Management**
   - Use Ed25519 keys
   - Protect private keys
   - Regular key rotation
   - Backup key pairs

2. **Security**
   - Strong key passphrases
   - Limited key permissions
   - Regular security audits
   - Known hosts verification

3. **Configuration**
   - Host-specific settings
   - Proxy configuration
   - Connection timeouts
   - Compression settings

## Integration with PSProfile

### Prompt Integration
- Shows SSH agent status
- Displays active keys count
- Indicates connection status

### Auto-Start Features
- Agent auto-start
- Key auto-loading
- Configuration validation

### Command Aliases
```powershell
ssha    # Start SSH agent
sshk    # List SSH keys
sshadd  # Add key to agent
sshc    # Edit SSH config
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
