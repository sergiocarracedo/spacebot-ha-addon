# Changelog

## 0.4.1

- Uses spacebot [0.4.1](https://github.com/spacedriveapp/spacebot/releases/tag/v0.4.1) release

## 0.4.0

- Uses spacebot [0.4.0](https://github.com/spacedriveapp/spacebot/releases/tag/v0.4.0) release

## 0.3.16

- Disable AppArmor for the addon to allow `mount --make-rshared /` before `bwrap` sandboxing.

## 0.3.15

- Increase nginx ingress upload limit to `100m` (`client_max_body_size`) to fix `413 Content Too Large` errors during ingest file uploads.

## 0.3.14

- Change floating terminal button label from `>_ terminal` to `>_`; set `title` and `alt` to "Spacebot container terminal".

## 0.3.13

- Switch MCP server launch from `node hass-mcp.js` to `npx -y home-assistant-mcp-server` — more robust, no manual build step needed.
- Pre-cache `home-assistant-mcp-server` via `npx` during Docker build so it doesn't need internet at runtime.
- Keep `bun`/`bunx` in the image as an alternative runtime.
- Drop `npm install -g` + `bun run build` steps from Dockerfile.

## 0.3.12

- Inject a floating `>_ terminal` button into the Spacebot UI (bottom-right corner) via nginx `sub_filter`. Opens the ttyd web terminal in a new browser tab.

## 0.3.11

- Install `bun` during Docker build and run `bun run build` inside `home-assistant-mcp-server` to compile TypeScript source into `dist/index.js`. Fixes MCP server spawn failure (`dist/index.js` was missing).

## 0.3.10

- Fix MCP server `command` in `config.toml`: use `node` with full path to `hass-mcp.js` instead of the non-existent `/usr/local/bin/home-assistant-mcp-server` symlink.

## 0.3.9

- Add `ttyd` web terminal at `/terminal/` for live container debugging (arch-aware static binary download, nginx location block).
- Add `/terminal/` nginx location proxying to ttyd on port 7681.

## 0.3.8

- Install Node.js 20.x in Dockerfile.
- Install `home-assistant-mcp-server` globally via `npm install -g`.
- Move `[[mcp_servers]]` config to correct `[[agents.mcp]]` location under teixubot agent.
- Fix teixubot model name: `gemini-3-flash-preview` → `gemini-flash-latest`.

## 0.3.7

- Tee Spacebot stdout/stderr to `/share/spacebot/spacebot.log` for visibility from HA File Editor.

## 0.3.6

- Fix `bwrap: Failed to make / slave`: add `mount --make-rshared /` in `run.sh`.

## 0.3.5

- Fix `bwrap: Creating new namespace failed`: add `privileged: [SYS_ADMIN]` to `config.yaml`.

## 0.3.3

- Initial release of the Home Assistant Spacebot App.
- Based on Spacebot upstream image `ghcr.io/spacedriveapp/spacebot:latest` (v0.3.3).
- HA Ingress support for sidebar panel access.
- Cold backup strategy with Chrome binary exclusions.
- Optional direct port access on 19898.
- Configurable API keys and messaging tokens via HA app options.
