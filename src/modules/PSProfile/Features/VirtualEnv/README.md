# VirtualEnv Module for PSProfile

## Overview
The VirtualEnv module provides comprehensive Python virtual environment management within PowerShell, offering seamless integration with pip, conda, and poetry. This module simplifies Python development workflow with automated environment handling and package management.

## Features

### 1. Environment Management
```powershell
# Create new virtual environment
New-PythonVirtualEnv -Name "project-env" -Python "3.9"

# Activate environment
Enter-PythonVirtualEnv -Name "project-env"

# Deactivate current environment
Exit-PythonVirtualEnv

# Remove virtual environment
Remove-PythonVirtualEnv -Name "project-env"
```

### 2. Package Management
```powershell
# Install packages
Install-PythonPackage -Name "requests" -Version "2.28.1"

# Install from requirements.txt
Install-PythonRequirements -Path "./requirements.txt"

# Export requirements
Export-PythonRequirements -Path "./requirements.txt"

# List installed packages
Get-PythonPackages
```

### 3. Environment Information
```powershell
# Get current environment
Get-CurrentVirtualEnv

# List all environments
Get-PythonVirtualEnvs

# Get environment details
Get-VirtualEnvInfo -Name "project-env"

# Check Python version
Get-PythonVersion
```

### 4. Project Integration
```powershell
# Initialize project environment
Initialize-PythonProject -Name "myproject" -Python "3.9"

# Set project Python path
Set-ProjectPythonPath -Path "./src"

# Add project dependencies
Add-ProjectDependency -Name "pandas" -Dev
```

### 5. Poetry Support
```powershell
# Initialize Poetry project
Initialize-PoetryProject -Name "myproject"

# Add Poetry dependency
Add-PoetryDependency -Name "requests"

# Update Poetry environment
Update-PoetryEnvironment
```

## Configuration

### Default Settings
```powershell
$VirtualEnvConfig = @{
    DefaultPython = "3.9"
    VenvLocation = "~/.venvs"
    RequirementsFormat = "pip"  # or "poetry"
    AutoActivate = $true
    CreatePrompt = $true
    ShowStatus = $true
}
```

### Custom Configuration
```powershell
# Set configuration
Set-VirtualEnvConfiguration -Config $VirtualEnvConfig

# Get current configuration
Get-VirtualEnvConfiguration

# Reset configuration
Reset-VirtualEnvConfiguration
```

## Requirements

### System Requirements
- Windows PowerShell 5.1 or PowerShell Core 7.x
- Python 3.6 or higher
- pip (latest version recommended)
- Optional: poetry, conda

### Python Requirements
- virtualenv package
- pip-tools (optional)
- poetry (optional)

## Installation

### 1. Python Setup
```powershell
# Install Python (if needed)
winget install Python.Python.3.9

# Install virtualenv
pip install virtualenv

# Install poetry (optional)
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
```

### 2. Module Configuration
```powershell
# Initialize module
Initialize-VirtualEnvModule

# Configure default settings
Set-VirtualEnvDefaults

# Test installation
Test-VirtualEnvSetup
```

## Usage Examples

### Basic Workflow
```powershell
# Create and activate environment
New-PythonVirtualEnv -Name "webproject"
Enter-PythonVirtualEnv -Name "webproject"

# Install packages
Install-PythonPackage -Name "flask"
Install-PythonPackage -Name "requests"

# Export requirements
Export-PythonRequirements
```

### Project Setup
```powershell
# Initialize new project
Initialize-PythonProject -Name "api-service" -Template "fastapi"

# Install development dependencies
Install-PythonPackage -Name "pytest" -Dev
Install-PythonPackage -Name "black" -Dev

# Set up pre-commit hooks
Initialize-PreCommit
```

### Poetry Workflow
```powershell
# Create new Poetry project
Initialize-PoetryProject -Name "package-name"

# Add dependencies
Add-PoetryDependency -Name "requests"
Add-PoetryDependency -Name "pytest" -Dev

# Build and publish
Build-PoetryPackage
Publish-PoetryPackage
```

## Troubleshooting

### Common Issues

1. **Environment Activation Fails**
   ```powershell
   # Check environment path
   Test-VirtualEnvPath -Name "project-env"
   
   # Repair environment
   Repair-VirtualEnv -Name "project-env"
   ```

2. **Package Installation Issues**
   ```powershell
   # Clear pip cache
   Clear-PipCache
   
   # Verify package availability
   Test-PythonPackage -Name "package-name"
   ```

3. **Poetry Problems**
   ```powershell
   # Check Poetry installation
   Test-PoetryInstallation
   
   # Clean Poetry cache
   Clear-PoetryCache
   ```

### Logging
```powershell
# Enable debug logging
Set-VirtualEnvLogLevel -Level Debug

# View logs
Get-VirtualEnvLogs

# Export logs
Export-VirtualEnvLogs -Path "./logs"
```

## Best Practices

1. **Environment Management**
   - Use project-specific environments
   - Keep environments isolated
   - Regular environment cleanup

2. **Package Management**
   - Pin package versions
   - Use requirements.txt
   - Regular dependency updates

3. **Project Structure**
   - Follow Python project standards
   - Use .gitignore templates
   - Maintain clear documentation

## Integration with PSProfile

### Prompt Integration
- Shows active virtual environment
- Indicates Python version
- Displays package count

### Auto-Activation
- Directory-based activation
- Project recognition
- Smart environment switching

### Command Aliases
```powershell
venv    # Create/activate environment
venvd   # Deactivate environment
venvrm  # Remove environment
venvls  # List environments
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
