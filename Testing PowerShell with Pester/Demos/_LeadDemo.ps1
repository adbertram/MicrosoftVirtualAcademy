## Demo stuff
    return
    $demoPath = 'C:\Dropbox\GitRepos\MicrosoftVirtualAcademy\Testing PowerShell with Pester\Demos'

##############################################
## The Basics
##############################################

    Find-Module -Name Pester
    Install-Module -Name Pester -Force

    Get-Command -Module Pester

    describe 'MVA Tests' {
        it '$true should be $true' {
            $true | should be $true
        }
    }

    describe 'MVA Tests' {

        context 'Arithmetic' {

            it '1 plus 1 should be 2' {
                1 + 1 | should be 2
            }

            it '3 minus 2 should 1' {
                3 - 2 | should be 1
            }
        }

        context 'String matching' {

            it 'an i should not be in team - like assertion' {
                'team' | should not belike '*i*'
            }

            it 'an i should not be in team - match assertion' {
                'team' | should not match 'i'
            }
        }

        context 'AAA approach' {

            $stringToTest = 'team'

            it 'an i should not be in team - like assertion' {
                $stringToTest | should not belike '*i*'
            }

            it 'an i should not be in team - like assertion' {
                $stringToTest | should not belike '*i*'
            }

            it 'an i should not be in team - match assertion' {
                $stringToTest | should not match 'i'
            }
        }
    }
    ## This can just be copied and pasted into the console for ad-hoc execution or...

    ## Moved into a .Test.ps1 file and executed via Invoke-Pester
    Invoke-Pester -Path "$demoPath\Introduction\MVATests.Tests.ps1"

##############################################
## Simple TDD Example
##############################################
    <# Define what we want to do
        Create a function that parses a line of text from a file. We know what the function should return we just don't know
        how to do that yet. We'll build this function using TDD (test-driven development). This function will be called
        Test-Foo. For now, we'll just create a blank function to act as a placeholder.
    #>

    <# Define necessary potential outcomes
        If a text file contains the string 'foo', we need to return $true. If it does not, we need this function to return
        $false.
    #>

    ########################
    ## CALLOUT: TestDrive
    ########################
    psedit "$demoPath\Callouts\TestDrive.ps1"

    ########################
    ## CALLOUT: BeforeAll/AfterAll/BeforeEach/AfterEach
    ########################
    psedit "$demoPath\Callouts\BeforeAll.ps1"

    ## Ensure the function is available in the session
    function Test-Foo {
        param(
            $FilePath
        )
    }

    ## A describe block with the same name as the function itself (recommended)
    describe 'Test-Foo' {

        # Arrange
        BeforeAll {
            ## Since working with files, we'll use the builtin Pester feature TestDrive.
            ## Create a file that we know for sure has 'foo' in it
            Add-Content -Path TestDrive:\foofile.txt -Value 'foo'

            ## Create a file that we know for sure does not have 'foo' in it
            Add-Content -Path TestDrive:\nofoofile.txt -Value 'not here'
        }

        ## Act
            $fooutput = Test-Foo -FilePath TestDrive:\foofile.txt
            $nofooutput = Test-Foo -FilePath TestDrive:\nofoofile.txt

        ## The actual tests (it blocks) inside of the describe block. recommended to use a standard naming convention
        ## when X, it should Y. This is the "Assert" phase.

        ## Assert
            it 'when the file has "foo" in it, it should return $true' {

                ## Should "asserts" what the function should return
            
                $fooutput | should be $true
                $fooutput | should beoftype 'bool'
                @($fooutput).Count | should be 1

            }

            it 'when the file does not have "foo" in it, it should return $false' {

                ## Should "asserts" what the function should return
                $nofooutput | should be $false

            }
    }

    ## Run the tests --failed. Why?

    ## Let's now start adding in the code to make the function "real"

    function Test-Foo {
        param(
            $FilePath
        )

        if (Select-String -Path $FilePath -Pattern 'foo') {
            $true
        }
    }

    ## Run the tests. One test passes. Let's make the next one pass

    function Test-Foo {
        param(
            $FilePath
        )

        if (Select-String -Path $FilePath -Pattern 'foo') {
            $true
        } else {
            $false
        }
    }

    ## Now let's bring all of this into a Pester test script
    psedit "$demoPath\Introduction\Test-Foo.Tests.ps1"
    Invoke-Pester -Path "$demoPath\Introduction\Test-Foo.Tests.ps1"

##############################################
## Code Coverage
##############################################

    psedit "$demoPath\Introduction\CodeCoverage.ps1"

##############################################
## Mocking
##############################################

    psedit "$demoPath\Introduction\Mocking.ps1"

##############################################
## Project 1 - Writing Tests for  PowerShell Tools
##############################################

    ## Introduce the problem and the script we start with. This script works I suppose but it's impossible to write unit tests against.
    psedit "$demoPath\Project 1 - PowerShell Project\Sync-AdUser-needswork.ps1"

    ##############################################
    ## Step #1: Readying code for testing
    ##############################################
        <# 
            1. Discover each "thing" that the code is doing. This is a MUST!

            Our script is:

            - Getting the default user password for all new accounts
            - Finding all active employees (employees in CSV from HR)
            - Figuring out the username for an employee
            - Testing to see if the required AD account already exists
                - If so, skips it
                - If not:
                    - Figures out the OU path for the department the employee is in
                    - Ensures that OU exists
                        - If not: throws an exception
                        - If so, creates the AD account
                - Ensure the department group exists
                    - If not: throws an exception
                    - If so:
                        - Checks to see if the account is already a member
                        - If so, skips.
                        - If not, adds the account to the group.
            - Looks for any employee accounts in AD that aren't in the CSV file
                - If none found, script ends
                - If any found, disables them
        #>

        ## 2. Create functions for each specific task
        psedit "$demoPath\Project 1 - PowerShell Project\Module\AdUserSync.psm1"

        ## 3. Refactor script to use new functions
        psedit "$demoPath\Project 1 - PowerShell Project\Sync-AdUser.ps1"

    ##############################################
    ## Step #2: Building the tests
    ##############################################

        ## 1. Build a test 'framework' for all module functions (helpers)
        psedit "$demoPath\Project 1 - PowerShell Project\TestFramework.ps1"

        #############
        ## CALLOUT - NewMockobject
        #############
        psedit "$demoPath\Callouts\NewMockObject.ps1"

        ################
        ## CALLOUT: Testing Exceptions
        ###############
        psedit "$demoPath\Callouts\TestingExceptions.ps1"

        ## 2. Build tests for our "helper" functions in the module
        psedit "$demoPath\Project 1 - PowerShell Project\Module\AdUserSync.Tests.ps1"

        ## 3. Build tests for how these functions are invoked in the script
        psedit "$demoPath\Project 1 - PowerShell Project\Sync-AdUser.Tests.ps1"

    ##############################################
    ## Project Completed
    ##############################################

##############################################
## Project 2 - Writing Tests for the PowerShell Gallery
##############################################

    start 'https://msdn.microsoft.com/en-us/powershell/gallery/psgallery/psgallery_faqs'

    <#
        - Must have a module manifest
        - Must have certain keys in the manifest
        - Must have Pester tests (recommended)
        - Passes default PSScriptAnalyzer rules (recommended)
    #>

    ## My module I'd like to upload to the PowerShell Gallery
    psedit 'C:\Dropbox\GitRepos\PSWebDeploy\PSWebDeploy.psm1'

    describe 'PowerShell Gallery Tests' {

        $moduleFolder = 'C:\Dropbox\GitRepos\PSWebDeploy'
        $moduleManifestPath = "$moduleFolder\PSWebDeploy.psd1"
        $manifest = Import-PowerShellDataFile -Path $moduleManifestPath -ErrorAction Ignore

        it 'must have a module manifest with the same name as the module' {
            $moduleManifestPath | should exist
        }

        it 'must have the Description manifest key populated' {
            $manifest.Description | should not benullorempty
        }

        it 'must have the Author manifest key populated' {
            $manifest.Author | should not benullorempty
        }

        it 'must have either the LicenseUri or ProjectUri manifest key populated' {
            ($manifest.PrivateData.PSData.LicenseUri + $manifest.PrivateData.PSData.ProjectUri) | should not benullorempty
        }

        it 'must pass Test-ModuleManifest validation' {
            Test-ModuleManifest -Path $moduleManifestPath -ErrorAction SilentlyContinue | should be $true
        }

        it 'must have associated Pester tests' {
            "$moduleFolder\PSWebDeploy.Tests.ps1" | should exist
        }

        it 'must pass PSScriptAnalyzer rules' {
            Invoke-ScriptAnalyzer -Path "$moduleFolder\PSWebDeploy.psm1" -ExcludeRule 'PSUseDeclaredVarsMoreThanAssignments' | should benullorempty
        }
    }


##############################################
## Project 3 - Test Automation with DSC and Build Pipelines
##############################################

    <# Steps
        - Write DSC configuration
        - Check in DSC code to Github
        - AppVeyor build automatically kicks off with current code
        - DSC configuration is applied to an existing Azure VM
        - AppVeyor kicks off Pester tests to ensure DSC configuration did as expected
        - AppVeyor uploads results to nUnit capable view
        - We bask in the glory of passed tests (hopefully)
    #>

    ## The TestDomainCreator Project
    start 'https://github.com/adbertram/TestDomainCreator'

    ## AppVeyor
    start 'https://ci.appveyor.com/project/adbertram/testdomaincreator'

    ## Kick off the AppVeyor build --we'll come back to that.

    ## The DSC Configuration that AppVeyor will apply to our Azure VM
    psedit "C:\Dropbox\GitRepos\TestDomainCreator\NewTestEnvironment.ps1"

    ########################
    ## CALLOUT - Pester Output
    ########################
    psedit "$demoPath\Callouts\PesterOutput.ps1"

    ## The tests that AppVeyor will kick off automatically after running the build.
    psedit "C:\Dropbox\GitRepos\TestDomainCreator\New-TestEnvironment.Tests.ps1"

    ## The AppVeyor build script to tie everything together
    psedit "C:\Dropbox\GitRepos\TestDomainCreator\buildscripts\build.ps1"

    ## Is the build done yet?

    ## We'll just remove the AD groups by changing 'Present' to 'Absent'. Since tests are still configured to confirm
    ## those groups should be there, the build will fail.
    psedit "C:\Dropbox\GitRepos\TestDomainCreator\NewTestEnvironment.ps1"

    psedit "C:\Dropbox\GitRepos\TestDomainCreator\ConfigurationData.psd1"

    ## Commit the change and sync to Github
    Push-Location -Path 'C:\Dropbox\GitRepos\TestDomainCreator'
    git commit --message 'MVA - Change to fail test'
    git add .
    git push
    Pop-Location

    ## Build will be automatically invoked. Check AppVeyor to confirm
    start 'https://ci.appveyor.com/project/adbertram/testdomaincreator'