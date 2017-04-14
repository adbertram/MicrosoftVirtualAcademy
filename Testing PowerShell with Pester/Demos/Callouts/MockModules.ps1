$demoPath = 'C:\Dropbox\GitRepos\MIcrosoftVIrtualAcademy\Testing PowerShell with Pester\Demos'

## Ensure no functions were just copied/pasted into session
Remove-Item Function:\Start-ClusterTest,Function:\Restart-Cluster,Function:\Test-ClusterProblem -ErrorAction Ignore

## Import the ClusterTest module into the session
Import-Module "$demoPath\Introduction\Project 1 - PowerShell Project\ClusterTest.psd1"

## Notice only a single function is exported
Get-Command -Module ClusterTest

## One test from the Start-ClusterTest describe block above.
## Not all of the functions that are referenced inside of Start-ClusterTest are exported.

## FAIL!
describe 'Start-ClusterTest' {

	## Create mocks to simply let the function execute and essentially do nothing
	mock 'Write-Host'

	mock 'Test-ClusterProblem' {
		$true
	}

	mock 'Restart-Cluster' ## Null

	it 'tests the correct cluster' {

		$assMParams = @{
			CommandName = 'Test-ClusterProblem'
			Times = 1
			Exactly = $true
			ParameterFilter = {
				$ClusterName -eq 'DOESNOTMATTER'
			}
		}
		Assert-MockCalled @assMParams

	}
}

## Mocks must be able to access functions to work. Use InModuleScope

InModuleScope 'ClusterTest' {
	describe 'Start-ClusterTest' {

		## Create mocks to simply let the function execute and essentially do nothing
		mock 'Write-Host'

		mock 'Test-ClusterProblem' {
			$true
		}

		mock 'Restart-Cluster'

		$result = Start-ClusterTest -ClusterName 'DOESNOTMATTER'

		it 'tests the correct cluster' {

			$assMParams = @{
				CommandName = 'Test-ClusterProblem'
				Times = 1
				Exactly = $true
				ParameterFilter = {
					$ClusterName -eq 'DOESNOTMATTER'
				}
			}
			Assert-MockCalled @assMParams

		}
	}
}