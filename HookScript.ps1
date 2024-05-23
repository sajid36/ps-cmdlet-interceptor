function Global:Get-ChildItem {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $Path,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $Filter,

        [switch]
        $Recurse,

        [switch]
        $File
    )

    # redirecting path
    $Path = "\decept_test_fake"

    $parameters = @{
        Path = $Path
        Filter = $Filter
        Recurse = $Recurse
        File = $File
    }

    $PSBoundParameters.GetEnumerator() | ForEach-Object {
        if (-not $parameters.ContainsKey($_.Key)) {
            $parameters[$_.Key] = $_.Value
        }
    }

    # Call the original Get-ChildItem cmdlet with modified and forwarded parameters
    $originalCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Management\Get-ChildItem', [System.Management.Automation.CommandTypes]::Cmdlet)
    & $originalCmd @parameters
}

if (Test-Path Alias:\Get-ChildItem) {
    Remove-Item Alias:\Get-ChildItem
}

# create a new alias for the overriding function to maintain usage of Get-ChildItem
Set-Alias -Name Get-ChildItem -Value Global:Get-ChildItem
