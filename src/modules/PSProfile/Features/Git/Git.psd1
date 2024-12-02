@{
    ModuleVersion = '1.0.0'
    GUID = '2d4e6f8a-1b3c-4d5e-9f8a-2b3c4d5e6f89'
    Author = 'Charles'
    CompanyName = 'Personal'
    Copyright = '(c) 2024 Charles. All rights reserved.'
    Description = 'Git integration module for PSProfile'
    PowerShellVersion = '5.1'
    
    # Module components
    RootModule = 'Git.psm1'
    
    # Functions to export
    FunctionsToExport = @(
        'Set-GitMergeTools',
        'Initialize-GitAliases',
        'Test-GitConfiguration',
        'Set-GitHostConfig',
        'Switch-GitConfig'
    )
    
    PrivateData = @{
        PSData = @{
            Tags = @('Git', 'PSProfile', 'VCS')
            ProjectUri = ''
        }
    }
}
