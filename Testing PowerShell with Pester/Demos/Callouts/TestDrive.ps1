## TestDrive does not exist outside of a describe block
Test-Path TestDrive:\

describe 'TestDrive Demo' {

	BeforeAll {
		Add-Content -Path TestDrive:\testfile.txt -Value 'testfile'
	}

	AfterAll {
		Write-Host (Get-Content -Path TestDrive:\testfile.txt)
	}
	
	it 'TestDrive exists' {
		'TestDrive:\' | should exist
	}

	it 'the file we created in the TestDrive exists' {
		'TestDrive:\testfile.txt' | should exist
	}
}