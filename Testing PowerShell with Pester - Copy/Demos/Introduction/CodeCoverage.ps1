$demoPath = 'C:\Dropbox\GitRepos\MIcrosoftVIrtualAcademy\Testing PowerShell with Pester\Demos'

## View the script and tests
psedit "$demoPath\Introduction\DoStuff.ps1"

## Just a small test only testing one of the functions
psedit "$demoPath\Introduction\DoStuff.Tests.ps1"

Invoke-Pester -Path "$demoPath\Introduction\DoStuff.Tests.ps1"

## Notice 33% coverage. Looks like we didn't execute Write-Output in two of the functions during testing.]
Invoke-Pester -Path "$demoPath\Introduction\DoStuff.Tests.ps1" -CodeCoverage "$demoPath\Introduction\DoStuff.ps1"

psedit "$demoPath\Introduction\DoStuff-All.Tests.ps1"

## 100% test coverage but everything was NOT tested.
Invoke-Pester -Path "$demoPath\Introduction\DoStuff-All.Tests.ps1" -CodeCoverage "$demoPath\Introduction\DoStuff.ps1"

## Scoping code coverage to a function --Previously was only 33% coverage.
Invoke-Pester "$demoPath\Introduction\DoStuff.Tests.ps1" -CodeCoverage @{ Path = "$demoPath\Introduction\DoStuff.ps1"; Function = 'Get-Thing' }
Invoke-Pester "$demoPath\Introduction\DoStuff.Tests.ps1" -CodeCoverage @{ Path = "$demoPath\Introduction\DoStuff.ps1"; Function = 'Set-Thing' }

## Scoping code coverage to a line
Invoke-Pester "$demoPath\Introduction\DoStuff.Tests.ps1" -CodeCoverage @{ Path = "$demoPath\Introduction\DoStuff.ps1"; StartLine = 5; EndLine = 7 }