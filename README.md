# 🦞 ClawSetup

A lightweight, interactive CLI tool to configure third-party LLM providers for [OpenClaw](https://github.com/openclaw/openclaw) in seconds.

## 🚀 One-Line Install

Run the configurator instantly without cloning:

```bash
curl -sSL https://raw.githubusercontent.com/f2api/claw-setup/main/setup.sh | bash
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
   ```bash
   bash setup.sh
   ```

3. **Follow the prompts**
   - **Provider ID**: A unique name for your API provider (e.g., `deepseek`, `openrouter`).
   - **Base URL**: The endpoint of your provider.
   - **API Key**: Your secret key (hidden from logs).
   - **Model ID**: The exact model string (e.g., `deepseek-chat`).

## 📋 Prerequisites

- [OpenClaw](https://openclaw.ai) must be installed and the `openclaw` CLI must be available in your `$PATH`.

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a PR to add more features like:
- Multiple model presets.
- Health check validation after setup.
- Proxy configuration support.

## 📄 License

MIT © [YOUR_NAME]
```

### Next Steps:
1.  Create a new repository on GitHub named `ClawSetup`.
2.  Initialize it with the `setup.sh` script I wrote previously.
3.  Add this `README.md` and you are ready to share it!

Would you like me to help you initialize the git repo and prepare the initial commit? [[reply_to_current]]