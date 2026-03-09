#!/bin/bash

# OpenClaw One-Click API Configurator (v1.3)
echo "------------------------------------------"
echo "   OpenClaw API Setup Wizard (v1.3)"
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
    "baseUrl": "$BASE_URL",
    "apiKey": "$API_KEY",
    "api": "openai-completions",
    "models": [
      { "id": "$MODEL_ID", "name": "$MODEL_ID", "input": [ "text", "image" ] }
    ]
}
EOF
)

# 3. Apply Config
echo "Applying configuration"

openclaw config set models.providers.$PROVIDER_ID "$PROVIDER_PATCH" --json
openclaw config set agents.defaults.model.primary "$PROVIDER_ID/$MODEL_ID"

if [ $? -eq 0 ]; then
    openclaw gateway restart
    echo "SUCCESS: Configuration applied."
else
    echo "ERROR: Failed to apply configuration."
    exit 1
fi
