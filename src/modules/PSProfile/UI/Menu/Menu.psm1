using namespace System.Management.Automation.Host

#Requires -Version 5.1
<#
.SYNOPSIS
    Interactive menu system module for PSProfile.

.DESCRIPTION
    The Menu module provides a comprehensive menu system for PSProfile, including:
    - Dynamic menu generation
    - Keyboard navigation
    - Multi-level menus
    - Custom styling
    - Action handlers
    - Context-sensitive help

.NOTES
    Name: Menu
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
#>

using module ..\..\Core\Logging\Logging.psm1
using module ..\..\Core\Configuration\Configuration.psm1
using module .\Config\PromptMenu.psm1

# Menu styles
$script:MenuStyles = @{
    Title = @{ForegroundColor = 'Cyan'}
    Separator = @{ForegroundColor = 'DarkGray'}
    Option = @{ForegroundColor = 'White'}
    Selected = @{ForegroundColor = 'Green'}
    Error = @{ForegroundColor = 'Red'}
}

function Initialize-MenuSystem {
    <#
    .SYNOPSIS
        Initializes the menu system.

    .DESCRIPTION
        This function sets up the menu system by:
        - Loading menu configurations
        - Setting up key bindings
        - Configuring display settings
        - Initializing event handlers
        - Setting up default styles

    .PARAMETER Theme
        The theme to use for the menu system.
        Valid values: Default, Dark, Light, Custom

    .PARAMETER CustomTheme
        Hashtable of custom theme settings.

    .EXAMPLE
        Initialize-MenuSystem
        Initializes the menu system with default settings.

    .EXAMPLE
        Initialize-MenuSystem -Theme Dark
        Initializes the menu system with dark theme.

    .EXAMPLE
        $theme = @{
            Background = 'Navy'
            Foreground = 'White'
            Selection = 'Yellow'
            Border = 'Cyan'
        }
        Initialize-MenuSystem -Theme Custom -CustomTheme $theme
        Initializes the menu system with custom theme.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('Default', 'Dark', 'Light', 'Custom')]
        [string]$Theme = 'Default',

        [Parameter()]
        [hashtable]$CustomTheme
    )
    {{ ... }}
}

function New-Menu {
    <#
    .SYNOPSIS
        Creates a new menu.

    .DESCRIPTION
        This function creates a new menu with specified options and settings.
        It supports:
        - Multiple menu types
        - Custom styling
        - Keyboard shortcuts
        - Dynamic content
        - Event handlers

    .PARAMETER Title
        Title of the menu.

    .PARAMETER Items
        Array of menu items.

    .PARAMETER Type
        Type of menu. Valid values:
        - List (default)
        - Grid
        - Tree
        - Dropdown

    .PARAMETER Style
        Custom style settings for the menu.

    .PARAMETER Parent
        Parent menu for hierarchical menus.

    .EXAMPLE
        $items = @(
            @{ Text = "Option 1"; Action = { Write-Host "Selected 1" } }
            @{ Text = "Option 2"; Action = { Write-Host "Selected 2" } }
        )
        New-Menu -Title "Main Menu" -Items $items
        Creates a simple list menu with two options.

    .EXAMPLE
        $style = @{
            BorderColor = 'Cyan'
            SelectedItemColor = 'Yellow'
            HeaderColor = 'Green'
        }
        New-Menu -Title "Settings" -Items $items -Type Grid -Style $style
        Creates a grid menu with custom styling.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [array]$Items,

        [Parameter()]
        [ValidateSet('List', 'Grid', 'Tree', 'Dropdown')]
        [string]$Type = 'List',

        [Parameter()]
        [hashtable]$Style,

        [Parameter()]
        [object]$Parent
    )
    {{ ... }}
}

function Show-Menu {
    <#
    .SYNOPSIS
        Displays a menu and handles user interaction.

    .DESCRIPTION
        This function displays a menu and manages user interaction.
        It handles:
        - Menu rendering
        - Key input
        - Selection handling
        - Event processing
        - Navigation

    .PARAMETER Menu
        The menu object to display.

    .PARAMETER Position
        Position where to display the menu.
        Valid values: Center, TopLeft, TopRight, BottomLeft, BottomRight

    .PARAMETER Modal
        If specified, shows the menu as a modal dialog.

    .EXAMPLE
        Show-Menu -Menu $mainMenu
        Displays the main menu centered on screen.

    .EXAMPLE
        Show-Menu -Menu $contextMenu -Position TopRight -Modal
        Shows a modal context menu in the top-right corner.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Menu,

        [Parameter()]
        [ValidateSet('Center', 'TopLeft', 'TopRight', 'BottomLeft', 'BottomRight')]
        [string]$Position = 'Center',

        [switch]$Modal
    )
    {{ ... }}
}

function Add-MenuItem {
    <#
    .SYNOPSIS
        Adds an item to a menu.

    .DESCRIPTION
        This function adds a new item to an existing menu.
        Supports:
        - Text items
        - Separators
        - Submenus
        - Custom actions
        - Keyboard shortcuts

    .PARAMETER Menu
        The menu to add the item to.

    .PARAMETER Text
        Text to display for the item.

    .PARAMETER Action
        ScriptBlock to execute when item is selected.

    .PARAMETER Shortcut
        Keyboard shortcut for the item.

    .PARAMETER Icon
        Icon to display next to the item.

    .EXAMPLE
        Add-MenuItem -Menu $mainMenu -Text "Settings" -Action { Show-Settings }
        Adds a settings item to the main menu.

    .EXAMPLE
        Add-MenuItem -Menu $fileMenu -Text "Save" -Action { Save-File } -Shortcut "Ctrl+S" -Icon "💾"
        Adds a save item with shortcut and icon.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Menu,

        [Parameter(Mandatory)]
        [string]$Text,

        [Parameter()]
        [scriptblock]$Action,

        [Parameter()]
        [string]$Shortcut,

        [Parameter()]
        [string]$Icon
    )
    {{ ... }}
}

function Remove-MenuItem {
    <#
    .SYNOPSIS
        Removes an item from a menu.

    .DESCRIPTION
        This function removes an item from an existing menu.

    .PARAMETER Menu
        The menu to remove the item from.

    .PARAMETER Index
        Index of the item to remove.

    .PARAMETER Text
        Text of the item to remove.

    .EXAMPLE
        Remove-MenuItem -Menu $mainMenu -Index 2
        Removes the third item from the main menu.

    .EXAMPLE
        Remove-MenuItem -Menu $fileMenu -Text "Exit"
        Removes the Exit item from the file menu.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Menu,

        [Parameter(ParameterSetName = 'ByIndex')]
        [int]$Index,

        [Parameter(ParameterSetName = 'ByText')]
        [string]$Text
    )
    {{ ... }}
}

function Set-MenuStyle {
    <#
    .SYNOPSIS
        Sets the style for a menu.

    .DESCRIPTION
        This function sets the visual style for a menu.
        Configurable elements include:
        - Colors
        - Borders
        - Spacing
        - Icons
        - Animations

    .PARAMETER Menu
        The menu to style.

    .PARAMETER Style
        Hashtable of style settings.

    .PARAMETER Theme
        Predefined theme to use.

    .EXAMPLE
        $style = @{
            BorderColor = 'Blue'
            SelectedItemColor = 'Yellow'
            HeaderColor = 'Green'
        }
        Set-MenuStyle -Menu $mainMenu -Style $style
        Sets custom style for the main menu.

    .EXAMPLE
        Set-MenuStyle -Menu $contextMenu -Theme Dark
        Applies dark theme to the context menu.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Menu,

        [Parameter(ParameterSetName = 'CustomStyle')]
        [hashtable]$Style,

        [Parameter(ParameterSetName = 'Theme')]
        [ValidateSet('Default', 'Dark', 'Light')]
        [string]$Theme
    )
    {{ ... }}
}

function Show-ProfileMenu {
    [CmdletBinding()]
    param()
    
    try {
        $options = @(
            @{Key = '1'; Label = 'Features'; Action = { Show-FeatureMenu }}
            @{Key = '2'; Label = 'Configuration'; Action = { Show-ConfigMenu }}
            @{Key = '3'; Label = 'Modules'; Action = { Show-ModuleMenu }}
            @{Key = '4'; Label = 'Prompt Configuration'; Action = { Show-PromptConfigMenu }}
            @{Key = 'Q'; Label = 'Quit'; Action = { return }}
        )
        
        Write-Host "`nPSProfile Management" $script:MenuStyles.Title
        Write-Host ("=" * 50) $script:MenuStyles.Separator
        
        foreach ($opt in $options) {
            Write-Host "[$($opt.Key)] $($opt.Label)" $script:MenuStyles.Option
        }
        
        Write-Host ("=" * 50) $script:MenuStyles.Separator
        $choice = Read-Host "Select an option"
        
        $selected = $options | Where-Object { $_.Key -eq $choice }
        if ($selected) {
            & $selected.Action
        }
        else {
            Write-Host "Invalid option: $choice" $script:MenuStyles.Error
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area "ProfileMenu"
        throw
    }
}

function Show-FeatureMenu {
    [CmdletBinding()]
    param()
    
    try {
        $config = Get-PSProfileConfig
        $features = Get-ProfileFeatures
        
        Write-Host "`nFeature Management" $script:MenuStyles.Title
        Write-Host ("=" * 50) $script:MenuStyles.Separator
        
        $i = 1
        $options = @{}
        foreach ($feature in $features) {
            $status = if ($feature.Enabled) { "Enabled" } else { "Disabled" }
            Write-Host "[$i] $($feature.Name) - $status" $script:MenuStyles.Option
            $options[$i.ToString()] = $feature
            $i++
        }
        
        Write-Host "`n[B] Back" $script:MenuStyles.Option
        Write-Host ("=" * 50) $script:MenuStyles.Separator
        
        $choice = Read-Host "Select a feature to toggle"
        
        if ($choice -eq 'B') {
            Show-ProfileMenu
            return
        }
        
        if ($options.ContainsKey($choice)) {
            $feature = $options[$choice]
            $config.Features.$($feature.Name) = -not $config.Features.$($feature.Name)
            Set-PSProfileConfig -Configuration $config
            Write-Host "$($feature.Name) has been $($config.Features.$($feature.Name) ? 'enabled' : 'disabled')" $script:MenuStyles.Selected
            Start-Sleep -Seconds 1
            Show-FeatureMenu
        }
        else {
            Write-Host "Invalid option: $choice" $script:MenuStyles.Error
            Start-Sleep -Seconds 1
            Show-FeatureMenu
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area "FeatureMenu"
        throw
    }
}

function Show-ConfigMenu {
    [CmdletBinding()]
    param()
    
    try {
        $config = Get-PSProfileConfig
        
        Write-Host "`nConfiguration Management" $script:MenuStyles.Title
        Write-Host ("=" * 50) $script:MenuStyles.Separator
        
        $options = @(
            @{Key = '1'; Label = 'Set Profile Mode'; Action = {
                Write-Host "`nAvailable Modes:" $script:MenuStyles.Title
                Write-Host "1. Minimal - Core functionality only"
                Write-Host "2. Standard - Core + Git + SSH"
                Write-Host "3. Full - All features enabled"
                
                $modeChoice = Read-Host "Select mode (1-3)"
                switch ($modeChoice) {
                    '1' { Select-ProfileMode -Mode 'Minimal' }
                    '2' { Select-ProfileMode -Mode 'Standard' }
                    '3' { Select-ProfileMode -Mode 'Full' }
                    default { Write-Host "Invalid mode selection" $script:MenuStyles.Error }
                }
            }}
            @{Key = '2'; Label = 'Reset Configuration'; Action = {
                Reset-PSProfileConfig
                Write-Host "Configuration has been reset to defaults" $script:MenuStyles.Selected
            }}
            @{Key = 'B'; Label = 'Back'; Action = { Show-ProfileMenu }}
        )
        
        foreach ($opt in $options) {
            Write-Host "[$($opt.Key)] $($opt.Label)" $script:MenuStyles.Option
        }
        
        Write-Host ("=" * 50) $script:MenuStyles.Separator
        $choice = Read-Host "Select an option"
        
        $selected = $options | Where-Object { $_.Key -eq $choice }
        if ($selected) {
            & $selected.Action
            if ($choice -ne 'B') {
                Start-Sleep -Seconds 1
                Show-ConfigMenu
            }
        }
        else {
            Write-Host "Invalid option: $choice" $script:MenuStyles.Error
            Start-Sleep -Seconds 1
            Show-ConfigMenu
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area "ConfigMenu"
        throw
    }
}

function Show-ModuleMenu {
    [CmdletBinding()]
    param()
    
    try {
        $modules = Get-PSProfileModules
        
        Write-Host "`nModule Management" $script:MenuStyles.Title
        Write-Host ("=" * 50) $script:MenuStyles.Separator
        
        Write-Host "`nCore Modules:" $script:MenuStyles.Title
        foreach ($module in $modules.Core) {
            Write-Host "  - $module" $script:MenuStyles.Option
        }
        
        Write-Host "`nFeature Modules:" $script:MenuStyles.Title
        foreach ($module in $modules.Features) {
            $status = if ($module.Available) {
                if ($module.Enabled) { "Enabled" } else { "Disabled" }
            } else { "Not Installed" }
            Write-Host "  - $($module.Name) [$status]" $script:MenuStyles.Option
        }
        
        Write-Host "`nUI Modules:" $script:MenuStyles.Title
        foreach ($module in $modules.UI) {
            $status = if ($module.Available) { "Installed" } else { "Not Installed" }
            Write-Host "  - $($module.Name) [$status]" $script:MenuStyles.Option
        }
        
        Write-Host "`n[B] Back" $script:MenuStyles.Option
        Write-Host ("=" * 50) $script:MenuStyles.Separator
        
        $choice = Read-Host "Press B to go back"
        if ($choice -eq 'B') {
            Show-ProfileMenu
        }
        else {
            Show-ModuleMenu
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area "ModuleMenu"
        throw
    }
}

function Invoke-MenuCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [scriptblock]$Command,
        [string]$ErrorMessage = "Command failed"
    )
    
    try {
        & $Command
    }
    catch {
        Write-Host $ErrorMessage $script:MenuStyles.Error
        Write-ErrorLog -ErrorRecord $_ -Area "MenuCommand"
        Start-Sleep -Seconds 1
    }
}

# Menu System Module

# Import nested modules
$modulePath = $PSScriptRoot

# Import LoadingMenu module
Import-Module (Join-Path $modulePath 'LoadingMenu.psm1') -Force

# Import FeatureMenu module
Import-Module (Join-Path $modulePath 'FeatureMenu.psm1') -Force

# Re-export functions from nested modules
Export-ModuleMember -Function @(
    'Show-LoadingMenu'
    'Show-FeatureMenu'
    'Show-ProfileStatus'
    'Show-ProfileMenu'
    'Show-ConfigMenu'
    'Show-ModuleMenu'
    'Invoke-MenuCommand'
    'Initialize-MenuSystem'
    'New-Menu'
    'Show-Menu'
    'Add-MenuItem'
    'Remove-MenuItem'
    'Set-MenuStyle'
)
