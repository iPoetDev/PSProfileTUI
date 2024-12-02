@{
    ModuleVersion = '1.0.0'
    GUID = 'a7c9f248-fb5e-4b89-9f9e-98854d3d6e4b'
    Author = 'Charles'
    CompanyName = 'Unknown'
    Copyright = '(c) Charles. All rights reserved.'
    Description = 'PSProfile Prompt System with Starship Integration'
    PowerShellVersion = '5.1'
    NestedModules = @(
        'Starship.ps1',
        'FallbackPrompt.ps1',
        'PromptManager.ps1'
    )
    FunctionsToExport = @(
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
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('PSProfile', 'Prompt', 'Starship')
            ProjectUri = 'https://github.com/ipoetdev/PSProfile'
        }
    }
}
