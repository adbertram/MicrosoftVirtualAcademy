$artifactsFolder = 'C:\Dropbox\GitRepos\MicrosoftVirtualAcademy\Testing PowerShell With Pester\Demos\Project 1 - PowerShell Project\Artifacts'
$employeesCsvPath = "$artifactsFolder\Employees.csv"

$csvEmployees = Import-Csv -Path $employeesCsvPath

foreach ($emp in $csvEmployees) {
    $firstInitial = $emp.FirstName.SubString(0,1)
    $userName = '{0}{1}' -f $firstInitial,$emp.LastName
			
    Get-AdUser -Filter "samAccountName -eq '$using:userName'" | Remove-AdUser -Confirm:$false
}