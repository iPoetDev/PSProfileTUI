# PSProfile Configuration System

## Overview
The Configuration module provides a robust, flexible configuration management system for PSProfile. It handles settings storage, validation, migration, and dynamic updates across all PSProfile components while ensuring security and data integrity.

## Features

### 1. Configuration Management
```powershell
# Get configuration
Get-PSProfileConfig

# Set configuration
Set-PSProfileConfig -Config $newConfig

# Reset configuration
Reset-PSProfileConfig

# Import/Export
Export-PSProfileConfig -Path "~/config-backup.json"
Import-PSProfileConfig -Path "~/config-backup.json"
```

### 2. Profile Settings
```powershell
# Core settings
$CoreSettings = @{
    DefaultShell = "pwsh"
    AutoUpdate = $true
    LogLevel = "Info"
    Theme = "PowerLine"
}

# Feature settings
$FeatureSettings = @{
    Git = @{
        AutoFetch = $true
        ShowStatus = $true
    }
    SSH = @{
        AutoStart = $true
        KeyPath = "~/.ssh"
    }
}
```

### 3. Environment Configuration
```powershell
# Set environment
Set-ProfileEnvironment -Name "Development" -Config @{
    Features = @("Git", "Docker")
    Modules = @("Pester", "PSScriptAnalyzer")
}

# Switch environment
Switch-ProfileEnvironment -Name "Production"

# Get current environment
Get-ProfileEnvironment
```

## Configuration Structure

### 1. Base Configuration
```json
{
    "Core": {
        "Version": "1.0.0",
        "AutoLoad": true,
        "DefaultProfile": "Default",
        "LogLevel": "Info"
    },
    "Features": {
        "Enabled": ["Git", "SSH"],
        "Settings": {}
    },
    "UI": {
        "Theme": "PowerLine",
        "ShowPrompt": true
    }
}
```

### 2. Feature Configuration
```json
{
    "Git": {
        "Enabled": true,
        "AutoFetch": true,
        "ShowStatus": true,
        "DefaultBranch": "main"
    },
    "SSH": {
        "Enabled": true,
        "AutoStart": true,
        "KeyPath": "~/.ssh",
        "DefaultKey": "id_ed25519"
    }
}
```

### 3. User Settings
```json
{
    "User": {
        "Name": "John Doe",
        "Email": "john@example.com",
        "Preferences": {
            "Editor": "code",
            "Terminal": "Windows Terminal"
        }
    }
}
```

### 4. Prompt Configuration
```json
{
    "UI": {
        "Prompt": {
            "Type": "Starship",  // "Starship" or "PSProfile"
            "Config": {
                "Starship": {
                    "ConfigPath": "~/.config/starship.toml",
                    "CachePath": "~/.starship/cache"
                },
                "PSProfile": {
                    "ShowGitStatus": true,
                    "ShowPath": true,
                    "ShowTime": true,
                    "ColorScheme": {
                        "Path": "Blue",
                        "Git": "Green",
                        "Error": "Red"
                    }
                }
            }
        }
    }
}
```

#### Prompt Management Functions
```powershell
# Get prompt configuration
Get-PSProfilePromptConfig

# Switch prompt type
Set-PSProfilePromptType -Type "Starship"  # or "PSProfile"

# Update prompt settings
Update-PSProfilePromptConfig -Type "PSProfile" -Settings @{
    ShowGitStatus = $true
    ShowPath = $true
    ColorScheme = @{
        Path = "Blue"
        Git = "Green"
    }
}

# Configure Starship paths
Update-PSProfilePromptConfig -Type "Starship" -Settings @{
    ConfigPath = "~/.config/starship.toml"
    CachePath = "~/.starship/cache"
}
```

## Configuration Storage

### 1. File Locations
```powershell
# Default paths
$ConfigPaths = @{
    System = "$env:ProgramData\PSProfile\config"
    User = "~/.psprofile/config"
    Custom = "./config"
}

# Configuration files
$ConfigFiles = @{
    Main = "profile.json"
    Features = "features.json"
    Security = "security.json"
}
```

### 2. Security
```powershell
# Encrypt sensitive data
Protect-ConfigurationData -Path "security.json"

# Decrypt for use
Unprotect-ConfigurationData -Path "security.json"

# Set secure string
Set-SecureConfig -Key "ApiKey" -Value "secret"
```

## Usage Examples

### Basic Configuration
```powershell
# Get full configuration
$config = Get-PSProfileConfig

# Update specific setting
$config.Core.LogLevel = "Debug"
Set-PSProfileConfig -Config $config

# Reset single feature
Reset-FeatureConfig -Name "Git"

# Configure prompt
Set-PSProfilePromptType -Type "Starship"
Update-PSProfilePromptConfig -Type "Starship" -Settings @{
    ConfigPath = "~/.config/starship.toml"
}
```

### Advanced Scenarios
```powershell
# Multi-environment config
Set-ProfileEnvironments -Environments @{
    Development = @{
        Features = @("Git", "Docker")
        LogLevel = "Debug"
    }
    Production = @{
        Features = @("Logging", "Security")
        LogLevel = "Warning"
    }
}

# Configuration templates
New-ConfigTemplate -Name "WebDev" -Settings @{
    Features = @("Git", "Node", "Python")
    Tools = @("VSCode", "Chrome")
}
```

## Configuration Validation

### 1. Schema Validation
```powershell
# Validate configuration
Test-PSProfileConfig -Config $config

# Validate feature config
Test-FeatureConfig -Name "Git" -Config $gitConfig

# Fix issues
Repair-PSProfileConfig
```

### 2. Migration
```powershell
# Check version
Test-ConfigVersion

# Migrate configuration
Update-PSProfileConfig -ToVersion "2.0.0"

# Backup before migration
Backup-PSProfileConfig
```

## Best Practices

### 1. Configuration Management
- Use version control
- Regular backups
- Document changes
- Validate updates
- Secure sensitive data

### 2. Organization
```powershell
# Structured settings
$Config = @{
    Core = @{
        # Core settings
    }
    Features = @{
        # Feature settings
    }
    Security = @{
        # Security settings
    }
}
```

### 3. Security
```powershell
# Secure storage
Set-SecureConfig -Key "ApiKey" -SecureString $secureString

# Access control
Set-ConfigPermissions -Path $configPath -Private

# Audit changes
Enable-ConfigAudit
```

## Troubleshooting

### Common Issues

1. **Configuration Loading**
   ```powershell
   # Test configuration
   Test-PSProfileConfig
   
   # Verify paths
   Test-ConfigPaths
   ```

2. **Corruption**
   ```powershell
   # Verify integrity
   Test-ConfigIntegrity
   
   # Restore backup
   Restore-PSProfileConfig
   ```

3. **Permission Issues**
   ```powershell
   # Check permissions
   Test-ConfigPermissions
   
   # Fix access
   Repair-ConfigPermissions
   ```

### Configuration Recovery
```powershell
# Create backup
Backup-PSProfileConfig -Path "~/backup"

# Restore from backup
Restore-PSProfileConfig -Path "~/backup"

# Reset to defaults
Reset-PSProfileConfig -Confirm
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
