# Spacebot Home Assistant App Repository

This repository packages [Spacebot](https://spacebot.sh) as a Home Assistant App
(formerly known as an add-on).

Spacebot is an AI agent for teams, communities, and multi-user environments. It
can connect to Discord, Slack, Telegram, and Twitch; remember context across
conversations; and execute real work with shell, file, browser, and coding
tools.

This Home Assistant package wraps the official upstream Spacebot image so it can
run cleanly inside Home Assistant OS with ingress support, persistent storage,
and backup-friendly data locations.

> **Disclaimer:** This project is not affiliated with, endorsed by, or
> officially supported by the Spacebot team or Spacedrive. It is an independent,
> community-maintained Home Assistant app.

## What This Adds

- Home Assistant sidebar access through ingress
- Persistent data under `/share/spacebot`
- Backup-aware storage layout for Home Assistant
- A packaged Spacebot runtime for `aarch64` and `amd64`

## Installation

1. Open Home Assistant.
2. Go to **Settings -> Apps -> App store**.
3. Open the three-dot menu and select **Repositories**.
4. Add this repository URL:

```text
https://github.com/sergiocarracedo/spacebot-ha-addon
```

5. Find **Spacebot** in the store and install it.
6. Start the app.
7. Open the web UI from the Home Assistant sidebar or the app page.

## Spacebot

[![Supports aarch64](https://img.shields.io/badge/aarch64-yes-green.svg)](https://github.com/sergiocarracedo/spacebot-ha-addon)
[![Supports amd64](https://img.shields.io/badge/amd64-yes-green.svg)](https://github.com/sergiocarracedo/spacebot-ha-addon)

Spacebot runs its own control panel and configuration flow. Most setup happens
inside the Spacebot web UI, not in the Home Assistant app options panel.

For full app-specific details, see [`spacebot/DOCS.md`](spacebot/DOCS.md).

## Links

- [Spacebot website](https://spacebot.sh)
- [Spacebot documentation](https://docs.spacebot.sh)
- [Spacebot upstream GitHub](https://github.com/spacedriveapp/spacebot)
- [Spacebot add-on docs in this repo](spacebot/DOCS.md)
