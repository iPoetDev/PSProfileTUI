# PSProfile Menu System

## Overview
The Menu system provides a flexible and interactive menu creation and management system for PSProfile, enabling easy navigation and command execution through customizable menus.

## Features

### 1. Menu Creation
```powershell
# Basic menu
New-PSMenu -Title "Main Menu" -Items @(
    "Option 1",
    "Option 2",
    "Option 3"
)

# Advanced menu
New-PSMenu -Title "Advanced Menu" -Items @(
    @{
        Label = "Git Operations"
        Action = { Show-GitMenu }
        Condition = { Test-GitRepository }
    },
    @{
        Label = "SSH Management"
        Action = { Show-SSHMenu }
        Icon = "🔑"
    }
)
```

### 2. Navigation
```powershell
# Keyboard controls
Set-MenuNavigation -Controls @{
    Up = "UpArrow"
    Down = "DownArrow"
    Select = "Enter"
    Back = "Escape"
}

# Mouse support
Enable-MenuMouse
Set-MouseBehavior -ClickAction "Select"
```

### 3. Styling
```powershell
# Menu appearance
Set-MenuStyle -Settings @{
    Border = "Single"
    Colors = @{
        Selected = "Cyan"
        Normal = "White"
        Border = "Blue"
    }
    Width = 40
    Alignment = "Center"
}
```

## Menu Types

### 1. Standard Menus
```powershell
# List menu
New-ListMenu -Items $items

# Grid menu
New-GridMenu -Items $items -Columns 3

# Tree menu
New-TreeMenu -Structure $menuTree
```

### 2. Special Menus
```powershell
# Search menu
New-SearchMenu -Items $items -SearchPrompt "Find:"

# Quick select
New-QuickMenu -Items $items -HotKeys @{
    "G" = "Git"
    "S" = "SSH"
}

# Context menu
New-ContextMenu -Target $item -Actions $actions
```

## Interaction

### 1. Event Handling
```powershell
# Selection events
Register-MenuEvent -Name "ItemSelected"
Register-MenuEvent -Name "MenuClosed"

# Custom events
Add-MenuEventHandler -Event "ItemSelected" -Handler {
    param($Selection)
    # Handle selection
}
```

### 2. Input Processing
```powershell
# Input handling
Set-MenuInput -Handler {
    param($Key)
    switch ($Key) {
        "F5" { Refresh-Menu }
        "Tab" { Next-MenuSection }
    }
}
```

## Dynamic Content

### 1. Content Sources
```powershell
# Dynamic items
Set-MenuSource -Provider {
    Get-GitBranches
}

# Filtered content
Add-MenuFilter -Filter {
    param($Items)
    $Items | Where-Object { $_.IsEnabled }
}
```

### 2. Updates
```powershell
# Refresh handling
Set-MenuRefresh -Interval 5
Add-RefreshTrigger -Event "GitChanged"

# Content updates
Update-MenuItems -NewItems $items
Update-MenuStatus -Status "Ready"
```

## Advanced Features

### 1. Multi-Level Menus
```powershell
# Nested menus
New-NestedMenu -Structure @{
    "Git" = @{
        "Branches" = { Show-BranchMenu }
        "Status" = { Show-StatusMenu }
    }
    "SSH" = @{
        "Keys" = { Show-KeyMenu }
        "Agents" = { Show-AgentMenu }
    }
}
```

### 2. Custom Renderers
```powershell
# Custom rendering
Set-MenuRenderer -Renderer {
    param($Menu)
    # Custom rendering logic
}

# Item templates
Set-ItemTemplate -Template {
    param($Item)
    "$($Item.Icon) $($Item.Label)"
}
```

## Best Practices

### 1. Design
- Clear hierarchy
- Consistent navigation
- Visual feedback
- Keyboard shortcuts
- Status indicators

### 2. Performance
- Lazy loading
- Cached content
- Efficient updates
- Resource management

### 3. Usability
- Clear labels
- Logical grouping
- Quick access
- Error handling
- Help system

## Troubleshooting

### Common Issues

1. **Display Problems**
   ```powershell
   # Test display
   Test-MenuDisplay
   
   # Reset display
   Reset-MenuDisplay
   ```

2. **Navigation Issues**
   ```powershell
   # Check navigation
   Test-MenuNavigation
   
   # Reset controls
   Reset-MenuControls
   ```

3. **Content Problems**
   ```powershell
   # Verify content
   Test-MenuContent
   
   # Reset content
   Reset-MenuContent
   ```

## Development

### 1. Custom Menus
```powershell
# Menu template
New-MenuTemplate -Name "Custom"

# Add functionality
Add-MenuFunction -Name "Custom" -Function {
    # Menu logic
}
```

### 2. Testing
```powershell
# Test menu
Test-Menu -Name "MainMenu"

# Test interaction
Test-MenuInteraction -Scenario "Navigation"

# Performance test
Measure-MenuPerformance
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
