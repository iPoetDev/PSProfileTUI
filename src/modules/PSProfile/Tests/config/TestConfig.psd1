@{
    # Test Environment Configuration
    TestEnvironment = @{
        # Temporary test directories
        TempRoot = Join-Path $env:TEMP "PSProfile_Tests"
        Paths = @{
            Logs = "Logs"
            Config = "Config"
            Modules = "Modules"
            VirtualEnvs = "VirtualEnvs"
            SSH = ".ssh"
            Git = ".git"
        }
        
        # Cleanup settings
        Cleanup = @{
            EnableAutoCleanup = $true
            PreserveLogsOnFailure = $true
            MaxLogAge = 7 # days
        }
    }

    # Mock Data Configuration
    MockData = @{
        # Git configuration mock
        Git = @{
            Config = @{
                user = @{
                    name = "Test User"
                    email = "test@example.com"
                }
                core = @{
                    editor = "code"
                    autocrlf = "true"
                }
                merge = @{
                    tool = "vscode"
                }
                diff = @{
                    tool = "vscode"
                }
            }
            Status = @{
                Branch = "main"
                HasChanges = $true
                Ahead = 2
                Behind = 1
                Added = @("file1.txt")
                Modified = @("file2.txt")
                Deleted = @()
            }
        }

        # SSH mock data
        SSH = @{
            Keys = @(
                @{
                    Name = "github_key"
                    Type = "ed25519"
                    Bits = 4096
                    Comment = "test@github"
                }
                @{
                    Name = "gitlab_key"
                    Type = "rsa"
                    Bits = 4096
                    Comment = "test@gitlab"
                }
            )
            Config = @"
Host github.com
    IdentityFile ~/.ssh/github_key
    User git

Host gitlab.com
    IdentityFile ~/.ssh/gitlab_key
    User git
"@
        }

        # Python virtual environment mock
        VirtualEnv = @{
            Environments = @(
                @{
                    Name = "project1"
                    Python = "3.9.0"
                    Packages = @(
                        "requests==2.26.0"
                        "pytest==6.2.5"
                    )
                }
                @{
                    Name = "project2"
                    Python = "3.8.0"
                    Packages = @(
                        "django==3.2.0"
                        "pillow==8.3.1"
                    )
                }
            )
        }

        # WSL mock data
        WSL = @{
            Distributions = @(
                @{
                    Name = "Ubuntu"
                    Default = $true
                    State = "Running"
                    Version = 2
                }
                @{
                    Name = "Debian"
                    Default = $false
                    State = "Stopped"
                    Version = 2
                }
            )
            Paths = @{
                Windows = @(
                    "C:\Users\Test\Documents"
                    "D:\Projects"
                )
                Linux = @(
                    "/mnt/c/Users/Test/Documents"
                    "/mnt/d/Projects"
                )
            }
        }
    }

    # Test Parameters
    TestParameters = @{
        # Timeouts
        Timeouts = @{
            Default = 30 # seconds
            LongRunning = 120 # seconds
            Network = 60 # seconds
        }

        # Retry settings
        Retry = @{
            MaxAttempts = 3
            DelaySeconds = 5
        }

        # Test categories
        Categories = @{
            Unit = @{
                Enabled = $true
                Parallel = $true
            }
            Integration = @{
                Enabled = $true
                Parallel = $false
            }
            Performance = @{
                Enabled = $false
                Thresholds = @{
                    LoadTime = 2.0 # seconds
                    ResponseTime = 0.5 # seconds
                }
            }
        }

        # Code coverage settings
        CodeCoverage = @{
            Enabled = $true
            OutputFormat = "JaCoCo"
            MinimumPercent = 80
            ExcludeFiles = @(
                "*.Tests.ps1"
                "TestConfig.psd1"
            )
        }
    }

    # Reporting Configuration
    Reporting = @{
        Outputs = @("Console", "HTML", "NUnitXml")
        HTMLReport = @{
            Title = "PSProfile Test Results"
            Theme = "Dark"
            ShowEnvironmentData = $true
            IncludeVSCodeLink = $true
        }
        NUnitReport = @{
            OutputPath = "TestResults"
            IncludeStackTrace = $true
        }
        Logging = @{
            Level = "Information" # Debug, Information, Warning, Error
            IncludeTime = $true
            LogPath = "Logs/TestRun.log"
        }
    }
}
