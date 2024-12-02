# PSProfile Menu Configuration
@{
    # General Menu Settings
    General = @{
        # Default loading mode (Blank, Minimal, Full)
        DefaultMode = 'Minimal'
        
        # Show loading menu on startup
        ShowLoadingMenu = $true
        
        # Remember last used mode
        RememberLastMode = $true
        
        # Auto-hide menu after selection (seconds, 0 to disable)
        AutoHideDelay = 2
        
        # Show feature status in prompt
        ShowStatusInPrompt = $true
    }
    
    # Visual Settings
    Visual = @{
        # Color scheme
        Colors = @{
            Title = 'Cyan'
            Border = 'DarkCyan'
            MenuItems = 'White'
            Description = 'DarkGray'
            Selected = 'Yellow'
            Success = 'Green'
            Warning = 'Yellow'
            Error = 'Red'
            Status = @{
                Loaded = 'Green'
                Available = 'Yellow'
                Disabled = 'DarkGray'
                Error = 'Red'
            }
        }
        
        # Menu style
        Style = @{
            # Border style (Single, Double, Ascii)
            BorderStyle = 'Double'
            
            # Menu width
            Width = 60
            
            # Show feature descriptions
            ShowDescriptions = $true
            
            # Show icons
            UseIcons = $true
            
            # Icons (if UseIcons is true)
            Icons = @{
                Loaded = '✓'
                Available = '○'
                Disabled = '×'
                Error = '!'
                Arrow = '→'
                Bullet = '•'
            }
        }
    }
    
    # Feature Categories
    Categories = @{
        Core = @{
            DisplayName = 'Core Features'
            Order = 1
            Description = 'Essential system features'
            Features = @(
                'Configuration'
                'Logging'
                'Initialize'
            )
        }
        Development = @{
            DisplayName = 'Development Tools'
            Order = 2
            Description = 'Development-related features'
            Features = @(
                'Git'
                'SSH'
                'VirtualEnv'
            )
        }
        UI = @{
            DisplayName = 'User Interface'
            Order = 3
            Description = 'UI customization features'
            Features = @(
                'Prompt'
                'Theme'
            )
        }
    }
    
    # Feature Configurations
    Features = @{
        Configuration = @{
            DisplayName = 'Configuration Manager'
            Description = 'Manage PSProfile settings'
            Category = 'Core'
            RequiredInModes = @('Minimal', 'Full')
        }
        Logging = @{
            DisplayName = 'Logging System'
            Description = 'Error and activity logging'
            Category = 'Core'
            RequiredInModes = @('Minimal', 'Full')
        }
        Initialize = @{
            DisplayName = 'System Initialization'
            Description = 'Core system initialization'
            Category = 'Core'
            RequiredInModes = @('Full')
        }
        Git = @{
            DisplayName = 'Git Integration'
            Description = 'Git version control features'
            Category = 'Development'
            RequiredInModes = @('Full')
        }
        SSH = @{
            DisplayName = 'SSH Management'
            Description = 'SSH key and config management'
            Category = 'Development'
            RequiredInModes = @('Full')
        }
        VirtualEnv = @{
            DisplayName = 'Virtual Environments'
            Description = 'Python virtual environment support'
            Category = 'Development'
            RequiredInModes = @('Full')
        }
        Prompt = @{
            DisplayName = 'Custom Prompt'
            Description = 'Enhanced PowerShell prompt'
            Category = 'UI'
            RequiredInModes = @('Minimal', 'Full')
        }
        Theme = @{
            DisplayName = 'Theme Manager'
            Description = 'Console color themes'
            Category = 'UI'
            RequiredInModes = @('Full')
        }
    }
    
    # Loading Menu Configuration
    LoadingMenu = @{
        # Title settings
        Title = @{
            Text = 'PSProfile Loading Menu'
            ShowBorder = $true
        }
        
        # Mode descriptions
        ModeDescriptions = @{
            Blank = @{
                Name = 'Blank Profile'
                Description = 'Basic PowerShell environment'
                Details = @(
                    'No additional features'
                    'Fastest startup time'
                    'Minimal memory usage'
                )
            }
            Minimal = @{
                Name = 'Minimal Profile'
                Description = 'Essential features only'
                Details = @(
                    'Core configuration'
                    'Basic logging'
                    'Custom prompt'
                )
                Recommended = $true
            }
            Full = @{
                Name = 'Full Profile'
                Description = 'Complete environment'
                Details = @(
                    'All features enabled'
                    'Development tools'
                    'UI customization'
                )
            }
        }
    }
    
    # Feature Menu Configuration
    FeatureMenu = @{
        # Title settings
        Title = @{
            Text = 'PSProfile Feature Menu'
            ShowBorder = $true
        }
        
        # Status display settings
        Status = @{
            ShowLoadTime = $true
            ShowMemoryUsage = $true
            ShowLastError = $true
            MaxRecentErrors = 3
        }
        
        # Menu sections
        Sections = @(
            @{
                Name = 'Features'
                Type = 'CategoryList'
                Order = 1
            }
            @{
                Name = 'Options'
                Type = 'CommandList'
                Order = 2
            }
            @{
                Name = 'Status'
                Type = 'StatusDisplay'
                Order = 3
            }
        )
    }
}
