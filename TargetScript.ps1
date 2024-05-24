# PowerShell Script to Encrypt Files and Exfiltrate a Credentials File
Start-Sleep -Seconds 3

# Directory where the text files are located
$directory = "decept_test"
$textFiles = Get-ChildItem -Path $directory -Filter "*.txt" -Recurse -File -ErrorAction SilentlyContinue

# Encrypting discovered text files
$textFiles | ForEach-Object {
    Write-Host "Found PDF file: $($_.FullName)"
}

# Save search results to a text file
$outputPath = Join-Path -Path (Get-Location) -ChildPath "found_txts.txt"
$textFiles | Select-Object FullName | Out-File $outputPath