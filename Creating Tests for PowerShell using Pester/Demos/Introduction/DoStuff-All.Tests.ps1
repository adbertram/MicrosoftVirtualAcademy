## Dot source the script
. "$PSScriptRoot\DoStuff.ps1"

describe 'Get-Thing' {

    $result = Get-Thing

    it 'should return "I got the thing"' {
        $result | should be 'I got the thing'
    }
}

describe 'Do-Thing' {
    
    $result = Do-Thing

    it 'should return "I did the thing"' {
        ## Notice no should assertion here. Whoops! There's no test going on here.
    }
}

describe 'Set-Thing' {

    $result = Set-Thing

    it 'should return "I set the thing"' {
        ## Notice no should assertion here. Whoops! There's no test going on here.
    }
}