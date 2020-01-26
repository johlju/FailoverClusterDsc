<#
    Suppressing this rule because a plain text password variable is used to mock the LogonUser static
    method and is required for the tests.
#>
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '')]
param ()

$script:DSCModuleName = 'xFailOverCluster'
$script:DSCResourceName = 'MSFT_xCluster'

function Invoke-TestSetup
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $ModuleVersion
    )

    try
    {
        Import-Module -Name DscResource.Test -Force -ErrorAction 'Stop'
    }
    catch [System.IO.FileNotFoundException]
    {
        throw 'DscResource.Test module dependency not found. Please run ".\build.ps1 -Tasks build" first.'
    }

    $script:testEnvironment = Initialize-TestEnvironment `
        -DSCModuleName $script:dscModuleName `
        -DSCResourceName $script:dscResourceName `
        -ResourceType 'Mof' `
        -TestType 'Unit'

    Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath "Stubs\FailoverClusters$ModuleVersion.stubs.psm1") -Global -Force
    Import-Module -Name (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath 'TestHelpers\CommonTestHelper.psm1') -Global -Force

    $global:moduleVersion = $ModuleVersion
}

function Invoke-TestCleanup
{
    Restore-TestEnvironment -TestEnvironment $script:testEnvironment
    Remove-Variable -Name moduleVersion -Scope Global -ErrorAction SilentlyContinue
}

foreach ($moduleVersion in @('2012', '2016'))
{
    Invoke-TestSetup -ModuleVersion $moduleVersion

    try
    {
        InModuleScope $script:DSCResourceName {
            class MockLibImpersonation
            {
                static [bool] $ReturnValue = $false

                static [bool]LogonUser(
                    [string] $userName,
                    [string] $domain,
                    [string] $password,
                    [int] $logonType,
                    [int] $logonProvider,
                    [ref] $token
                )
                {
                    return [MockLibImpersonation]::ReturnValue
                }

                static [bool]CloseHandle([System.IntPtr]$Token)
                {
                    return [MockLibImpersonation]::ReturnValue
                }
            }

            $mockAdministratorUserName = 'COMPANY\ClusterAdmin'
            $mockAdministratorPassword = ConvertTo-SecureString -String 'dummyPassW0rd' -AsPlainText -Force
            $mockAdministratorCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList @($mockAdministratorUserName, $mockAdministratorPassword)

            [MockLibImpersonation]::ReturnValue = $false
            $mockLibImpersonationObject = [MockLibImpersonation]::New()

            Describe "xCluster_$moduleVersion\Set-ImpersonateAs" -Tag 'Helper' {
                Context 'When impersonating credentials fails' {
                    It 'Should throw the correct error message' {
                        Mock -CommandName Add-Type -MockWith {
                            return $mockLibImpersonationObject
                        }

                        $mockCorrectErrorRecord = Get-InvalidOperationRecord -Message ($script:localizedData.UnableToImpersonateUser -f $mockAdministratorCredential.GetNetworkCredential().UserName)
                        { Set-ImpersonateAs -Credential $mockAdministratorCredential } | Should -Throw $mockCorrectErrorRecord
                    }
                }
            }

            Describe "xCluster_$moduleVersion\Close-UserToken" -Tag 'Helper' {
                Context 'When closing user token fails' {
                    It 'Should throw the correct error message' {
                        Mock -CommandName Add-Type -MockWith {
                            return $mockLibImpersonationObject
                        } -Verifiable

                        $mockToken = [System.IntPtr]::New(12345)

                        $mockCorrectErrorRecord = Get-InvalidOperationRecord -Message ($script:localizedData.UnableToCloseToken -f $mockToken.ToString())
                        { Close-UserToken -Token $mockToken } | Should -Throw $mockCorrectErrorRecord
                    }
                }
            }
        }
    }
    finally
    {
        Invoke-TestCleanup
    }
}
