<#
    .SYNOPSIS
        Returns an invalid argument exception object

    .PARAMETER Message
        The message explaining why this error is being thrown

    .PARAMETER ArgumentName
        The name of the invalid argument that is causing this error to be thrown
#>
function Get-InvalidArgumentRecord
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ArgumentName
    )

    $argumentException = New-Object -TypeName 'ArgumentException' `
                                    -ArgumentList @(
                                        $Message,
                                        $ArgumentName
                                    )

    $newObjectParameters = @{
        TypeName = 'System.Management.Automation.ErrorRecord'
        ArgumentList = @(
            $argumentException,
            $ArgumentName,
            'InvalidArgument',
            $null
        )
    }

    return New-Object @newObjectParameters
}

<#
    .SYNOPSIS
        Returns an invalid operation exception object

    .PARAMETER Message
        The message explaining why this error is being thrown

    .PARAMETER ErrorRecord
        The error record containing the exception that is causing this terminating error
#>
function Get-InvalidOperationRecord
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    if ($null -eq $ErrorRecord)
    {
        $invalidOperationException = New-Object -TypeName 'InvalidOperationException' `
                                                -ArgumentList @( $Message )
    }
    else
    {
        $invalidOperationException = New-Object -TypeName 'InvalidOperationException' `
                                                -ArgumentList @(
                                                    $Message,
                                                    $ErrorRecord.Exception
                                                )
    }

    $newObjectParameters = @{
        TypeName = 'System.Management.Automation.ErrorRecord'
        ArgumentList = @(
            $invalidOperationException.ToString(),
            'MachineStateIncorrect',
            'InvalidOperation',
            $null
        )
    }

    return New-Object @newObjectParameters
}

<#
    .SYNOPSIS
        Returns an object not found exception object

    .PARAMETER Message
        The message explaining why this error is being thrown

    .PARAMETER ErrorRecord
        The error record containing the exception that is causing this terminating error
#>
function Get-ObjectNotFoundException
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    if ($null -eq $ErrorRecord)
    {
        $objectNotFoundException = New-Object -TypeName 'System.Exception' `
                                              -ArgumentList @($Message)
    }
    else
    {
        $objectNotFoundException = New-Object -TypeName 'System.Exception' `
                                              -ArgumentList @(
                                                   $Message,
                                                   $ErrorRecord.Exception
                                               )
    }

    $newObjectParameters = @{
        TypeName = 'System.Management.Automation.ErrorRecord'
        ArgumentList = @(
            $objectNotFoundException.ToString(),
            'MachineStateIncorrect',
            'ObjectNotFound',
            $null
            )
    }

    return New-Object @newObjectParameters
}

<#
    .SYNOPSIS
        Returns an invalid result exception object

    .PARAMETER Message
        The message explaining why this error is being thrown

    .PARAMETER ErrorRecord
        The error record containing the exception that is causing this terminating error
#>
function Get-InvalidResultException
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    if ($null -eq $ErrorRecord)
    {
        $exception = New-Object -TypeName 'System.Exception' `
                                -ArgumentList @($Message)
    }
    else
    {
        $exception = New-Object -TypeName 'System.Exception' `
                                -ArgumentList @(
                                    $Message,
                                    $ErrorRecord.Exception
                                )
    }

    $newObjectParameters = @{
        TypeName = 'System.Management.Automation.ErrorRecord'
        ArgumentList = @(
            $exception.ToString(),
            'MachineStateIncorrect',
            'InvalidResult',
            $null
        )
    }

    return New-Object @newObjectParameters
}


function Get-Something {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Variable1,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Variable5,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Variable2,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Variable3,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Variable6,

        [ValidateNotNullOrEmpty()]
        [System.String]
        $Variable7
    )

    if ( $true ) {
        Write-Verbose 'Hello' -Verbose
    }

    if ( $true )
    {
        Write-Verbose 'Hello again' -Verbose
    }

    if ( $true )
    { Write-Verbose 'Hello for the third tme' -Verbose
    }

    if ( $true )
    {

        Write-Verbose 'Hello for the fourth tme' -Verbose
    }

    $i = 0

    do
    {

        $i++
    } until ($i -eq 2)

    $value = 1

    try {
        'hej'
    }
    catch {
        'då'
    }
    finally {
        'igen'
    }

    switch ($value) {
        1 { ''one'' }
    }
}

Export-ModuleMember -Function @(
    'Get-InvalidArgumentRecord'
    'Get-InvalidOperationRecord'
    'Get-ObjectNotFoundException'
    'Get-InvalidResultException'
    'Get-Something'
)
