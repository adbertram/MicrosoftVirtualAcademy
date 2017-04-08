describe 'Failing tests' {
	it 'fails' {
		$true | should be $false
	}

	it 'fails again' {
		$false | should be $true
	}
}