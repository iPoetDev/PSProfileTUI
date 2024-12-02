#Requires -Version 5.1
<#
.SYNOPSIS
    PSProfile Prompt System with Starship Integration

.DESCRIPTION
    A comprehensive prompt management system for PowerShell that primarily uses Starship
    for modern, feature-rich prompts with a fallback to a compatible PSProfile prompt
    when Starship is unavailable.

    This module provides:
    - Modern, customizable prompts using Starship
    - Compatible fallback system
    - Dynamic prompt switching
    - Comprehensive configuration management
    - Performance monitoring and optimization

.COMPONENT Starship Integration
    Primary prompt system using Starship:
    - Modern, customizable prompt
    - Git integration
    - Directory status
    - Environment indicators
    - Performance monitoring

.COMPONENT Fallback System
    PSProfile native prompt when Starship is unavailable:
    - Starship-compatible theme
    - Similar functionality
    - Consistent experience
    - Easy customization

.COMPONENT Prompt Manager
    Central management system:
    - Automatic prompt selection
    - Dynamic switching
    - Configuration management
    - Status monitoring

.EXAMPLE
    # Initialize the prompt system (automatically chooses best option)
    Initialize-PSProfilePrompt

.EXAMPLE
    # Switch to Starship prompt
    Switch-PromptSystem -UseStarship $true

.EXAMPLE
    # Switch to PSProfile fallback prompt
    Switch-PromptSystem -UseStarship $false

.EXAMPLE
    # Get current prompt configuration
    Get-PromptConfiguration

.NOTES
    Author: Charles
    Module: PSProfile.UI.Prompt
    Version: 1.0.0
#>

# Import dependencies
$promptPath = $PSScriptRoot

# Load component modules in order
$components = @(
    'Starship.ps1',
    'FallbackPrompt.ps1',
    'PromptManager.ps1'
)

foreach ($component in $components) {
    $componentPath = Join-Path $promptPath $component
    if (Test-Path $componentPath) {
        . $componentPath
    }
    else {
        Write-Warning "Required component not found: $component"
    }
}

# Export functions (these are also declared in the module manifest)
Export-ModuleMember -Function @(
    # Starship functions
    'Initialize-Starship',
    'Test-StarshipAvailable',
    'Get-StarshipConfig',
    'Reset-StarshipConfig',
    'Import-StarshipConfig',
    'Export-StarshipConfig',
    
    # Fallback functions
    'Initialize-FallbackPrompt',
    'Set-FallbackTheme',
    'Set-FallbackFormat',
    'Get-FallbackConfiguration',
    
    # Manager functions
    'Initialize-PSProfilePrompt',
    'Switch-PromptSystem',
    'Get-PromptConfiguration',
    'Test-PromptSystem'
)
