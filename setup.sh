#!/bin/bash

# OpenClaw One-Click API Configurator
# This script interactively collects API settings and applies them via 'openclaw config patch'

echo "------------------------------------------"
echo "   OpenClaw API Setup Wizard (v1.0)"
echo "------------------------------------------"

# Helper to read with default
read_default() {
    local prompt=$1
    local default=$2
    local var_name=$3
    read -p "$prompt [$default]: " input
    if [ -z "$input" ]; then
        eval "$var_name="$default""
    else
        eval "$var_name="$input""
    fi
}

# 1. Collect Data
read_default "Enter Provider ID (slug)" "f2api" PROVIDER_ID
read_default "Enter Base URL" "https://api.f2api.com/v1" BASE_URL
read -p "Enter API Key: " API_KEY
read_default "Enter Model ID" "gemini-3-flash" MODEL_ID

echo ""
echo "Summary:"
echo " - Provider: $PROVIDER_ID"
echo " - BaseURL:  $BASE_URL"
echo " - Model:    $MODEL_ID"
echo "------------------------------------------"

# 2. Construct JSON Patch
# Note: We use a heredoc to build the JSON carefully
JSON_PATCH=$(cat <<EOF
{
  "models": {
    "providers": {
      "$PROVIDER_ID": {
        "baseUrl": "$BASE_URL",
        "apiKey": "$API_KEY",
        "models": [
          { "id": "$MODEL_ID", "name": "$MODEL_ID" }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "$PROVIDER_ID/$MODEL_ID"
      }
    }
  }
}
EOF
)

# 3. Apply Config
echo "Applying configuration..."
openclaw config patch "$JSON_PATCH"

if [ $? -eq 0 ]; then
    echo "SUCCESS: Configuration patched. Gateway is restarting..."
else
    echo "ERROR: Failed to apply configuration."
    exit 1
fi
