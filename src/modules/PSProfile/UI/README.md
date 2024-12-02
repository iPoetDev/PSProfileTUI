# PSProfile UI System

## Overview
The UI system provides a comprehensive set of user interface components for PSProfile, offering interactive menus, customizable prompts, and visual enhancements for the PowerShell experience.

## Components

### 1. Menu System
- Interactive menu creation
- Keyboard navigation
- Dynamic content
- Customizable styling
- [Full Documentation](./Menu/README.md)

### 2. Prompt System
- Customizable prompts
- Git integration
- Environment indicators
- Status information
- [Full Documentation](./Prompt/README.md)

## Architecture

### Component Interaction
```
UI Controller
├── Menu System
│   ├── Menu Renderer
│   ├── Input Handler
│   └── Action Manager
└── Prompt System
    ├── Prompt Builder
    ├── Status Manager
    └── Theme Handler
```

## Features

### 1. Common UI Elements
```powershell
# Colors and styling
Set-UIStyle -Theme "PowerLine"
Set-ColorScheme -Name "Dark"

# Progress indicators
Show-Progress -Activity "Loading" -Status "Please wait..."
Show-Spinner -Message "Processing"

# Notifications
Show-Notification -Message "Task completed" -Type "Success"
```

### 2. Input Handling
```powershell
# User input
Get-UserInput -Prompt "Enter value"
Get-SecureInput -Prompt "Enter password"

# Confirmation
Get-UserConfirmation -Message "Continue?"
```

### 3. Display Management
```powershell
# Screen management
Clear-Screen
Set-CursorPosition -X 0 -Y 0

# Output formatting
Write-Formatted -Message "Text" -Color "Blue"
Write-StatusLine -Message "Ready" -Color "Green"
```

## Customization

### 1. Themes
```powershell
# Available themes
Get-UIThemes

# Set theme
Set-UITheme -Name "Modern"

# Custom theme
New-UITheme -Name "Custom" -Settings @{
    Background = "Dark"
    Accent = "Blue"
    Text = "White"
}
```

### 2. Layout
```powershell
# Screen layout
Set-UILayout -Columns 2 -Rows 3

# Component placement
Set-ComponentPosition -Name "Menu" -Position "Top"
Set-ComponentPosition -Name "Status" -Position "Bottom"
```

### 3. Colors
```powershell
# Color schemes
Set-ColorScheme -Name "Solarized"

# Custom colors
Set-CustomColors -Colors @{
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
}
```

## Integration

### 1. Feature Integration
```powershell
# Register UI component
Register-UIComponent -Name "CustomMenu" -Type "Menu"

# Add status provider
Add-StatusProvider -Name "Git" -Provider {
    # Git status logic
}
```

### 2. Event Handling
```powershell
# UI events
Register-UIEvent -Name "MenuSelected"
Register-UIEvent -Name "PromptUpdated"

# Event handlers
Add-UIEventHandler -Event "MenuSelected" -Handler {
    param($Selection)
    # Handle selection
}
```

## Best Practices

### 1. Design Guidelines
- Consistent styling
- Clear navigation
- Responsive feedback
- Error indication
- Status updates

### 2. Performance
- Efficient rendering
- Cached elements
- Async updates
- Resource cleanup

### 3. Accessibility
- Color contrast
- Screen reader support
- Keyboard navigation
- Clear indicators

## Troubleshooting

### Common Issues

1. **Display Issues**
   ```powershell
   # Test display
   Test-UIDisplay
   
   # Reset display
   Reset-UIDisplay
   ```

2. **Input Problems**
   ```powershell
   # Check input handling
   Test-UIInput
   
   # Reset input handler
   Reset-UIInput
   ```

3. **Theme Issues**
   ```powershell
   # Verify theme
   Test-UITheme
   
   # Reset to default
   Reset-UITheme
   ```

## Development

### 1. Creating UI Components
```powershell
# Component template
New-UIComponent -Name "Custom" -Template "Basic"

# Add functionality
Add-UIFunction -Component "Custom" -Function {
    # Component logic
}
```

### 2. Testing
```powershell
# Test UI components
Test-UIComponent -Name "Menu"

# Test interactions
Test-UIInteraction -Scenario "Navigation"

# Performance testing
Measure-UIPerformance
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
