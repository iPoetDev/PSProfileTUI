# PSProfile Test Suite

## Overview
Comprehensive test suite for the PSProfile module, providing unit tests, integration tests, and performance benchmarks for all module components.

## Quick Start
```powershell
# Open the interactive test menu
tpm

# Or use the full command
Test-PSProfileMenu
```

## Test Categories

### 1. Core Module Tests (`Core.Tests.ps1`)
Tests for essential module functionality:
- Logging system
- Configuration management
- Module initialization
- Error handling
- Performance tracking
- **Prompt Configuration**
  - Default configuration validation
  - Prompt type switching
  - Starship configuration
  - PSProfile prompt settings
  - Color scheme validation
  - Fallback handling

### 2. Feature Module Tests (`Features.Tests.ps1`)
Tests for feature-specific modules:
- Git integration
- SSH management
- Virtual Environment handling
- WSL integration

### 3. UI Module Tests (`UI.Tests.ps1`)
Tests for user interface components:
- Menu system
- Prompt customization
- Theme management
- User input handling
- **Prompt System**
  - Initialization testing
  - PSProfile prompt generation
  - Git status integration
  - Path formatting
  - Color scheme application
  - Starship integration
  - Error handling

## Directory Structure
```
Tests/
├── Core.Tests.ps1       # Core module tests
├── Features.Tests.ps1   # Feature module tests
├── UI.Tests.ps1         # UI component tests
├── TestMenu.ps1         # Interactive test menu
├── config/             # Test configuration files
└── TestResults/        # Test output directory
```

## Running Tests

### Using the Test Menu
1. Launch the menu:
   ```powershell
   tpm
   ```
2. Select an option:
   - 1: Run all tests
   - 2: Core Module Tests
   - 3: Feature Module Tests
   - 4: UI Module Tests
   - 5: Show Test Results
   - Q: Quit

### Manual Test Execution
Run specific test categories:
```powershell
# Run all tests
Invoke-Pester *.Tests.ps1

# Run specific test file
Invoke-Pester Core.Tests.ps1

# Run with detailed output
Invoke-Pester Features.Tests.ps1 -Output Detailed
```

## Test Configuration
- Test configurations are stored in `config/TestConfig.ps1`
- Environment-specific settings can be adjusted here
- Mock data and test constants are defined in this file

## Writing Tests

### Test Structure
```powershell
Describe "Module.Function" {
    BeforeAll {
        # Test setup
    }

    Context "When condition" {
        It "Should do something" {
            # Test case
        }
    }

    AfterAll {
        # Test cleanup
    }
}
```

### Best Practices
1. Use descriptive test names
2. Test both success and failure cases
3. Mock external dependencies
4. Clean up test resources
5. Use appropriate assertions
6. Document test requirements

## Test Results
- Results are stored in `TestResults/`
- View recent results using menu option 5
- Results include:
  * Test execution time
  * Pass/fail status
  * Error details
  * Code coverage

## Contributing Tests
1. Follow existing test patterns
2. Add tests for new features
3. Update test documentation
4. Verify all tests pass
5. Submit pull request

## Requirements
- PowerShell 5.1 or higher
- Pester module
- Admin rights (for some tests)

## Common Issues
1. **Permission Errors**
   - Run PowerShell as Administrator
   - Check file permissions

2. **Missing Dependencies**
   ```powershell
   Install-Module Pester -Force
   ```

3. **Test Failures**
   - Check test configuration
   - Verify module installation
   - Review error logs

## Support
- Report issues on GitHub
- Check documentation
- Contact maintainers

## License
Same as PSProfile module
