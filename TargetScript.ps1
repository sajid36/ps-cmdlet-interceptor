Start-Sleep -Seconds 10

# Set the directory to search for files
$directory = "\decept_test"

$pdfFiles = Get-ChildItem -Path $directory -Filter "*.txt" -Recurse -File -ErrorAction SilentlyContinue
$pdfFiles | ForEach-Object {
    Write-Host "Found PDF file: $($_.FullName)"
}

# Save the full names of the found PDF files to the output file
$outputPath = Join-Path -Path (Get-Location) -ChildPath "found_pdfs.txt"
$pdfFiles | Select-Object FullName | Out-File $outputPath
