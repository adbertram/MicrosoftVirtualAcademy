#########################
## Mocking basics
#########################

    function Start-ClusterTest {
        param($ClusterName)

        Write-Host 'Doing the thing...'
        Write-Output "I did the thing against $ClusterName!"
    }

    ## Test with no mocking
    describe 'Start-ClusterTest' { 

        $result = Start-ClusterTest -Action 'Foo'
        
        it 'returns a string with $Action inside' {
            ## I know the input and the output together. It's Foo
            $result | should be 'I did the thing Foo!' 
        }
        
    }

    ## Test with mocking. Test fails because the command has been "overwritten"
    describe 'Start-ClusterTest' { 

        mock -CommandName 'Write-Output' -MockWith {
            'No you did not'
        }

        $result = Start-ClusterTest -Action 'Foo'
        
        it 'does the thing' {
           $result | should be 'I did the thing Foo!' 
        }
    }

#########################
## Mocking and scopes
#########################

    function Start-ClusterTest {
        param($ClusterName)

        Write-Host 'Doing the thing...'
        Write-Output "I did the thing against $ClusterName!"
    }

    describe 'Start-ClusterTest' { 

        ## Changing the output of Write-Output to 'describemock'
        mock -CommandName 'Write-Output' -MockWith {
            'describemock'
        }

        $result = Start-ClusterTest -Action 'Foo'

        ## This passes because the mock above is in effect
        it 'does the thing in the describe block' {
            $result | should be 'describemock'
        }

        context 'MockScope1' {

            ## Override the previous mock. This only applies within this context block
            mock -CommandName 'Write-Output' -MockWith {
                'mockscope1'
            }

            $result = Start-ClusterTest -Action 'Foo'

            ## This will succeed because because the mock right above applies instead.
            it 'does the thing in the mock scope 1 context' {
                $result | should be 'mockscope1'
            }

            ## This will fail because we're not in that describe mock scope anymore
            it 'does the thing in the mock scope 1 context' {
                $result | should be 'describemock'
            }

        }

        context 'MockScope2' {

            mock -CommandName 'Write-Output' -MockWith {
                'mockscope2'
            }

            $result = Start-ClusterTest -Action 'Foo'

            ## Which will pass?
            it 'does the thing in the mock scope 2 context' {
                $result | should be 'describemock'
            }

            it 'does the thing in the mock scope 2 context' {
                $result | should be 'mockscope1'
            }

            it 'does the thing in the mock scope 2 context' {
                $result | should be 'mockscope2'
            }

        }

        it 'does the thing in the describe block' {
            $result | should be 'describemock' 
        }
    }

#########################
## Mocking 101-301
#########################

    ## Helper function to Start-ClusterTest
    function Restart-Cluster {
        param($ClusterName)

        ## Do whatever it takes to restart the cluster here
    }
    
    ## Helper function to Start-ClusterTest
    function Test-ClusterProblem {
        param($ClusterName)

        ## Check some stuff here. Return either $true if all checks passed
        ## or false if they did not. For now, we'll just return $true.
        $true
    }

    function Start-ClusterTest {
        param($ClusterName)

        Write-Host 'Starting cluster test...'
        $result = Test-ClusterProblem -ClusterName $ClusterName ## Run another function
        if ($result) {
            $true
        } else {
            Restart-Cluster -ClusterName $ClusterName
        }
    }

    ## Need to run this without actually doing anything. This is a UNIT test.
    ## We need to ensure just to test this code we don't have to have an entire cluster setup.

    ## Test v1. We can't actually run the tests without screwing with our cluster.
    describe 'Start-ClusterTest' {

        $result = Start-ClusterTest -ClusterName 'DOESNOTMATTER'

        it 'tests the correct cluster' {
            ## Unit tests just ensure code paths are followed. Without mocks there's no way to determine what parameters
            ## are passed to Test-ClusterProblem
        }

        it 'when no problems are detected, it should return $true' {
            ## This isn't possible. Test-ClusterProblem is just going to run as usual and we have no way to control what Test-ClusterProblem
            ## actually returns.

            ## $result | should be $true??
        }

        it 'when a problem is detected, it should restart the cluster' {

        }

        it 'does not murder poor, innocent, little puppies' {

            ## How are we supposed to know that Write-Host was used? We can't!
        }

    }

    ## Test v2
    describe 'Start-ClusterTest' {

        ## Create mocks to simply let the function execute and essentially do nothing
        mock 'Write-Host'

        mock 'Test-ClusterProblem' {
            $true
        }

        mock 'Restart-Cluster' ## Null

        $result = Start-ClusterTest -ClusterName 'DOESNOTMATTER'

        ## These it blocks do not depend on a specific scenario and are not in a context block.
        it 'does not murder poor, innocent, little puppies' {

            $assMParams = @{
                CommandName = 'Write-Host'
                Times = 0
                Exactly = $true
            }
            Assert-MockCalled @assMParams

        }

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

        context 'when a problem is detected with a cluster' {
            
            ## This mock overrides Test-ClusterProblem only in this context block. We are ONLY testing the scenario
            ## when there's a problem with the cluster.

            mock 'Test-ClusterProblem' {
                $false
            }

            $result = Start-ClusterTest -ClusterName 'DOESNOTMATTER'

            it 'attempts to restart the cluster' {
                
                $assMParams = @{
                    CommandName = 'Restart-Cluster'
                    Times = 1
                    Exactly = $true
                    ParameterFilter = {$ClusterName -eq 'DOESNOTMATTER' }
                }
                Assert-MockCalled @assMParams
            }
        }

        context 'when no problems are detected on the cluster' {
            
            ## Override again to simulate the scenario
             mock 'Test-ClusterProblem' {
                $true
            }  

            $result = Start-ClusterTest -ClusterName 'DOESNOTMATTER'

            it 'should return $true' {
                $result | should be $true
            }
        }
    }

#########################
## Mocking with modules
#########################

    ## Ensure no functions were just copied/pasted into session
    Remove-Item Function:\Start-ClusterTest,Function:\Restart-Cluster,Function:\Test-ClusterProblem

    ## Import the ClusterTest module into the session
    Import-Module "$demoPath\Introduction\ClusterTest\ClusterTest.psd1"

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

#########################
## New-MockObject
#########################

    ## Function to test
    function Remove-WindowsService {
        param(
            [Parameter()]
            [ValidateNotNullOrEmpty()]
            [System.ServiceProcess.ServiceController]$Service ## A strongly typed parameter
        )

        ## Use the $Service paramter in here in some way
    }

    ## This isn't testable without actually getting a real service.
    describe 'Remove-WindowsService' {

        ## This is a no-no. Do not depend on the environment to run unit tests.
        $realService = Get-Service -Name 'wuauserv'

        $result = Remove-WindowsService -Service $realService

        it 'does something it is supposed to' {
            $true | should be $true
        }
    }

    ## Figure out the object type you need and create a "fake" one that has that type just to make the function execute
    ## System.ServiceProcess.ServiceController

    $mockService = New-MockObject -Type 'System.ServiceProcess.ServiceController'

    ## "Blank" object
    $mockService

    ## ..but is the right type. Exactly what we need to pass to our function
    $mockService | Get-Member

    ## This isn't testable without actually getting a real service.
    describe 'Remove-WindowsService' {

        ## This is a no-no. Do not depend on the environment to run unit tests.
        $mockService = New-MockObject -Type 'System.ServiceProcess.ServiceController'

        $result = Remove-WindowsService -Service $mockService

        it 'does something it is supposed to' {
            $true | should be $true
        }
    }
