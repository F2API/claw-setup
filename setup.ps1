# OpenClaw One-Click API Configurator (v1.3)
# Windows PowerShell Version

Write-Host "------------------------------------------" -ForegroundColor Cyan
Write-Host "   OpenClaw API Setup Wizard (v1.3)" -ForegroundColor Cyan
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
    "baseUrl": "$BASE_URL",
    "apiKey": "$API_KEY",
    "api": "openai-completions",
    "models": [
      { "id": "$MODEL_ID", "name": "$MODEL_ID", "reasoning": true, "input": [ "text", "image" ] }
    ]
}
"@

# 3. Apply Config
Write-Host "`nApplying configuration..." -ForegroundColor Yellow

# Use quotes for the key path to ensure variable interpolation happens correctly
openclaw config set "models.providers.$PROVIDER_ID" $PROVIDER_PATCH --json

if ($LASTEXITCODE -eq 0) {
    Write-Host "Configuration applied." -ForegroundColor Green
} else {
    Write-Host "ERROR: Failed to apply configuration. Ensure the OpenClaw Gateway is running." -ForegroundColor Red
    exit 1
}

openclaw config set agents.defaults.model.primary "$PROVIDER_ID/$MODEL_ID"

if ($LASTEXITCODE -eq 0) {
    openclaw gateway restart
    Write-Host "SUCCESS: Configuration applied." -ForegroundColor Green
} else {
    Write-Host "ERROR: Failed to apply configuration." -ForegroundColor Red
    exit 1
}
