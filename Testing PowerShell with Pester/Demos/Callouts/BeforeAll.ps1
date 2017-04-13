describe 'BeforeAfter Demo' {
	BeforeAll {
		Write-Host 'Hi, I am in the BeforeAll block'
		Add-Content -Path TestDrive:\foofile.txt -Value 'foo'
		Add-Content -Path TestDrive:\nofoofile.txt -Value 'not here'
	}

	AfterAll {
		Write-Host 'Hi, I am in the AfterAll block.'
	}

	BeforeEach {
		Write-Host 'Hi, I am in the BeforeEach block'
	}

	AfterEach {
		Write-Host 'Hi, I am in the AfterEach block'
	}

	it 'should be true' {
		$true | should be $true
	}

	it 'should be false' {
		$false | should be $false
	}
}