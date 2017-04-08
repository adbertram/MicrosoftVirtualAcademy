## Dot source the script
. "$PSScriptRoot\DoStuff.ps1"

describe 'Get-Thing' {
    
	it 'should return "I got the thing"' {

		Get-Thing | should be 'I got the thing'

	}

}