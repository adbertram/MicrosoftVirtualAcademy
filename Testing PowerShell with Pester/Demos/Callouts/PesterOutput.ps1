Invoke-Pester -Path "$demoPath\Introduction\Test-Foo.Tests.ps1"

## NUnit
Invoke-Pester "$demoPath\Introduction\Test-Foo.Tests.ps1" -OutputFormat NUnitXml -OutputFile "$demoPath\Test-Foo.TestResults.ps1" -Show None
Get-Content -Path "$demoPath\Test-Foo.TestResults.ps1"

## Exit codes --must be done in the PowerShell console
powershell.exe -NonInteractive -NoProfile -Command { Invoke-Pester -Path "$demoPath\Introduction\FailingTest.Test.ps1" -EnableExit }
$LASTEXITCODE