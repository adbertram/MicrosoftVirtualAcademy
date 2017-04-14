$artifactsFolder = 'C:\Dropbox\GitRepos\MicrosoftVirtualAcademy\Testing PowerShell With Pester\Demos\Project 1 - PowerShell Project\Artifacts'
$employeesCsvPath = "$artifactsFolder\Employees.csv"

$vm = Get-AzureRmVm -Name 'LABDC' -ResourceGroupName 'Group'

$adminPwd = ConvertTo-SecureString 'Adam Bertram.' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPwd)

$icmParams = @{
	ComputerName = (Get-AzureRmPublicIpAddress -ResourceGroupName 'Group' -Name "LABDC-ip").IpAddress
	Credential = $cred
}


describe 'CSV file' {

	it 'the CSV file exists in the expected location' {
		Test-Path -Path $employeesCsvPath | should be $true
	}

	it 'the CSV file contains all the expected rows' {
		$csvContent = '"FirstName","LastName","Department","Title"
"Katie","Green","Accounting","Manager of Accounting"
"Joe","Blow", "Information Systems","System Administrator"
"Joe","Schmoe", "Information Systems", "Software Developer"
"Barack","Obama", "Executive Office", "CEO"
"Donald","Trump", "Janitorial Services", "Custodian"'

		$csvContent -eq (Get-Content -Path $employeesCsvPath -Raw) | should be $true
	}
}

describe 'Active Directory' {

	$csvEmployees = Import-Csv -Path $employeesCsvPath

	it 'the expected OUs exist' {

		$expectedOus = $csvEmployees | foreach { "OU=$($_.Department),DC=mylab,DC=local" } | Select -Unique
		
		$actualOus = Invoke-Command @icmParams -ScriptBlock { Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName }
		@($actualOus | where { $_ -in $expectedOus }).Count | should be @($expectedOus).Count

	}

	it 'the expected groups exist' {

		$expectedGroups = $csvEmployees | foreach { $_.Department } | Select -Unique
		
		$actualGroups = Invoke-Command @icmParams -ScriptBlock { Get-ADGroup -Filter * | Select-Object -ExpandProperty Name }
		@($actualGroups | where { $_ -in $expectedGroups }).Count | should be @($expectedGroups).Count

	}

	it 'users in the CSV file do not exist in AD' {
		
		foreach ($user in (Import-Csv -Path $employeesCsvPath)) {
			
			$firstInitial = $user.FirstName.SubString(0,1)
    		$userName = '{0}{1}' -f $firstInitial,$user.LastName
			
			Invoke-Command @icmParams -ScriptBlock { Get-AdUser -Filter "samAccountName -eq '$using:userName'" } | should benullorEmpty
		}	
	}
}