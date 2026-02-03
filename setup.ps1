# OpenClaw One-Click API Configurator (v1.2)
# Windows PowerShell Version

Write-Host "------------------------------------------" -ForegroundColor Cyan
Write-Host "   OpenClaw API Setup Wizard (v1.2)" -ForegroundColor Cyan
Write-Host "------------------------------------------" -ForegroundColor Cyan

# 0. Dependency & Environment Checks

# Check if openclaw is in PATH
if (-not (Get-Command openclaw -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: 'openclaw' command not found." -ForegroundColor Red
    Write-Host "Please ensure OpenClaw is installed and your PATH is configured correctly." -ForegroundColor Yellow
    exit 1
}

# Check Execution Policy (Informational)
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Write-Host "WARNING: PowerShell Execution Policy is 'Restricted'." -ForegroundColor Yellow
    Write-Host "If this script fails to run, try: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Gray
}

# 1. Collect Data
function Read-Default {
    param (
        [string]$Prompt,
        [string]$Default
    )
    $input = Read-Host -Prompt "$Prompt [$Default]"
    if ([string]::IsNullOrWhiteSpace($input)) {
        return $Default
    }
    return $input
}

$PROVIDER_ID = Read-Default "Enter Provider ID (slug)" "f2api"
$BASE_URL    = Read-Default "Enter Base URL" "https://api.f2api.com/v1"
$API_KEY     = Read-Default "Enter API Key" ""
$MODEL_ID    = Read-Default "Enter Model ID" "gemini-3-flash-preview"

# 2. Construct JSON Patch
# Using a here-string for the JSON structure
$PROVIDER_PATCH = @"
{
  "$PROVIDER_ID": {
    "baseUrl": "$BASE_URL",
    "apiKey": "$API_KEY",
    "api": "openai-completions",
    "models": [
      { "id": "$MODEL_ID", "name": "$MODEL_ID", "reasoning": true, "input": [ "text", "image" ] }
    ]
  }
}
"@

# 3. Apply Config
Write-Host "`nApplying configuration via Gateway RPC..." -ForegroundColor Yellow

# In PowerShell, passing double quotes in strings to external commands can be tricky.
# We escape them if necessary, but usually, PowerShell passes the string correctly 
# to the process if it's quoted.
openclaw config set models.providers "$PROVIDER_PATCH" --json

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to apply provider configuration. Ensure the OpenClaw Gateway is running." -ForegroundColor Red
    exit 1
}

openclaw config set agents.defaults.model.primary "$PROVIDER_ID/$MODEL_ID"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nSUCCESS: Configuration applied. Gateway is reloading." -ForegroundColor Green
} else {
    Write-Host "`nERROR: Failed to set default model. Ensure the OpenClaw Gateway is running." -ForegroundColor Red
    exit 1
}
