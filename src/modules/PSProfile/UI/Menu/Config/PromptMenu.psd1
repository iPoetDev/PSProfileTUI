@{
    ModuleVersion = '1.0.0'
    GUID = 'f8d0c431-d95e-4c73-b6bc-78b9e6c548d9'
    Author = 'Charles Fowler'
    CompanyName = 'PSProfile'
    Copyright = '(c) 2024 Charles Fowler. All rights reserved.'
    Description = 'Prompt configuration menu for PSProfile'
    PowerShellVersion = '5.1'
    RequiredModules = @(
        @{ModuleName = 'Configuration'; ModuleVersion = '1.0.0'}
    )
    FunctionsToExport = @('Show-PromptConfigMenu')
    PrivateData = @{
        PSData = @{
            Tags = @('PSProfile', 'Menu', 'Configuration', 'Prompt')
            ProjectUri = 'https://github.com/ipoetdev/PSProfile'
        }
    }
}
