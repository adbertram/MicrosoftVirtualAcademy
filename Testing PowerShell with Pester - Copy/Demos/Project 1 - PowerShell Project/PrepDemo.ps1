$artifactsFolder = 'C:\Dropbox\GitRepos\MicrosoftVirtualAcademy\Testing PowerShell With Pester\Demos\Project 1 - PowerShell Project\Artifacts'
$employeesCsvPath = "$artifactsFolder\Employees.csv"

$vm = Get-AzureRmVm -Name 'LABDC' -ResourceGroupName 'Group'

$adminPwd = ConvertTo-SecureString 'Adam Bertram.' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPwd)

$icmParams = @{
	ComputerName = (Get-AzureRmPublicIpAddress -ResourceGroupName 'Group' -Name "LABDC-ip").IpAddress
	Credential = $cred
}

$csvEmployees = Import-Csv -Path $employeesCsvPath

foreach ($emp in $csvEmployees) {
    $firstInitial = $emp.FirstName.SubString(0,1)
    $userName = '{0}{1}' -f $firstInitial,$emp.LastName
			
    Invoke-Command @icmParams -ScriptBlock { Get-AdUser -Filter "samAccountName -eq '$using:userName'" | Remove-AdUser -Confirm:$false }
}