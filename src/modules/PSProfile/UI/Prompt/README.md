# PSProfile Prompt System

## Overview
The Prompt system provides a highly customizable and informative PowerShell prompt with primary support for Starship prompt and a fallback PSProfile prompt implementation. This dual-prompt system ensures robust functionality while leveraging Starship's modern features.

## Starship Integration

### 1. Primary Prompt (Starship)
```powershell
# Starship Configuration
$ENV:STARSHIP_CONFIG = "D:/Code/Lab/build/the-lab-v1/.config/starship.toml"
$ENV:STARSHIP_CACHE = "$HOME/.starship/cache"

# Initialize Starship
function Initialize-StarshipPrompt {
    $starshipExe = "C:/Program Files/starship/bin/starship.exe"
    if (Test-Path $starshipExe) {
        Invoke-Expression (&$starshipExe init powershell)
        return $true
    }
    return $false
}
```

### 2. Fallback Mechanism
```powershell
# Prompt initialization with fallback
function Initialize-PSProfilePrompt {
    if (-not (Initialize-StarshipPrompt)) {
        Write-Warning "Starship not found, falling back to PSProfile prompt"
        Initialize-FallbackPrompt
    }
}

# Fallback prompt configuration
function Initialize-FallbackPrompt {
    Set-PSPrompt -Format @(
        "%os%",
        "%username%",
        "%hostname%",
        "%directory%",
        "%git%"
    ) -Theme "StarshipCompatible"
}
```

### 3. Starship Theme Compatibility
```powershell
# Starship-compatible theme
New-PromptTheme -Name "StarshipCompatible" -Settings @{
    Symbols = @{
        Windows = " "
        Git = " "
        Home = "󰋜 ~"
        Modified = "󰛿"
        Staged = "󰐗"
        Untracked = "󰋗"
    }
    Colors = @{
        Username = "white bold"
        Hostname = "yellow bold"
        Git = "green bold"
        Path = "blue bold"
    }
}
```

## Features

### 1. Prompt Creation
```powershell
# Basic prompt
Set-PSPrompt -Format "[%username%]>"

# Advanced prompt
Set-PSPrompt -Format @(
    "%time%",
    "%path%",
    "%git%",
    "%status%"
) -Separator " "
```

### 2. Segments
```powershell
# Built-in segments
Add-PromptSegment -Name "Git"
Add-PromptSegment -Name "Path"
Add-PromptSegment -Name "Time"

# Custom segment
New-PromptSegment -Name "Custom" -Content {
    # Segment logic
    Get-CustomStatus
}
```

### 3. Styling
```powershell
# Prompt style
Set-PromptStyle -Settings @{
    Colors = @{
        Username = "Cyan"
        Path = "Blue"
        Git = "Green"
    }
    Icons = @{
        Git = "⎇"
        Error = "✗"
        Success = "✓"
    }
}
```

## Prompt Types

### 1. Standard Prompts
```powershell
# Starship prompt (Primary)
Enable-StarshipPrompt

# PSProfile prompt (Fallback)
Enable-PSProfilePrompt

# Conditional prompt
Set-ConditionalPrompt -Primary {
    Test-StarshipAvailable
} -Fallback {
    Initialize-FallbackPrompt
}

# Single line
Set-SingleLinePrompt -Format $format

# Multi line
Set-MultiLinePrompt -Format @(
    $lineOne,
    $lineTwo
)

# Right-aligned
Set-RightPrompt -Format $format
```

### 2. Special Prompts
```powershell
# Transient prompt
Set-TransientPrompt -Format $format

# Command duration
Show-CommandDuration

# Status prompt
Show-StatusPrompt -Format $format
```

## Customization

### 1. Themes
```powershell
# Built-in themes
Set-PromptTheme -Name "PowerLine"
Set-PromptTheme -Name "Minimal"

# Custom theme
New-PromptTheme -Name "Custom" -Settings @{
    Background = "Dark"
    Foreground = "Light"
    Accents = @{
        Success = "Green"
        Warning = "Yellow"
        Error = "Red"
    }
}
```

### 2. Segments
```powershell
# Segment order
Set-SegmentOrder -Order @(
    "Time",
    "Path",
    "Git"
)

# Segment conditions
Add-SegmentCondition -Name "Git" -Condition {
    Test-GitRepository
}
```

## Integration

### 1. Git Integration
```powershell
# Git status
Add-GitPrompt -Format @(
    "%branch%",
    "%status%",
    "%ahead%",
    "%behind%"
)

# Git icons
Set-GitIcons -Icons @{
    Clean = "✓"
    Dirty = "✗"
    Ahead = "↑"
    Behind = "↓"
}
```

### 2. Environment Integration
```powershell
# Virtual environment
Show-VenvPrompt

# AWS profile
Show-AWSPrompt

# Azure context
Show-AzurePrompt
```

### 3. Starship Configuration
```powershell
# Starship config location
$starshipConfig = "D:/Code/Lab/build/the-lab-v1/.config/starship.toml"

# Import Starship settings
Import-StarshipConfig -Path $starshipConfig

# Export PSProfile settings to Starship
Export-ToStarshipConfig -Path $starshipConfig
```

### 4. Cross-Platform Support
```powershell
# Platform-specific initialization
switch ($PSVersionTable.Platform) {
    "Win32NT" {
        $starshipExe = "C:/Program Files/starship/bin/starship.exe"
    }
    "Unix" {
        $starshipExe = "/usr/local/bin/starship"
    }
}
```

## Advanced Features

### 1. Dynamic Content
```powershell
# Dynamic segments
Add-DynamicSegment -Name "Status" -Provider {
    Get-SystemStatus
}

# Conditional segments
Add-ConditionalSegment -Name "Warning" -Condition {
    Test-WarningCondition
}
```

### 2. Performance
```powershell
# Async updates
Enable-AsyncPrompt

# Cached content
Set-PromptCache -Duration "5s"

# Performance monitoring
Measure-PromptPerformance
```

### 3. Prompt Switching
```powershell
# Dynamic prompt switching
Switch-PromptSystem -To "Starship"
Switch-PromptSystem -To "PSProfile"

# Temporary override
Use-PromptSystem -System "PSProfile" -ScriptBlock {
    # Commands using PSProfile prompt
}
```

### 4. Configuration Sync
```powershell
# Sync configurations
Sync-PromptConfiguration -From "Starship" -To "PSProfile"

# Watch for changes
Watch-ConfigurationChanges -Path $starshipConfig
```

## Best Practices

### 1. Design
- Clear information
- Consistent style
- Visual hierarchy
- Status indication
- Error feedback

### 2. Performance
- Efficient updates
- Cached data
- Async operations
- Resource management

### 3. Customization
- Modular design
- Theme support
- Segment flexibility
- Easy configuration

### 4. Starship Integration
- Use Starship as primary prompt
- Maintain fallback compatibility
- Sync configurations
- Monitor performance
- Handle errors gracefully

## Troubleshooting

### Common Issues

1. **Display Problems**
   ```powershell
   # Test prompt
   Test-Prompt
   
   # Reset prompt
   Reset-Prompt
   ```

2. **Performance Issues**
   ```powershell
   # Check performance
   Test-PromptPerformance
   
   # Optimize prompt
   Optimize-Prompt
   ```

3. **Integration Issues**
   ```powershell
   # Test integration
   Test-PromptIntegration
   
   # Reset integration
   Reset-PromptIntegration
   ```

4. **Starship Issues**
   ```powershell
   # Test Starship
   Test-StarshipInstallation
   
   # Verify config
   Test-StarshipConfig
   ```

5. **Fallback Issues**
   ```powershell
   # Test fallback
   Test-FallbackPrompt
   
   # Reset to default
   Reset-ToDefaultPrompt
   ```

## Development

### 1. Custom Segments
```powershell
# Segment template
New-SegmentTemplate -Name "Custom"

# Add functionality
Add-SegmentFunction -Name "Custom" -Function {
    # Segment logic
}
```

### 2. Testing
```powershell
# Test prompt
Test-PromptDisplay

# Test segments
Test-PromptSegments

# Test themes
Test-PromptThemes
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
