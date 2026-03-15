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
3. Start the app.
4. Open the web UI via the **Spacebot** sidebar entry or the **OPEN WEB UI** button.
5. Configure your LLM provider and messaging integrations through the Spacebot control panel.

## Configuration

All configuration is done through the Spacebot web UI. There are no options to set in the Home Assistant app configuration panel.

For advanced users, Spacebot stores its full configuration in `config.toml`, located at:

```
/share/spacebot/config.toml
```

This path is accessible from the HA host filesystem and from the **File Editor** and **Studio Code Server** addons.

## Web UI access

The Spacebot control panel is only accessible through HA Ingress — either via the **Spacebot** sidebar entry or the **OPEN WEB UI** button on the app page. Port 19898 is not exposed externally.

## Data storage

All Spacebot data (config, memories, conversations, embeddings) is stored under `/share/spacebot/` on the Home Assistant host. This makes it directly browsable from the **File Editor** and **Studio Code Server** addons without any extra configuration.

## Backups

Spacebot data lives in `/share/spacebot/`, which is included in all Home Assistant full backups automatically.

This app uses **cold backup** — Home Assistant will stop Spacebot briefly while taking a backup to ensure database consistency (SQLite, LanceDB, redb). Spacebot restarts automatically after the backup completes.

The following are **excluded from backups** as they are large and regenerated on first use:

- Chrome browser binary (`tools/bin/chrome*`)
- Chrome cache directory

Everything else — conversations, memories, config, secrets — is included.

## Support

- [Spacebot documentation](https://docs.spacebot.sh)
- [Spacebot GitHub](https://github.com/spacedriveapp/spacebot)
- [Spacebot Discord](https://discord.gg/gTaF2Z44f5)
