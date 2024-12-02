# Loading Menu Module
using namespace System.Management.Automation.Host

function Show-LoadingMenu {
    [CmdletBinding()]
    param()
    
    $title = @"
    ╔═══════════════════════════════════════╗
    ║        PSProfile Loading Menu         ║
    ╚═══════════════════════════════════════╝
"@
    
    $choices = @(
        [ChoiceDescription]::new("&Blank", "Basic PowerShell environment with no additional features.")
        [ChoiceDescription]::new("&Minimal", "Essential features with lazy loading (recommended).")
        [ChoiceDescription]::new("&Full", "All features enabled with lazy loading.")
        [ChoiceDescription]::new("&Quit", "Exit PowerShell.")
    )
    
    Clear-Host
    Write-Host $title -ForegroundColor Cyan
    Write-Host "`nSelect Profile Loading Mode:`n" -ForegroundColor Yellow
    
    Write-Host "1. Blank" -ForegroundColor Gray
    Write-Host "   • Basic PowerShell environment" -ForegroundColor DarkGray
    Write-Host "   • No additional features" -ForegroundColor DarkGray
    Write-Host "   • Fastest startup" -ForegroundColor DarkGray
    
    Write-Host "`n2. Minimal (Recommended)" -ForegroundColor Green
    Write-Host "   • Core configuration" -ForegroundColor DarkGray
    Write-Host "   • Essential features" -ForegroundColor DarkGray
    Write-Host "   • Lazy loading" -ForegroundColor DarkGray
    
    Write-Host "`n3. Full" -ForegroundColor Blue
    Write-Host "   • All features enabled" -ForegroundColor DarkGray
    Write-Host "   • Complete environment" -ForegroundColor DarkGray
    Write-Host "   • Lazy loading" -ForegroundColor DarkGray
    
    Write-Host "`n4. Quit" -ForegroundColor Red
    Write-Host "   • Exit PowerShell" -ForegroundColor DarkGray
    
    $choice = $host.UI.PromptForChoice($null, "`nSelect loading mode", $choices, 1)
    
    switch ($choice) {
        0 { return "Blank" }
        1 { return "Minimal" }
        2 { return "Full" }
        3 { exit }
    }
}
