# 🦞 ClawSetup

A lightweight, interactive CLI tool to configure third-party LLM providers for [OpenClaw](https://github.com/openclaw/openclaw) in seconds.

## 🚀 One-Line Install

Run the configurator instantly without cloning:

### Linux/macOS
```bash
curl -sSL https://raw.githubusercontent.com/f2api/claw-setup/main/setup.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/f2api/claw-setup/main/setup.ps1 | iex
```

## ✨ Features

- **Interactive Wizard**: Step-by-step guidance for setting up API keys and Base URLs.
- **Smart Defaults**: Hit `Enter` to use recommended values.
- **Atomic Patching**: Uses the OpenClaw `config patch` API, so it won't overwrite your existing settings.
- **Zero Dependencies**: Pure Bash script.

## 🛠 Usage

If you prefer to clone the repo and run it locally:

1. **Clone the repository**
   ```bash
   git clone https://github.com/claw-setup/claw-setup.git
   cd ClawSetup
   ```

2. **Run the script**
   - **Linux/macOS**:
     ```bash
     bash setup.sh
     ```
   - **Windows**:
     ```powershell
     .\setup.ps1
     ```

3. **Follow the prompts**
   - **Provider ID**: A unique name for your API provider (e.g., `deepseek`, `openrouter`).
   - **Base URL**: The endpoint of your provider.
   - **API Key**: Your secret key (hidden from logs).
   - **Model ID**: The exact model string (e.g., `deepseek-chat`).

## 📋 Prerequisites

- [OpenClaw](https://openclaw.ai) must be installed and the `openclaw` CLI must be available in your `$PATH`.
