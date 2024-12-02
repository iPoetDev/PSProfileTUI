#Requires -Version 5.1
<#
.SYNOPSIS
    Git integration module for PSProfile.

.DESCRIPTION
    The Git module provides comprehensive Git integration for PSProfile, including:
    - Multiple Git configuration profiles (personal, work, etc.)
    - Git credential management
    - Repository management tools
    - Git aliases and shortcuts
    - Merge tool configuration

.NOTES
    Name: Git
    Author: Charles Fowler
    Version: 1.0.0
    LastModified: 2024-01-20
    Requires: Git must be installed and accessible from PATH
#>

using module ..\..\Core\Logging.psm1

# Git configuration defaults
$script:GitConfig = @{
    DefaultBranch     = 'main'
    CredentialManager = 'manager-core'
    MergeTools        = @{
        Tool = 'vscode'
        Path = 'code --wait'
    }
}

function Initialize-GitSystem {
    <#
    .SYNOPSIS
        Initializes the Git integration system.

    .DESCRIPTION
        This function sets up the Git integration system by:
        - Verifying Git installation
        - Setting up default configurations
        - Configuring credentials
        - Setting up merge tools
        - Creating aliases

    .PARAMETER Quiet
        Suppresses output.

    .EXAMPLE
        Initialize-GitSystem
        Initializes the Git system with default settings.

    .EXAMPLE
        Initialize-GitSystem -Quiet
        Initializes the Git system without output.
    #>
    [CmdletBinding()]
    param(
        [switch]$Quiet
    )

    try {
        # Check if git is available
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
            throw 'Git is not installed or not in PATH'
        }

        # Configure core git settings
        git config --global init.defaultBranch $script:GitConfig.DefaultBranch
        git config --global credential.helper $script:GitConfig.CredentialManager

        # Configure merge tool
        git config --global merge.tool $script:GitConfig.MergeTools.Tool
        git config --global mergetool.$($script:GitConfig.MergeTools.Tool).cmd $script:GitConfig.MergeTools.Path

        if (-not $Quiet) {
            Write-Host 'Git system initialized successfully' -ForegroundColor Green
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'GitSystem'
        throw
    }
}

function Set-GitMergeTools {
    <#
    .SYNOPSIS
        Configures Git merge tools.

    .DESCRIPTION
        This function configures Git merge tools for handling file conflicts.
        Supports multiple tools including:
        - VS Code
        - Beyond Compare
        - P4Merge
        - WinMerge

    .PARAMETER Tool
        The merge tool to configure. Valid values:
        - VSCode (default)
        - BeyondCompare
        - P4Merge
        - WinMerge

    .PARAMETER Path
        Custom path to the merge tool executable.

    .EXAMPLE
        Set-GitMergeTools
        Configures VS Code as the default merge tool.

    .EXAMPLE
        Set-GitMergeTools -Tool BeyondCompare -Path 'C:\Program Files\Beyond Compare\BCompare.exe'
        Configures Beyond Compare as the merge tool with a custom path.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('VSCode', 'BeyondCompare', 'P4Merge', 'WinMerge')]
        [string]$Tool = 'VSCode',

        [Parameter()]
        [string]$Path
    )

    try {
        git config --global merge.tool $Tool
        git config --global mergetool.$Tool.cmd $Path

        if (-not $Quiet) {
            Write-Host 'Git merge tools configured successfully' -ForegroundColor Green
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'GitMergeTools'
        throw
    }
}

function Add-GitHostConfig {
    <#
    .SYNOPSIS
        Adds Git host configuration.

    .DESCRIPTION
        This function manages Git configurations for different contexts (personal, work, etc.).
        It handles:
        - User information (name, email)
        - GPG signing settings
        - Core Git settings
        - Host-specific configurations

    .PARAMETER HostType
        The type of host to configure. Valid values:
        - github
        - gitlab
        - bitbucket
        - azure
        - custom

    .PARAMETER HostUrl
        The URL of the host.

    .PARAMETER User
        The username for the host.

    .PARAMETER Email
        The email address for the host.

    .PARAMETER NoSSH
        Disables SSH configuration.

    .EXAMPLE
        Add-GitHostConfig -HostType github -HostUrl 'github.com' -User 'ipoetdev' -Email 'ipoetdev-github-no-reply@outlook.com'
        Configures GitHub host settings.

    .EXAMPLE
        Add-GitHostConfig -HostType azure -HostUrl 'dev.azure.com' -User 'ipoetdev' -Email 'ipoetdev-github-no-reply@outlook.com' -NoSSH
        Configures Azure DevOps host settings without SSH.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('github', 'gitlab', 'bitbucket', 'azure', 'custom')]
        [string]$HostType,

        [string]$HostUrl,

        [string]$User,

        [string]$Email,

        [switch]$NoSSH
    )

    try {
        switch ($HostType) {
            'github' {
                $HostUrl = 'github.com'
                if (-not $NoSSH) {
                    $gitUrl = "git@$($HostUrl):"
                    $httpsUrl = "https://$($HostUrl)/"
                    git config --global "url.$gitUrl.insteadOf" $httpsUrl
                }
            }
            'gitlab' {
                $HostUrl = $HostUrl ?? 'gitlab.com'
                if (-not $NoSSH) {
                    $gitUrl = "git@$($HostUrl):"
                    $httpsUrl = "https://$($HostUrl)/"
                    git config --global "url.$gitUrl.insteadOf" $httpsUrl
                }
            }
            'bitbucket' {
                $HostUrl = 'bitbucket.org'
                if (-not $NoSSH) {
                    $gitUrl = "git@$($HostUrl):"
                    $httpsUrl = "https://$($HostUrl)/"
                    git config --global "url.$gitUrl.insteadOf" $httpsUrl
                }
            }
            'azure' {
                if (-not $HostUrl) {
                    throw 'Azure DevOps requires a host URL'
                }
                if (-not $NoSSH) {
                    $gitUrl = "git@ssh.$HostUrl:v3"
                    $httpsUrl = "https://$HostUrl"
                    git config --global "url.$gitUrl.insteadOf" $httpsUrl
                }
            }
        }

        if ($User) {
            git config --global user.name $User
        }
        if ($Email) {
            git config --global user.email $Email
        }

        Write-Host "Git host configuration for $HostType completed successfully" -ForegroundColor Green
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'GitHostConfig'
        throw
    }
}

function Test-GitConfiguration {
    <#
    .SYNOPSIS
        Tests Git configuration settings.

    .DESCRIPTION
        This function verifies Git configuration settings and ensures
        they meet the required standards.

    .PARAMETER Detailed
        If specified, returns detailed test results.

    .EXAMPLE
        Test-GitConfiguration
        Tests all Git configuration scopes.

    .EXAMPLE
        Test-GitConfiguration -Detailed
        Tests all Git configuration scopes with detailed output.
    #>
    [CmdletBinding()]
    param(
        [switch]$Detailed
    )

    try {
        $results = @{
            Core     = @{}
            Security = @{}
            Remote   = @{}
        }

        # Test core configuration
        $results.Core.UserName = git config --global user.name
        $results.Core.UserEmail = git config --global user.email
        $results.Core.DefaultBranch = git config --global init.defaultBranch

        # Test security configuration
        $results.Security.CredentialHelper = git config --global credential.helper
        $results.Security.SigningKey = git config --global user.signingkey

        # Test remote configuration
        $results.Remote.OriginUrl = git config --get remote.origin.url

        if ($Detailed) {
            Write-Host "`nGit Version:" -ForegroundColor Cyan
            git --version

            Write-Host "`nGit Configuration:" -ForegroundColor Cyan
            $results | ConvertTo-Json | Write-Host

            Write-Host "`nGit Aliases:" -ForegroundColor Cyan
            git config --get-regexp alias
        }
        else {
            $results
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'GitConfigTest'
        throw
    }
}

function Initialize-GitAliases {
    <#
    .SYNOPSIS
        Initializes Git aliases.

    .DESCRIPTION
        This function sets up commonly used Git aliases and shortcuts
        to improve productivity.

    .PARAMETER Quiet
        Suppresses output.

    .EXAMPLE
        Initialize-GitAliases
        Sets up default Git aliases.

    .EXAMPLE
        Initialize-GitAliases -Quiet
        Sets up default Git aliases without output.
    #>
    [CmdletBinding()]
    param(
        [switch]$Quiet
    )

    try {
        # Standard aliases
        git config --global alias.co checkout
        git config --global alias.br branch
        git config --global alias.ci commit
        git config --global alias.st status
        git config --global alias.last 'log -1 HEAD'
        git config --global alias.visual '!gitk'

        # Advanced aliases
        git config --global alias.unstage 'reset HEAD --'
        git config --global alias.uncommit 'reset --soft HEAD~1'
        git config --global alias.amend 'commit --amend'
        git config --global alias.graph 'log --graph --oneline --decorate'

        if (-not $Quiet) {
            Write-Host 'Git aliases initialized successfully' -ForegroundColor Green
        }
    }
    catch {
        Write-ErrorLog -ErrorRecord $_ -Area 'GitAliases'
        throw
    }
}

function Set-GitHostConfig {
    <#
    .SYNOPSIS
        Sets Git configuration for different hosting environments.

    .DESCRIPTION
        This function manages Git configurations for different contexts (personal, work, etc.).
        It handles:
        - User information (name, email)
        - GPG signing settings
        - Core Git settings
        - Host-specific configurations

    .PARAMETER ConfigType
        The type of configuration to set. Valid values:
        - personal
        - hackathons
        Or provide a custom configuration.

    .PARAMETER Directory
        The directory where this configuration should apply.

    .PARAMETER CustomConfig
        Optional hashtable with custom configuration settings.

    .EXAMPLE
        Set-GitHostConfig -ConfigType personal -Directory "D:\Projects\Personal"
        Sets personal Git configuration for the specified directory.

    .EXAMPLE
        $config = @{
            'user.name' = "Team Name"
            'user.email' = "team@company.com"
            'commit.gpgsign' = "false"
        }
        Set-GitHostConfig -ConfigType 'team' -Directory "D:\Projects\Team" -CustomConfig $config
        Sets custom team Git configuration.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ConfigType,

        [Parameter(Mandatory)]
        [string]$Directory,

        [Parameter()]
        [hashtable]$CustomConfig
    )

    try {
        # Create directory if it doesn't exist
        if (-not (Test-Path $Directory)) {
            New-Item -ItemType Directory -Path $Directory -Force | Out-Null
        }

        $configFile = Join-Path $Directory ".gitconfig"

        # Built-in configurations
        $configs = @{
            'personal' = @{
                'user.name' = "Charles J Fowler"
                'user.email' = "ipoetdev-github-no-reply@outlook.com"
                'user.username' = "ipoetdev"
                'user.signingkey' = "A667B46ABA2CBCA7"
                'commit.gpgsign' = "true"
                'github.user' = "ipoetdev"
                'core.editor' = "code --wait"
                'web.browser' = "chrome"
            }
            'hackathons' = @{
                'user.name' = "Ai Avengers Teams"
                'user.email' = "ai-avengers-teams@gmail.com"
                'user.username' = "ai-avengers-teams"
                'commit.gpgsign' = "false"
                'github.user' = "ai-avengers-teams"
                'core.editor' = "code-insiders --wait"
                'web.browser' = "edge"
            }
        }

        # If custom config provided, create new config type
        if ($CustomConfig) {
            $configs[$ConfigType] = $CustomConfig
        }
        elseif (-not $configs.ContainsKey($ConfigType)) {
            throw "Unknown config type: $ConfigType. Use 'personal', 'hackathons', or provide custom config."
        }

        # Apply configuration
        $selectedConfig = $configs[$ConfigType]
        foreach ($key in $selectedConfig.Keys) {
            git config --file $configFile $key $selectedConfig[$key]
        }

        # Common settings
        $commonSettings = @{
            'core.autocrlf' = 'true'
            'help.autocorrect' = '50'
            'http.postBuffer' = '524288000'
            'core.compression' = '9'
            'core.fsmonitor' = 'true'
            'core.preloadindex' = 'true'
            'gc.auto' = '256'
        }

        foreach ($key in $commonSettings.Keys) {
            git config --file $configFile $key $commonSettings[$key]
        }

        # Create includeIf directive in global config
        $includeIfPath = "gitdir:$($Directory.Replace('\', '/'))/"
        $currentIncludes = git config --global --get-all include.path

        if ($currentIncludes -notcontains $configFile) {
            git config --global --add "includeIf.$includeIfPath.path" $configFile
        }

        Write-Host "Git host configuration for $ConfigType set successfully" -ForegroundColor Green
        Write-Host "Configuration file: $configFile" -ForegroundColor Yellow
        Write-Host "To use this configuration, initialize git repositories within: $Directory" -ForegroundColor Yellow
    }
    catch {
        Write-Error "Failed to set Git host configuration: $($_.Exception.Message)"
        Add-ErrorLog -ErrorRecord $_ -Area 'GitHostConfig'
    }
}

function Switch-GitConfig {
    <#
    .SYNOPSIS
        Switches between Git configurations.

    .DESCRIPTION
        This function switches the Git configuration for a repository between
        different predefined or custom configurations.

    .PARAMETER ConfigType
        The configuration type to switch to.

    .PARAMETER Directory
        The repository directory to apply the configuration to.
        Defaults to current directory.

    .EXAMPLE
        Switch-GitConfig -ConfigType personal
        Switches current repository to personal configuration.

    .EXAMPLE
        Switch-GitConfig -ConfigType hackathons -Directory "D:\Hackathons\Project1"
        Switches specified repository to hackathon configuration.

    .NOTES
        The function creates a backup of the current configuration before switching.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ConfigType,

        [Parameter()]
        [string]$Directory = (Get-Location).Path
    )

    try {
        # Verify we're in a git repository
        if (-not (Test-Path (Join-Path $Directory ".git"))) {
            throw "Not a git repository: $Directory"
        }

        # Get available configurations
        $configs = git config --global --get-regexp "includeIf\.gitdir:.*\.path"
        if (-not $configs) {
            throw "No host-specific configurations found"
        }

        # Find matching configuration
        $configFile = git config --global --get "includeIf.gitdir:$($Directory.Replace('\', '/'))/.path"
        if (-not $configFile) {
            throw "No configuration found for directory: $Directory"
        }

        # Backup current configuration
        $backupFile = Join-Path $Directory ".git/config.backup"
        Copy-Item (Join-Path $Directory ".git/config") $backupFile

        try {
            # Apply new configuration
            Set-GitHostConfig -ConfigType $ConfigType -Directory $Directory
            Write-Host "Successfully switched to $ConfigType configuration" -ForegroundColor Green

            # Show current configuration
            Write-Host "`nCurrent Git Configuration:" -ForegroundColor Cyan
            git config --list --show-origin
        }
        catch {
            # Restore backup on failure
            Copy-Item $backupFile (Join-Path $Directory ".git/config")
            throw
        }
        finally {
            # Cleanup
            Remove-Item $backupFile -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Error "Failed to switch Git configuration: $($_.Exception.Message)"
        Add-ErrorLog -ErrorRecord $_ -Area 'GitConfigSwitch'
    }
}

# Export functions
Export-ModuleMember -Function @(
    'Initialize-GitSystem'
    'Set-GitMergeTools'
    'Set-GitHostConfig'
    'Switch-GitConfig'
    'Test-GitConfiguration'
    'Initialize-GitAliases'
    'Add-GitHostConfig'
)
