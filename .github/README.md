# GitHub Automation

`bump-spacebot.yml` keeps the Home Assistant add-on pinned to the latest stable
`spacedriveapp/spacebot` release.

Requirements:

- The repository default branch must allow pushes from GitHub Actions.
- Branch protection must not block the workflow from pushing directly to `main`.
- The workflow uses the built-in `GITHUB_TOKEN` with `contents: write`.

Behavior:

- Runs daily at 03:17 UTC and on manual dispatch.
- Ignores draft and prerelease upstream releases.
- Updates `spacebot/build.yaml`, `spacebot/config.yaml`, and `spacebot/CHANGELOG.md`.
- Creates a direct commit on `main` only when the upstream stable tag changes.
