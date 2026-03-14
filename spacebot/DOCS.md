# Spacebot

AI agent for teams, communities, and multi-user environments. Thinks, executes, and responds — concurrently, not sequentially. Never blocks. Never forgets.

## Features

- **Multi-platform**: Connect to Discord, Slack, Telegram, or Twitch
- **Memory graph**: Typed, graph-connected knowledge across all conversations
- **Workers**: Shell, file, browser, and coding tasks running in the background
- **Scheduling**: Cron jobs for recurring tasks
- **Multi-agent**: Run multiple agents with separate identities and memories
- **Smart routing**: Automatic model selection across Anthropic, OpenAI, OpenRouter, and more

## Installation

1. Add this repository to your Home Assistant App store.
2. Install the **Spacebot** app.
3. Configure at least one LLM API key in the app configuration (or leave blank and configure via the web UI).
4. Start the app.
5. Click **OPEN WEB UI** or use the **Spacebot** entry in the sidebar to access the control panel.

## Configuration

### Option 1: Via the HA app configuration panel

Provide your API keys and messaging tokens directly in the app configuration. These are stored securely by Home Assistant and injected as environment variables at startup.

### Option 2: Via Spacebot's web UI

Leave all fields blank, start the app, and configure everything through the Spacebot control panel at port 19898. You can also manage full `config.toml` options (routing presets, multiple agents, MCP servers, etc.) from there.

### Option 3: Edit config.toml directly

After first run, `config.toml` is created in the app's `/data` directory. On Home Assistant OS, this can be accessed via the Samba or SSH apps at:

```
/addon_configs/<hash>_spacebot/
```

Or use the Studio Code Server app to edit it directly.

## Web UI access

The Spacebot control panel is accessible two ways:

| Method | URL | Notes |
|--------|-----|-------|
| **HA Ingress** (recommended) | Sidebar entry "Spacebot" | Proxied through HA, no extra port needed |
| **Direct** (optional) | `http://homeassistant.local:19898` | Enable port 19898 in the app network configuration |

> **Note on Ingress**: If Spacebot's UI has issues loading assets when accessed via Ingress (due to absolute URL paths), switch to direct port access.

## Backups

This app uses **cold backup** — Home Assistant will stop Spacebot briefly while taking a backup to ensure database consistency (SQLite, LanceDB, redb). Spacebot will restart automatically after the backup completes.

The following are **excluded from backups** as they are regenerated on first use:

- Chrome browser binary (`tools/bin/chrome*`)
- Chrome data directory

Everything else — conversations, memories, config, secrets — is included.

## Support

- [Spacebot documentation](https://docs.spacebot.sh)
- [Spacebot GitHub](https://github.com/spacedriveapp/spacebot)
- [Spacebot Discord](https://discord.gg/gTaF2Z44f5)
