# Feature Menu Module
using namespace System.Management.Automation.Host

function Show-FeatureMenu {
    [CmdletBinding()]
    param(
        [hashtable]$LoadedFeatures = @{},
        [string]$CurrentMode
    )
    
    $title = @"
    ╔═══════════════════════════════════════╗
    ║        PSProfile Feature Menu         ║
    ╚═══════════════════════════════════════╝
"@
    
    function Get-FeatureStatus {
        param([string]$Feature)
        if ($LoadedFeatures[$Feature]) {
            return "[Loaded]" | Write-Host -ForegroundColor Green -NoNewline
        }
        return "[Available]" | Write-Host -ForegroundColor Yellow -NoNewline
    }
    
    do {
        Clear-Host
        Write-Host $title -ForegroundColor Cyan
        Write-Host "`nCurrent Mode: " -NoNewline
        Write-Host $CurrentMode -ForegroundColor Yellow
        Write-Host "Select a feature to load or manage:`n"
        
        # Core Features
        Write-Host "Core Features:" -ForegroundColor Blue
        Write-Host "1. Configuration  " -NoNewline; Get-FeatureStatus -Feature "Core\Configuration"
        Write-Host "2. Logging       " -NoNewline; Get-FeatureStatus -Feature "Core\Logging"
        Write-Host "3. Initialize    " -NoNewline; Get-FeatureStatus -Feature "Core\Initialize"
        
        # Development Features
        Write-Host "`nDevelopment Features:" -ForegroundColor Blue
        Write-Host "4. Git           " -NoNewline; Get-FeatureStatus -Feature "Features\Git"
        Write-Host "5. SSH           " -NoNewline; Get-FeatureStatus -Feature "Features\SSH"
        Write-Host "6. VirtualEnv    " -NoNewline; Get-FeatureStatus -Feature "Features\VirtualEnv"
        
        # UI Features
        Write-Host "`nUI Features:" -ForegroundColor Blue
        Write-Host "7. Prompt        " -NoNewline; Get-FeatureStatus -Feature "UI\Prompt"
        Write-Host "8. Theme         " -NoNewline; Get-FeatureStatus -Feature "UI\Theme"
        
        # Options
        Write-Host "`nOptions:" -ForegroundColor Blue
        Write-Host "9.  Change Loading Mode"
        Write-Host "10. View Status"
        Write-Host "11. Back to PowerShell"
        
        $choice = Read-Host "`nEnter selection (1-11)"
        
        switch ($choice) {
            "1" { Initialize-CoreConfiguration }
            "2" { Initialize-CoreLogging }
            "3" { Initialize-CoreSystem }
            "4" { Initialize-GitFeatures }
            "5" { Initialize-SSHFeatures }
            "6" { Initialize-VirtualEnvFeatures }
            "7" { Initialize-PromptFeatures }
            "8" { Initialize-ThemeFeatures }
            "9" { 
                $newMode = Show-LoadingMenu
                if ($newMode) {
                    Enable-PSProfile -Mode $newMode
                    $CurrentMode = $newMode
                }
            }
            "10" {
                Show-ProfileStatus -LoadedFeatures $LoadedFeatures -CurrentMode $CurrentMode
                Read-Host "Press Enter to continue"
            }
            "11" { return }
            default { 
                Write-Host "Invalid selection. Press Enter to continue..." -ForegroundColor Red
                Read-Host
            }
        }
    } while ($true)
}

function Show-ProfileStatus {
    param(
        [hashtable]$LoadedFeatures,
        [string]$CurrentMode
    )
    
    Clear-Host
    Write-Host "PSProfile Status" -ForegroundColor Cyan
    Write-Host "===============" -ForegroundColor Cyan
    
    Write-Host "`nLoading Mode: " -NoNewline
    Write-Host $CurrentMode -ForegroundColor Yellow
    
    Write-Host "`nLoaded Features:"
    $LoadedFeatures.GetEnumerator() | Sort-Object Key | ForEach-Object {
        Write-Host ("  • {0}" -f $_.Key) -ForegroundColor Green
    }
    
    Write-Host "`nSystem Information:"
    Write-Host "  • PowerShell Version: $($PSVersionTable.PSVersion)"
    Write-Host "  • OS: $([System.Environment]::OSVersion.VersionString)"
    Write-Host "  • User: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)"
    
    Write-Host "`nPerformance:"
    $loadTime = if ($script:PSProfileState.LoadTime) {
        "{0:N2} seconds" -f $script:PSProfileState.LoadTime.TotalSeconds
    } else {
        "Not measured"
    }
    Write-Host "  • Load Time: $loadTime"
    
    if ($script:PSProfileState.ErrorLog -and (Test-Path $script:PSProfileState.ErrorLog)) {
        Write-Host "`nRecent Errors:"
        Get-Content $script:PSProfileState.ErrorLog -Tail 3 | ForEach-Object {
            Write-Host "  • $_" -ForegroundColor Red
        }
    }
}
