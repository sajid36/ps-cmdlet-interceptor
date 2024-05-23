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

    # Redefine path parameter for all cases
    $Path = "\decept_test_fake"

    # Create parameter hashtable for splatting
    $parameters = @{
        Path = $Path
        Filter = $Filter
        Recurse = $Recurse
        File = $File
    }

    # Add all other incoming parameters dynamically
    $PSBoundParameters.GetEnumerator() | ForEach-Object {
        if (-not $parameters.ContainsKey($_.Key)) {
            $parameters[$_.Key] = $_.Value
        }
    }

    # Call the original Get-ChildItem cmdlet with modified and forwarded parameters
    $originalCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Management\Get-ChildItem', [System.Management.Automation.CommandTypes]::Cmdlet)
    & $originalCmd @parameters
}

# Remove the existing alias if present to avoid conflicts
if (Test-Path Alias:\Get-ChildItem) {
    Remove-Item Alias:\Get-ChildItem
}

# Create a new alias for the overriding function to maintain usage of Get-ChildItem
Set-Alias -Name Get-ChildItem -Value Global:Get-ChildItem
