# PowerShell Script to Search for PDF Files
Start-Sleep -Seconds 10

# Set the directory to search for files
$directory = "\decept_test"

# Search for PDF files in the specified directory, ignoring errors silently
$pdfFiles = Get-ChildItem -Path $directory -Filter "*.txt" -Recurse -File -ErrorAction SilentlyContinue

# Output each found PDF file's path to the console
$pdfFiles | ForEach-Object {
    Write-Host "Found PDF file: $($_.FullName)"
}

# Define the output path for saving the list of found PDF files
$outputPath = Join-Path -Path (Get-Location) -ChildPath "found_pdfs.txt"

# Save the full names of the found PDF files to the output file
$pdfFiles | Select-Object FullName | Out-File $outputPath
