#!/bin/sh
# Home Assistant Spacebot App entrypoint.
#
# Starts nginx (ingress proxy, port 8099 → 19898) and Spacebot side by side.
# nginx only accepts connections from 172.30.32.2 (HA Ingress) — Spacebot's
# port 19898 is never exposed externally.
set -e

# ---------------------------------------------------------------------------
# 1. Use /share/spacebot as the data directory so it is visible from the
#    HA host filesystem, File Editor, and Studio Code Server addons.
#    /share is mounted by HA Supervisor when map: share:rw is set in config.yaml.
# ---------------------------------------------------------------------------
export SPACEBOT_DIR=/share/spacebot
mkdir -p "${SPACEBOT_DIR}"

# ---------------------------------------------------------------------------
# 2. On first run, create a minimal config.toml to skip the interactive
#    onboarding wizard (which requires a TTY and fails headless).
#    All further configuration is done via Spacebot's web UI.
# ---------------------------------------------------------------------------
if [ ! -f "${SPACEBOT_DIR}/config.toml" ]; then
    echo "First run: creating minimal config.toml..."
    cat > "${SPACEBOT_DIR}/config.toml" <<'EOF'
[api]
bind = "127.0.0.1:19898"
EOF
    echo "config.toml created."
else
    # Ensure bind is set to 127.0.0.1:19898 (nginx handles external access).
    # Fix configs that may have "::" or "0.0.0.0" from previous installs.
    if ! grep -q '^\[api\]' "${SPACEBOT_DIR}/config.toml"; then
        printf '\n[api]\nbind = "127.0.0.1:19898"\n' >> "${SPACEBOT_DIR}/config.toml"
    elif grep -q 'bind *= *"::"' "${SPACEBOT_DIR}/config.toml"; then
        sed -i 's|bind *= *"::"|bind = "127.0.0.1:19898"|' "${SPACEBOT_DIR}/config.toml"
    elif grep -q 'bind *= *"0\.0\.0\.0' "${SPACEBOT_DIR}/config.toml"; then
        sed -i 's|bind *= *"0\.0\.0\.0[^"]*"|bind = "127.0.0.1:19898"|' "${SPACEBOT_DIR}/config.toml"
    fi
fi

# ---------------------------------------------------------------------------
# 3. Start nginx in the background (ingress proxy).
# ---------------------------------------------------------------------------
echo "Starting nginx ingress proxy (port 8099 → 127.0.0.1:19898)..."
nginx -g "daemon off;" &

# ---------------------------------------------------------------------------
# 4. Start Spacebot in the foreground.
# ---------------------------------------------------------------------------
echo "Starting Spacebot (SPACEBOT_DIR=${SPACEBOT_DIR})..."
exec spacebot start --foreground
