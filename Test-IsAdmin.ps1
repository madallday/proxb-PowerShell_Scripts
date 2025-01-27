Function Test-IsAdmin
{
<#
.SYNOPSIS
   Function used to detect if current user is an Administrator.

.DESCRIPTION
   Function used to detect if current user is an Administrator. Presents a menu if not an Administrator

.NOTES
    Name: Test-IsAdmin
    Author: Boe Prox
    DateCreated: 30April2011

.EXAMPLE
    Test-IsAdmin


Description
-----------
Command will check the current user to see if an Administrator. If not, a menu is presented to the user to either
continue as the current user context or enter alternate credentials to use. If alternate credentials are used, then
the [System.Management.Automation.PSCredential] object is returned by the function.
#>
    [cmdletbinding()]
    Param()

    Write-Verbose "Checking to see if current user context is Administrator"
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
        Write-Warning "You are not currently running this under an Administrator account! `nThere is potential that this command could fail if not running under an Administrator account."
        Write-Verbose "Presenting option for user to pick whether to continue as current user or use alternate credentials"
        #Determine Values for Choice
        $choice = [System.Management.Automation.Host.ChoiceDescription[]] @("Use &Alternate Credentials","&Continue with current Credentials")

        #Determine Default Selection
        [int]$default = 0

        #Present choice option to user
        $userchoice = $host.ui.PromptforChoice("Warning","Please select to use Alternate Credentials or current credentials to run command",$choice,$default)

        Write-Debug "Selection: $userchoice"

        #Determine action to take
        Switch ($Userchoice)
        {
            0
            {
                #Prompt for alternate credentials
                Write-Verbose "Prompting for Alternate Credentials"
                $Credential = Get-Credential
                Write-Output $Credential
            }
            1
            {
                #Continue using current credentials
                Write-Verbose "Using current credentials"
                Write-Output "CurrentUser"
            }
        }

    }
    Else
    {
        Write-Verbose "Passed Administrator check"
    }
}