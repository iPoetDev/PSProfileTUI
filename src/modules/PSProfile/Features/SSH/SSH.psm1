#Requires -Version 5.1
<#
.SYNOPSIS
    SSH integration module for PSProfile.

.DESCRIPTION
    The SSH module provides comprehensive SSH integration for PSProfile, including:
    - SSH key management
    - Agent configuration
    - Host configuration
    - Key generation and deployment
    - Multiple identity support

.NOTES
    Name: SSH
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
    Requires: OpenSSH must be installed
#>

using module ..\..\Core\Logging.psm1

function Initialize-SSHSystem {
    <#
    .SYNOPSIS
        Initializes the SSH integration system.

    .DESCRIPTION
        This function sets up the SSH integration system by:
        - Verifying OpenSSH installation
        - Configuring SSH agent
        - Setting up default configurations
        - Managing SSH keys
        - Configuring known hosts

    .PARAMETER ForceReload
        Forces reinitialization even if already initialized.

    .EXAMPLE
        Initialize-SSHSystem
        Initializes the SSH system with default settings.

    .EXAMPLE
        Initialize-SSHSystem -ForceReload
        Forces reinitialization of the SSH system.
    #>
    [CmdletBinding()]
    param(
        [switch]$ForceReload
    )

    try {
        # Ensure SSH directory exists
        if (-not (Test-Path $script:SSHDir)) {
            New-Item -ItemType Directory -Path $script:SSHDir -Force | Out-Null
            # Set appropriate permissions
            $acl = Get-Acl $script:SSHDir
            $acl.SetAccessRuleProtection($true, $false)
            $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
                'FullControl',
                'ContainerInherit,ObjectInherit',
                'None',
                'Allow'
            )
            $acl.AddAccessRule($rule)
            Set-Acl $script:SSHDir $acl
        }

        # Check for ssh-agent service
        $sshAgent = Get-Service ssh-agent -ErrorAction SilentlyContinue
        if ($sshAgent) {
            if ($sshAgent.Status -ne 'Running') {
                Start-Service ssh-agent
                Write-Host 'Started SSH agent service' -ForegroundColor Green
            }
        }
        else {
            Write-Warning 'SSH agent service not found. Consider installing OpenSSH.'
        }

        # Load keys if force reload or not already loaded
        if ($ForceReload -or -not (ssh-add -l)) {
            Get-ChildItem $script:SSHDir -Filter 'id_*' | Where-Object { -not $_.Name.EndsWith('.pub') } | ForEach-Object {
                ssh-add $_.FullName
            }
        }

        Write-Host 'SSH system initialized successfully' -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'SSHSystem'
        throw
    }
}

function Add-SSHConfig {
    <#
    .SYNOPSIS
        Adds an SSH configuration for a host.

    .DESCRIPTION
        This function adds an SSH configuration for a specified host.
        It supports:
        - Multiple host patterns
        - Custom identity files
        - Port configuration
        - Additional options

    .PARAMETER HostName
        The host pattern to configure.

    .PARAMETER User
        The username to use for the host.

    .PARAMETER IdentityFile
        The path to the identity file.

    .PARAMETER Port
        The port to connect to.

    .PARAMETER AdditionalOptions
        Hashtable of additional options for the host.

    .EXAMPLE
        Add-SSHConfig -HostName "github.com" -User "git" -IdentityFile "~/.ssh/github"
        Configures GitHub-specific SSH settings.

    .EXAMPLE
        Add-SSHConfig -HostName "custom.server" -Port 2222 -AdditionalOptions @{
            ServerAliveInterval = 60
            AddKeysToAgent = "yes"
        }
        Configures custom server SSH settings.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$HostName,
        [string]$User,
        [string]$IdentityFile,
        [string]$Port,
        [hashtable]$AdditionalOptions
    )

    try {
        $configPath = Join-Path $script:SSHDir 'config'
        $configContent = @()

        if (Test-Path $configPath) {
            $configContent = Get-Content $configPath
        }

        $newConfig = @("Host $HostName")
        if ($User) { $newConfig += "    User $User" }
        if ($IdentityFile) { $newConfig += "    IdentityFile $IdentityFile" }
        if ($Port) { $newConfig += "    Port $Port" }

        if ($AdditionalOptions) {
            foreach ($key in $AdditionalOptions.Keys) {
                $newConfig += "    $key $($AdditionalOptions[$key])"
            }
        }

        # Add empty line if file not empty
        if ($configContent) {
            $configContent += ''
        }

        $configContent += $newConfig
        $configContent | Out-File $configPath -Encoding utf8 -Force

        Write-Host "SSH configuration for $HostName added successfully" -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'SSHConfig'
        throw
    }
}

function Backup-SSHConfiguration {
    <#
    .SYNOPSIS
        Backs up the SSH configuration.

    .DESCRIPTION
        This function backs up the SSH configuration, including:
        - Identity files
        - Known hosts
        - SSH agent configuration
        - SSH configuration files

    .PARAMETER BackupPath
        The path to store the backup.

    .PARAMETER RetentionDays
        The number of days to retain backups.

    .PARAMETER NoEncryption
        If specified, does not encrypt the backup.

    .EXAMPLE
        Backup-SSHConfiguration
        Backs up the SSH configuration to the default location.

    .EXAMPLE
        Backup-SSHConfiguration -BackupPath "C:\Backups\SSH" -RetentionDays 30 -NoEncryption
        Backs up the SSH configuration to a custom location with no encryption.
    #>
    [CmdletBinding()]
    param(
        [string]$BackupPath = (Join-Path $env:USERPROFILE "ssh_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"),
        [int]$RetentionDays = 30,
        [switch]$NoEncryption
    )

    try {
        # Create backup directory
        New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null

        # Get encryption key if needed
        $encryptionKey = if (-not $NoEncryption) {
            Get-BackupEncryptionKey
        }

        # Create manifest
        $manifest = @{
            Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            Files     = @()
        }

        # Backup files
        Get-ChildItem $script:SSHDir -File | ForEach-Object {
            $relativePath = $_.Name
            $targetPath = Join-Path $BackupPath $relativePath

            if ($_.Extension -ne '.pub' -and -not $NoEncryption) {
                # Encrypt private keys
                $content = Get-Content $_.FullName -Raw
                $encryptedBytes = Protect-CmsMessage -Content $content -To $encryptionKey
                $encryptedBytes | Out-File "$targetPath.enc" -Encoding utf8
                $manifest.Files += @{
                    RelativePath = $relativePath
                    Encrypted    = $true
                    Hash         = (Get-FileHash $_.FullName).Hash
                }
            }
            else {
                # Copy public keys and config as-is
                Copy-Item $_.FullName $targetPath
                $manifest.Files += @{
                    RelativePath = $relativePath
                    Encrypted    = $false
                    Hash         = (Get-FileHash $_.FullName).Hash
                }
            }
        }

        # Save manifest
        $manifest | ConvertTo-Json | Out-File (Join-Path $BackupPath 'manifest.json') -Encoding utf8

        # Cleanup old backups
        if ($RetentionDays -gt 0) {
            Get-ChildItem $env:USERPROFILE -Directory -Filter 'ssh_backup_*' |
                Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) } |
                Remove-Item -Recurse -Force
        }

        Write-Host "SSH configuration backed up to: $BackupPath" -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'SSHBackup'
        throw
    }
}

function Restore-SSHConfiguration {
    <#
    .SYNOPSIS
        Restores the SSH configuration from a backup.

    .DESCRIPTION
        This function restores the SSH configuration from a backup, including:
        - Identity files
        - Known hosts
        - SSH agent configuration
        - SSH configuration files

    .PARAMETER BackupPath
        The path to the backup.

    .PARAMETER Force
        If specified, overwrites existing configuration.

    .EXAMPLE
        Restore-SSHConfiguration -BackupPath "C:\Backups\SSH"
        Restores the SSH configuration from a backup.

    .EXAMPLE
        Restore-SSHConfiguration -BackupPath "C:\Backups\SSH" -Force
        Restores the SSH configuration from a backup, overwriting existing configuration.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$BackupPath,
        [switch]$Force
    )

    try {
        # Verify backup exists
        if (-not (Test-Path $BackupPath)) {
            throw "Backup directory not found: $BackupPath"
        }

        # Read manifest
        $manifestPath = Join-Path $BackupPath 'manifest.json'
        if (-not (Test-Path $manifestPath)) {
            throw 'Manifest file not found in backup'
        }

        $manifest = Get-Content $manifestPath | ConvertFrom-Json

        # Verify target directory
        if ((Test-Path $script:SSHDir) -and (Get-ChildItem $script:SSHDir) -and -not $Force) {
            throw 'SSH directory not empty. Use -Force to overwrite'
        }

        # Create SSH directory if needed
        if (-not (Test-Path $script:SSHDir)) {
            New-Item -ItemType Directory -Path $script:SSHDir -Force | Out-Null
        }

        # Restore files
        foreach ($file in $manifest.Files) {
            $sourcePath = if ($file.Encrypted) {
                Join-Path $BackupPath "$($file.RelativePath).enc"
            }
            else {
                Join-Path $BackupPath $file.RelativePath
            }

            $targetPath = Join-Path $script:SSHDir $file.RelativePath

            if ($file.Encrypted) {
                # Decrypt and restore private keys
                $encryptedContent = Get-Content $sourcePath -Raw
                $decryptedContent = Unprotect-CmsMessage -Content $encryptedContent
                $decryptedContent | Out-File $targetPath -Encoding utf8
            }
            else {
                # Copy public keys and config as-is
                Copy-Item $sourcePath $targetPath -Force
            }

            # Verify restored file
            $restoredHash = (Get-FileHash $targetPath).Hash
            if ($restoredHash -ne $file.Hash) {
                throw "Hash mismatch for file: $($file.RelativePath)"
            }
        }

        Write-Host "SSH configuration restored successfully from: $BackupPath" -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'SSHRestore'
        throw
    }
}

function Test-BackupIntegrity {
    <#
    .SYNOPSIS
        Tests the integrity of an SSH backup.

    .DESCRIPTION
        This function tests the integrity of an SSH backup, including:
        - File existence
        - File hashes
        - Encryption

    .PARAMETER BackupPath
        The path to the backup.

    .PARAMETER Detailed
        If specified, returns detailed integrity information.

    .EXAMPLE
        Test-BackupIntegrity -BackupPath "C:\Backups\SSH"
        Tests the integrity of an SSH backup.

    .EXAMPLE
        Test-BackupIntegrity -BackupPath "C:\Backups\SSH" -Detailed
        Tests the integrity of an SSH backup with detailed output.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$BackupPath,
        [switch]$Detailed
    )

    try {
        $issues = @()
        $verified = @()

        # Check if backup exists
        if (-not (Test-Path $BackupPath)) {
            throw "Backup directory not found: $BackupPath"
        }

        # Read manifest
        $manifestPath = Join-Path $BackupPath 'manifest.json'
        if (-not (Test-Path $manifestPath)) {
            throw 'Manifest file not found in backup'
        }

        $manifest = Get-Content $manifestPath | ConvertFrom-Json

        # Verify each file
        foreach ($file in $manifest.Files) {
            $backupFile = if ($file.Encrypted) {
                Join-Path $BackupPath "$($file.RelativePath).enc"
            }
            else {
                Join-Path $BackupPath $file.RelativePath
            }

            if (-not (Test-Path $backupFile)) {
                $issues += "Missing file: $($file.RelativePath)"
                continue
            }

            if (-not $file.Encrypted) {
                $hash = (Get-FileHash $backupFile).Hash
                if ($hash -ne $file.Hash) {
                    $issues += "Hash mismatch for file: $($file.RelativePath)"
                }
                else {
                    $verified += $file.RelativePath
                }
            }
            else {
                # For encrypted files, we can only verify file existence
                $verified += $file.RelativePath
            }
        }

        if ($Detailed) {
            [PSCustomObject]@{
                BackupPath    = $BackupPath
                Timestamp     = $manifest.Timestamp
                VerifiedFiles = $verified
                Issues        = $issues
                IsValid       = $issues.Count -eq 0
            }
        }
        else {
            $issues.Count -eq 0
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'SSHBackupVerify'
        throw
    }
}

# Add convenient alias for verification
Set-Alias -Name ssh-verify -Value Test-BackupIntegrity

Export-ModuleMember -Function Initialize-SSHSystem, Add-SSHConfig, Backup-SSHConfiguration,
Restore-SSHConfiguration, Test-BackupIntegrity,
Get-BackupEncryptionKey, Verify-Signature -Alias ssh-verify

function Get-BackupEncryptionKey {
    <#
    .SYNOPSIS
        Gets the backup encryption key.

    .DESCRIPTION
        This function gets the backup encryption key, generating a new one if needed.

    .PARAMETER Generate
        If specified, generates a new encryption key.

    .EXAMPLE
        Get-BackupEncryptionKey
        Gets the backup encryption key.

    .EXAMPLE
        Get-BackupEncryptionKey -Generate
        Generates a new backup encryption key.
    #>
    [CmdletBinding()]
    param(
        [switch]$Generate
    )

    $keyPath = Join-Path $script:SSHDir '.backup_key'

    if ($Generate -or -not (Test-Path $keyPath)) {
        $key = New-Object byte[] 32
        [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($key)
        $key | Set-Content $keyPath -Encoding Byte

        Write-Host "Generated new backup encryption key at: $keyPath" -ForegroundColor Green
        Write-Host "IMPORTANT: Keep this key safe! You'll need it to restore encrypted backups." -ForegroundColor Yellow
    }

    return Get-Content $keyPath -Encoding Byte
}

function Verify-Signature {
    <#
    .SYNOPSIS
        Verifies a signature.

    .DESCRIPTION
        This function verifies a signature using a public key.

    .PARAMETER Data
        The data to verify.

    .PARAMETER SignatureBase64
        The signature to verify.

    .PARAMETER PublicKeyBase64
        The public key to use for verification.

    .EXAMPLE
        Verify-Signature -Data "Hello World" -SignatureBase64 "..." -PublicKeyBase64 "..."
        Verifies a signature.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Data,
        [Parameter(Mandatory)]
        [string]$SignatureBase64,
        [Parameter(Mandatory)]
        [string]$PublicKeyBase64
    )

    $rsa = [System.Security.Cryptography.RSA]::Create()
    try {
        $publicKeyBytes = [Convert]::FromBase64String($PublicKeyBase64)
        $rsa.ImportRSAPublicKey($publicKeyBytes, [ref]$null)

        $dataBytes = [System.Text.Encoding]::UTF8.GetBytes($Data)
        $signatureBytes = [Convert]::FromBase64String($SignatureBase64)

        return $rsa.VerifyData(
            $dataBytes,
            $signatureBytes,
            [System.Security.Cryptography.HashAlgorithmName]::SHA256,
            [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
        )
    }
    finally {
        $rsa.Dispose()
    }
}
