$artifactsFolder = 'C:\Dropbox\GitRepos\Session-Content\Live Talks\Pester MVA\Demos\Project 1 - PowerShell Project\Artifacts'
$employeesCsvPath = "$artifactsFolder\Employees.csv"

$csvEmployees = Import-Csv -Path $employeesCsvPath

foreach ($emp in $csvEmployees) {
    $firstInitial = $emp.FirstName.SubString(0,1)
    $userName = '{0}{1}' -f $firstInitial,$emp.LastName
			
    Get-AdUser -Server DC -Filter "samAccountName -eq '$userName'" | Remove-AdUser -Server DC -Confirm:$false
}
