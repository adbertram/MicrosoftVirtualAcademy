function Do-Thing {
	param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)
	
	Get-AdUser -Filter * -Credential $Credential
}


describe 'NewMockObject demo' {
	
	## Create a fake credential so we can pass it to the function for testing
	$testCred = New-MockObject -Type 'System.Management.Automation.PSCredential'

	## No built-in way to mock a .NET method. We must use PowerShell extended type system to replace it instead.
	$addMemberParams = @{
		MemberType = 'ScriptMethod'
		Name = 'GetNetworkCredential'
		Value = { @{'Password' = 'Foo'} }
		Force = $true
	}
	$testCred | Add-Member @addMemberParams

	mock 'Get-AdUser'

	it 'uses the correct credential for the Get-AdUser call' {

		$null = Do-Thing -Credential $testCred

		$assMParams = @{
			CommandName = 'Get-AdUser'
			Times = 1
			Exactly = $true
			Scope = 'It'
			ParameterFilter = {$Credential.GetNetworkCredential().Password -eq 'foo' }
		}
		Assert-MockCalled @assMParams
	}
}