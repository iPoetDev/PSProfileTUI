@{
    ModuleVersion = '1.0.0'
    GUID = '3e5f7g9b-2c4d-5e6f-8g9h-3c4d5e6f7g90'
    Author = 'Charles'
    CompanyName = 'Personal'
    Copyright = '(c) 2024 Charles. All rights reserved.'
    Description = 'SSH management module for PSProfile'
    PowerShellVersion = '5.1'
    
    # Module components
    RootModule = 'SSH.psm1'
    
    # Functions to export
    FunctionsToExport = @(
        'Initialize-SSHSystem',
        'Add-SSHConfig',
        'Backup-SSHConfiguration',
        'Restore-SSHConfiguration',
        'Test-BackupIntegrity',
        'Get-BackupEncryptionKey',
        'Verify-Signature'
    )
    
    PrivateData = @{
        PSData = @{
            Tags = @('SSH', 'PSProfile', 'Security')
            ProjectUri = ''
        }
    }
}
