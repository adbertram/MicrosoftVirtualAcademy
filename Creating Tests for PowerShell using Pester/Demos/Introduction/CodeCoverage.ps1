$demoPath = 'C:\Dropbox\GitRepos\MIcrosoftVIrtualAcademy\Creating Tests for PowerShell using Pester\Demos'

function Do-Thing {
    Write-Output 'I did the thing'
}

function Get-Thing {
    Write-Output 'I got the thing'
}

function Set-Thing {
    Write-Output 'I set the thing'
}

# DoStuff-GetThing.Tests.ps1
#################

## Dot source the script
. "$PSScriptRoot\DoStuff.ps1"

describe 'Get-Thing' {
    it 'should return "I got the thing"' {
        Get-Thing | should be 'I got the thing'
    }
}
##################

Invoke-Pester -Path "$demoPath\DoStuff-GetThing.Tests.ps1" -CodeCoverage "$demothPath\DoStuff.ps1"


## DoStuff-All.Tests.ps1
##################

## Dot source the script
. "$PSScriptRoot\DoStuff.ps1"
describe 'Get-Thing' {
    it 'should return "I got the thing"' {
        Get-Thing | should be 'I got the thing'
    }
}

describe 'Do-Thing' {
    it 'should return "I did the thing"' {
        Do-Thing ## Notice no should assertion here. Whoops!
    }
}

describe 'Set-Thing' {
    it 'should return "I set the thing"' {
        Set-Thing ## Notice no should assertion here. Whoops!
    }
}
##################

Invoke-Pester "$demoPath\DoStuffAll.Tests.ps1" -CodeCoverage "$demoPath\DoStuff.ps1"

## Scoping code coverage to a function
Invoke-Pester "$demoPath\DoStuff-GetThing.Tests.ps1" -CodeCoverage @{ Path = "$demoPath\DoStuff.ps1"; Function = 'Get-Thing' }

## Scoping code coverage to a line
Invoke-Pester "$demoPath\DoStuff-GetThing.Tests.ps1" -CodeCoverage @{ Path = "$demoPath\DoStuff.ps1"; StartLine = 5; EndLine = 7 }