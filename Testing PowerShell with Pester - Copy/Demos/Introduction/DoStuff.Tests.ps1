## Dot source the script
. "$PSScriptRoot\DoStuff.ps1"

describe 'Get-Thing' {

	$result = Get-Thing
    
	it 'should return "I got the thing"' {
		$result | should be 'I got the thing'
	}
}