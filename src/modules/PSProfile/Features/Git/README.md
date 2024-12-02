# Git Module for PSProfile

## Overview
The Git module provides enhanced Git functionality within PowerShell, offering advanced repository management, custom aliases, branch operations, and integrated workflow tools. It seamlessly integrates with standard Git commands while providing additional PowerShell-specific features.

## Features

### 1. Repository Management
```powershell
# Initialize repository
Initialize-GitRepo -Path "." -Remote "origin" -URL "https://github.com/user/repo.git"

# Clone repository
New-GitClone -URL "https://github.com/user/repo.git" -Path "./projects"

# Get repository status
Get-GitStatus

# Sync repository
Sync-GitRepo -Remote "origin" -Branch "main"
```

### 2. Branch Operations
```powershell
# Create new branch
New-GitBranch -Name "feature/new-feature"

# Switch branches
Switch-GitBranch -Name "develop"

# Merge branches
Merge-GitBranch -Source "feature/new-feature" -Target "develop"

# Delete branch
Remove-GitBranch -Name "feature/old-feature"
```

### 3. Commit Management
```powershell
# Stage changes
Add-GitChanges -Path "." -Pattern "*.ps1"

# Create commit
New-GitCommit -Message "feat: add new feature"

# Amend commit
Edit-GitCommit -Amend -Message "fix: update message"

# View commit history
Get-GitHistory -Count 10
```

### 4. Remote Operations
```powershell
# Add remote
Add-GitRemote -Name "upstream" -URL "https://github.com/original/repo.git"

# Push changes
Push-GitChanges -Remote "origin" -Branch "main"

# Pull changes
Pull-GitChanges -Remote "origin" -Branch "main"

# Fetch updates
Update-GitRepo -Remote "all"
```

## Configuration

### Default Settings
```powershell
$GitConfig = @{
    DefaultBranch = "main"
    CommitTemplate = "conventional"
    AutoFetch = $true
    ShowStatus = $true
    PullStrategy = "rebase"
    Editor = "code --wait"
}
```

### Custom Configuration
```powershell
# Set configuration
Set-GitConfiguration -Config $GitConfig

# Get current configuration
Get-GitConfiguration

# Reset to defaults
Reset-GitConfiguration
```

## Requirements

### System Requirements
- Windows PowerShell 5.1 or PowerShell Core 7.x
- Git for Windows (2.30.0 or higher)
- Optional: Visual Studio Code

### Additional Tools
- GitHub CLI (optional)
- Git Credential Manager
- Git LFS (optional)

## Installation

### 1. Git Setup
```powershell
# Install Git (if needed)
winget install Git.Git

# Configure global settings
Set-GitGlobalConfig -UserName "Your Name" -Email "your@email.com"

# Setup credential manager
Initialize-GitCredentialManager
```

### 2. Module Configuration
```powershell
# Initialize module
Initialize-GitModule

# Configure defaults
Set-GitDefaults

# Test installation
Test-GitSetup
```

## Usage Examples

### Basic Workflow
```powershell
# Clone and setup
New-GitClone -URL "https://github.com/user/repo.git"
Set-Location ./repo

# Create feature branch
New-GitBranch -Name "feature/new-feature"

# Make changes and commit
Add-GitChanges -All
New-GitCommit -Message "feat: implement new feature"

# Push changes
Push-GitChanges -SetUpstream
```

### Advanced Operations
```powershell
# Interactive rebase
Start-GitRebase -Interactive -Count 3

# Cherry-pick commits
Copy-GitCommit -Hash "abc123"

# Create and verify tag
New-GitTag -Name "v1.0.0" -Message "Release v1.0.0"
Confirm-GitTag -Name "v1.0.0"

# Stash operations
Save-GitChanges -Message "WIP: feature work"
Get-GitStash
Restore-GitChanges
```

### Workflow Integration
```powershell
# Start feature
Start-GitFeature -Name "new-feature"

# Create pull request
New-GitPullRequest -Title "Feature: Add new functionality"

# Finish feature
Complete-GitFeature -Name "new-feature"
```

## Troubleshooting

### Common Issues

1. **Authentication Problems**
   ```powershell
   # Test credentials
   Test-GitCredentials
   
   # Reset credential manager
   Reset-GitCredentialManager
   ```

2. **Merge Conflicts**
   ```powershell
   # Show conflicts
   Get-GitConflicts
   
   # Resolve using tool
   Resolve-GitConflict -Tool "vscode"
   ```

3. **Remote Issues**
   ```powershell
   # Test connection
   Test-GitRemote -Name "origin"
   
   # Fix remote URL
   Set-GitRemoteURL -Name "origin" -URL "new-url"
   ```

### Logging
```powershell
# Enable debug logging
Set-GitLogLevel -Level Debug

# View logs
Get-GitLogs

# Export logs
Export-GitLogs -Path "./logs"
```

## Best Practices

1. **Branch Management**
   - Use feature branches
   - Regular rebasing
   - Clean commit history
   - Protected main branch

2. **Commit Guidelines**
   - Conventional commits
   - Clear messages
   - Atomic commits
   - Signed commits

3. **Workflow**
   - Regular fetching
   - Pull with rebase
   - Clean working tree
   - Local backups

## Integration with PSProfile

### Prompt Integration
- Shows current branch
- Indicates dirty state
- Displays ahead/behind count
- Shows stash count

### Auto-Features
- Auto-fetch
- Branch cleanup
- Stale branch detection
- Credential caching

### Command Aliases
```powershell
g       # git status
ga      # git add
gc      # git commit
gp      # git push
gl      # git pull
gco     # git checkout
gb      # git branch
gm      # git merge
```

## Git Hooks
```powershell
# Available hooks
Get-GitHooks

# Add pre-commit hook
Add-GitHook -Type "pre-commit" -Script {
    # Lint PowerShell files
    Invoke-ScriptAnalyzer -Path .
}

# Add commit-msg hook
Add-GitHook -Type "commit-msg" -Script {
    # Validate commit message
    Test-CommitMessage -Path $args[0]
}
```

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support
- Report issues on GitHub
- Check documentation
- Contact maintainers

## License
Same as PSProfile module
