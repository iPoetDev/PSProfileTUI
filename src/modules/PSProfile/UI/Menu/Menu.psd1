@{
    ModuleVersion = '1.0.0'
    GUID = '5g7h9i1d-4e6f-7g8h-0i1j-5e6f7g8h9i92'
    Author = 'Charles'
    CompanyName = 'Personal'
    Copyright = '(c) 2024 Charles. All rights reserved.'
    Description = 'Interactive menu system for PSProfile'
    PowerShellVersion = '5.1'
    
    # Module components
    RootModule = 'Menu.psm1'
    NestedModules = @(
        'LoadingMenu.psm1'
        'FeatureMenu.psm1'
    )
    
    # Functions to export
    FunctionsToExport = @(
        'Show-ProfileMenu'
        'Show-FeatureMenu'
        'Show-ConfigMenu'
        'Show-ModuleMenu'
        'Invoke-MenuCommand'
    )
    
    PrivateData = @{
        PSData = @{
            Tags = @('Menu', 'UI', 'Interactive')
        }
    }
}
