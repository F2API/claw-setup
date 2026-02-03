#!/bin/bash

# OpenClaw One-Click API Configurator (v1.2)
echo "------------------------------------------"
echo "   OpenClaw API Setup Wizard (v1.2)"
echo "------------------------------------------"

# Helper to read with default (Fixed for TTY)
read_default() {
    local prompt=$1
    local default=$2
    local var_name=$3
    # Force reading from /dev/tty
    printf "$prompt [$default]: "
    read -r input < /dev/tty
    if [ -z "$input" ]; then
        eval "$var_name="$default""
    else
        eval "$var_name="$input""
    fi
}

# 1. Collect Data
read_default "Enter Provider ID (slug)" "f2api" PROVIDER_ID
read_default "Enter Base URL" "https://api.f2api.com/v1" BASE_URL
read_default "Enter API Key" "" API_KEY
read_default "Enter Model ID" "gemini-3-flash-preview" MODEL_ID

# 2. Construct JSON Patch
PROVIDER_PATCH=$(cat <<EOF
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
EOF
)

# 3. Apply Config
echo "Applying configuration via Gateway RPC..."

openclaw config set models.providers "$PROVIDER_PATCH" --json
openclaw config set agents.defaults.model.primary "$PROVIDER_ID/$MODEL_ID"

if [ $? -eq 0 ]; then
    echo "SUCCESS: Configuration applied. Gateway is reloading."
else
    echo "ERROR: Failed to apply configuration. Ensure the OpenClaw Gateway is running."
    exit 1
fi
