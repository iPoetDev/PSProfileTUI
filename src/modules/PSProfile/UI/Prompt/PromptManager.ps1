using namespace System.Management.Automation
using namespace System.Collections.Generic

# PSProfile Prompt Manager
# Manages prompt system selection and initialization

class PromptManager {
    [bool] $UseStarship
    [bool] $StarshipAvailable
    hidden [object] $CurrentPrompt
    
    PromptManager() {
        $this.Initialize()
    }

    [void] Initialize() {
        # Check Starship availability
        $this.StarshipAvailable = Test-StarshipAvailable
        $this.UseStarship = $this.StarshipAvailable
    }

    [bool] InitializePrompt() {
        if ($this.UseStarship -and $this.StarshipAvailable) {
            $success = Initialize-Starship
            if ($success) {
                Write-Verbose "Starship prompt initialized"
                return $true
            }
            Write-Warning "Failed to initialize Starship, falling back to PSProfile prompt"
        }

        $success = Initialize-FallbackPrompt
        if ($success) {
            Write-Verbose "Fallback prompt initialized"
            return $true
        }
        
        Write-Error "Failed to initialize any prompt system"
        return $false
    }

    [void] SwitchPrompt([bool]$useStarship) {
        $this.UseStarship = $useStarship -and $this.StarshipAvailable
        $this.InitializePrompt()
    }

    [hashtable] GetCurrentConfig() {
        if ($this.UseStarship -and $this.StarshipAvailable) {
            return Get-StarshipConfig
        }
        return Get-FallbackConfiguration
    }
}

# Module-level instance
$Script:PromptManagerInstance = [PromptManager]::new()

# Public functions
function Initialize-PSProfilePrompt {
    <#
    .SYNOPSIS
    Initializes the PSProfile prompt system
    
    .DESCRIPTION
    Sets up either Starship or fallback prompt based on availability and configuration
    #>
    $Script:PromptManagerInstance.InitializePrompt()
}

function Switch-PromptSystem {
    <#
    .SYNOPSIS
    Switches between Starship and PSProfile prompts
    
    .PARAMETER UseStarship
    If true, tries to use Starship; otherwise uses PSProfile prompt
    #>
    param(
        [Parameter(Mandatory)]
        [bool]$UseStarship
    )
    
    $Script:PromptManagerInstance.SwitchPrompt($UseStarship)
}

function Get-PromptConfiguration {
    <#
    .SYNOPSIS
    Gets the current prompt configuration
    #>
    $Script:PromptManagerInstance.GetCurrentConfig()
}

function Test-PromptSystem {
    <#
    .SYNOPSIS
    Tests the prompt system status
    #>
    return @{
        StarshipAvailable = $Script:PromptManagerInstance.StarshipAvailable
        UsingStarship = $Script:PromptManagerInstance.UseStarship
    }
}

# Export functions
Export-ModuleMember -Function @(
    'Initialize-PSProfilePrompt',
    'Switch-PromptSystem',
    'Get-PromptConfiguration',
    'Test-PromptSystem'
)
