# PSProfileTUI

A Text User Interface (TUI) for managing PowerShell profiles and configurations with enhanced customization capabilities.

[![PowerShell Analysis](https://github.com/yourusername/PSProfileTUI/actions/workflows/powershell-analysis.yml/badge.svg)](https://github.com/yourusername/PSProfileTUI/actions/workflows/powershell-analysis.yml)
[![Tests](https://github.com/yourusername/PSProfileTUI/actions/workflows/tests.yml/badge.svg)](https://github.com/yourusername/PSProfileTUI/actions/workflows/tests.yml)

## Features

- Interactive TUI for PowerShell profile management
- Profile configuration visualization and editing
- Cross-platform support (Windows, Linux, macOS)
- Modular design for easy extensibility

## Project Structure

```
PSProfileTUI/
├── .github/                    # GitHub templates and workflows
│   ├── ISSUE_TEMPLATE/        # Issue templates
│   ├── PULL_REQUEST_TEMPLATE/ # PR templates
│   └── workflows/             # GitHub Actions workflows
├── src/                       # Source code
│   ├── modules/               # PowerShell modules
│   │   └── PSProfile/        # Core profile module
│   │       ├── Core/         # Core functionality
│   │       │   ├── Configuration/
│   │       │   ├── Initialize/
│   │       │   └── Logging/
│   │       ├── Features/     # Feature modules
│   │       │   ├── Git/
│   │       │   ├── SSH/
│   │       │   ├── VirtualEnv/
│   │       │   └── WSL/
│   │       └── UI/           # User interface
│   │           ├── Menu/
│   │           └── Prompt/
│   └── profile/              # PowerShell profile configurations
├── tests/                     # Test files
├── docs/                      # Documentation
├── CHANGELOG.md              # Project-wide changes
├── PROJECTLOG.md            # Development history & decisions
├── CONTRIBUTING.md          # Contribution guidelines
├── CODE_OF_CONDUCT.md       # Code of conduct
├── LICENSE                  # License information
└── README.md               # This file
```

## Documentation Structure

### Project Documentation
- [Project Overview](README.md) - Start here
- [Development History](PROJECTLOG.md) - Architectural decisions and project evolution
- [Contribution Guide](CONTRIBUTING.md) - How to contribute
- [Code of Conduct](CODE_OF_CONDUCT.md) - Community guidelines

### Change Tracking
- [Project Changelog](CHANGELOG.md) - Project-wide changes
- Module-specific changelogs in respective module directories
- [Project History](PROJECTLOG.md) - Major decisions and milestones

### Module Documentation

#### PSProfile Module
- [Main Module Documentation](src/modules/PSProfile/README.md)
- [Module Changelog](src/modules/PSProfile/CHANGELOG.md)
- [Development History](src/modules/PSProfile/Development_History.md)

#### Core Components
- [Core Documentation](src/modules/PSProfile/Core/README.md)
  - Configuration Management
  - Initialization Process
  - Logging System

#### Features
- [Features Documentation](src/modules/PSProfile/Features/README.md)
  - Git Integration
  - SSH Management
  - Virtual Environment Support
  - WSL Integration

#### User Interface
- [UI Documentation](src/modules/PSProfile/UI/README.md)
  - Menu System
  - Prompt Customization

### Module Directory Table of Contents

| Module | Documentation | Changelog | Features |
|--------|--------------|-----------|-----------|
| PSProfile | [README](src/modules/PSProfile/README.md) | [CHANGELOG](src/modules/PSProfile/CHANGELOG.md) | Main module |
| Core | [README](src/modules/PSProfile/Core/README.md) | - | Configuration, Init, Logging |
| Features | [README](src/modules/PSProfile/Features/README.md) | - | Git, SSH, VirtualEnv, WSL |
| UI | [README](src/modules/PSProfile/UI/README.md) | - | Menu, Prompt |

## Getting Started

### Prerequisites

- PowerShell 7.0 or higher
- Windows Terminal (recommended)

### Installation

1. Clone the repository:
```powershell
git clone https://github.com/yourusername/PSProfileTUI.git
```

2. Import the module:
```powershell
Import-Module ./src/modules/PSProfileTUI
```

3. Run the TUI:
```powershell
Start-PSProfileTUI
```

## Development

### Quick Start
1. Fork and clone the repository
2. Read the [Contribution Guide](CONTRIBUTING.md)
3. Check the [Project History](PROJECTLOG.md) for context
4. Make changes in relevant modules
5. Update appropriate changelogs
6. Submit a pull request

### Change Management
- Module changes are documented in respective module changelogs
- Project-wide changes are summarized in root [CHANGELOG.md](CHANGELOG.md)
- Architectural decisions are documented in [PROJECTLOG.md](PROJECTLOG.md)

### Module Development
1. Each module has its own README.md with specific guidelines
2. Follow the module's documentation structure
3. Update module-specific changelog first
4. Update project-level changelog after module changes
5. Keep module documentation in sync with changes

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed development setup and guidelines.

## Testing

```powershell
# Run all tests
Invoke-Pester ./tests

# Run specific module tests
Invoke-Pester ./tests/PSProfile
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for project-wide changes and individual module changelogs for detailed changes:
- [PSProfile Module Changes](src/modules/PSProfile/CHANGELOG.md)

## License

This project is licensed under the terms included in the [LICENSE](LICENSE) file.
