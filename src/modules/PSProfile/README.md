# PSProfile

## Overview
PSProfile is a powerful, modular PowerShell profile management system that enhances your PowerShell experience with customizable prompts, themes, and features. It includes Starship integration, comprehensive configuration management, and an extensible feature system.

## Features

### 🚀 Prompt System
- **Starship Integration**
  - Modern, customizable prompt
  - Git status integration
  - Configurable paths and cache
  - Fallback mechanism

- **Native PSProfile Prompt**
  - Custom-designed fallback prompt
  - Git status support
  - Path and time display
  - Configurable color schemes

### ⚙️ Configuration System
- **Flexible Settings Management**
  - JSON-based configuration
  - Environment-aware paths
  - Secure storage options
  - Multi-environment support

- **Interactive Configuration**
  - Menu-driven setup
  - Real-time updates
  - Theme customization
  - Feature toggling

### 🎨 UI Components
- **Theme Management**
  - Color scheme customization
  - Console formatting
  - Output styling
  - Dynamic updates

- **Menu System**
  - Interactive configuration
  - Feature management
  - Prompt customization
  - System status

### 🔧 Feature Management
- **Core Features**
  - Git integration
  - SSH management
  - Environment handling
  - Module auto-loading

- **Extensibility**
  - Plugin system
  - Custom feature support
  - Dependency management
  - Dynamic loading

## Directory Structure
```
PSProfile/
├── Core/                     # Core functionality
│   ├── Configuration/        # Configuration management
│   ├── Logging/             # Logging system
│   └── Security/            # Security features
├── Features/                 # Feature modules
│   ├── Git/                 # Git integration
│   ├── SSH/                 # SSH management
│   └── Environment/         # Environment handling
├── Tests/                   # Test suite
│   ├── Core.Tests.ps1       # Core module tests
│   ├── Features.Tests.ps1   # Feature tests
│   └── UI.Tests.ps1         # UI component tests
├── UI/                      # User interface components
│   ├── Menu/               # Menu system
│   ├── Prompt/             # Prompt system
│   └── Theme/              # Theme management
├── PSProfile.psd1           # Module manifest
└── PSProfile.psm1           # Main module file
```

## Installation

### Prerequisites
- PowerShell 5.1 or later
- Starship (optional, for enhanced prompt)
- Git (optional, for Git integration)

### Quick Install
```powershell
# Install from PowerShell Gallery
Install-Module -Name PSProfile -Scope CurrentUser

# Import module
Import-Module PSProfile

# Initialize profile
Initialize-PSProfile
```

### Manual Installation
```powershell
# Clone repository
git clone https://github.com/ipoetdev/PSProfile.git

# Copy to PowerShell modules directory
Copy-Item -Path ./PSProfile -Destination "$env:UserProfile\Documents\PowerShell\Modules" -Recurse

# Import module
Import-Module PSProfile
```

## Configuration

### Basic Configuration
```powershell
# Open configuration menu
Show-PSProfileMenu

# Configure prompt
Set-PSProfilePromptType -Type Starship

# Update prompt settings
Update-PSProfilePromptConfig -Type PSProfile -Settings @{
    ShowGitStatus = $true
    ShowPath = $true
    ColorScheme = @{
        Path = "Blue"
        Git = "Green"
    }
}
```

### Advanced Configuration
```powershell
# Custom feature configuration
Set-PSProfileFeature -Name Git -Settings @{
    AutoFetch = $true
    ShowStatus = $true
}

# Environment-specific settings
Set-PSProfileEnvironment -Name Development -Config @{
    Features = @("Git", "SSH")
    Prompt = "Starship"
}
```

## Usage Examples

### Prompt Customization
```powershell
# Switch prompt type
Set-PSProfilePromptType -Type Starship

# Configure Starship
Update-PSProfilePromptConfig -Type Starship -Settings @{
    ConfigPath = "~/.config/starship.toml"
}

# Customize PSProfile prompt
Update-PSProfilePromptConfig -Type PSProfile -Settings @{
    ShowGitStatus = $true
    ShowTime = $true
}
```

### Feature Management
```powershell
# Enable features
Enable-PSProfileFeature -Name Git

# Configure feature
Set-PSProfileFeatureConfig -Name Git -Settings @{
    AutoFetch = $true
}

# View feature status
Get-PSProfileFeatureStatus
```

## Development

### Building from Source
```powershell
# Clone repository
git clone https://github.com/ipoetdev/PSProfile.git

# Run tests
Invoke-Pester ./Tests

# Build module
./build.ps1
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## Testing
```powershell
# Run all tests
Invoke-Pester ./Tests/*.Tests.ps1

# Run specific test category
Invoke-Pester ./Tests/Core.Tests.ps1
```

## Documentation
- [Configuration Guide](./Core/Configuration/README.md)
- [Feature Documentation](./Features/README.md)
- [UI Components](./UI/README.md)
- [Test Suite](./Tests/README.md)

## Support
- [Issue Tracker](https://github.com/ipoetdev/PSProfile/issues)
- [Discussions](https://github.com/ipoetdev/PSProfile/discussions)
- [Wiki](https://github.com/ipoetdev/PSProfile/wiki)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- [Starship](https://starship.rs/) for the amazing prompt
- PowerShell community for inspiration and support
- Contributors who have helped shape this project
