#!/bin/bash

# OpenClaw One-Click API Configurator (v1.3)

# Default values
PROVIDER_ID="f2api"
BASE_URL="https://api.f2api.com/v1"
MODEL_ID="gemini-3-flash-preview"
API_KEY=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --key) API_KEY="$2"; shift ;;
        --model) MODEL_ID="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "------------------------------------------"
echo "   OpenClaw API Setup Wizard (v1.3)"
echo "------------------------------------------"

if [ -n "$API_KEY" ]; then
    echo "Running in non-interactive mode with provided key."
    echo "Provider ID: $PROVIDER_ID"
    echo "Base URL: $BASE_URL"
    echo "Model ID: $MODEL_ID"
    echo "API Key: [HIDDEN]"
else
    # Helper to read with default (Fixed for TTY)
    read_default() {
        local prompt=$1
        local default=$2
        local var_name=$3
        # Force reading from /dev/tty
        printf "$prompt [$default]: "
        read -r input < /dev/tty
        if [ -z "$input" ]; then
            eval "$var_name=\"$default\""
        else
            eval "$var_name=\"$input\""
        fi
    }

    # 1. Collect Data
    read_default "Enter Provider ID (slug)" "$PROVIDER_ID" PROVIDER_ID
    read_default "Enter Base URL" "$BASE_URL" BASE_URL
    read_default "Enter API Key" "" API_KEY
    read_default "Enter Model ID" "$MODEL_ID" MODEL_ID
fi

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
