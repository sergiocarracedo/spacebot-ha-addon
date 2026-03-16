# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
#
# BUILD_FROM is resolved by HA builder to the image defined in build.yaml.
# The upstream Spacebot image (Debian 12) contains the compiled binary,
# all runtime deps, and the embedded web UI.
ARG BUILD_FROM
FROM $BUILD_FROM

# HA app labels (required when not using the HA builder auto-labeling)
ARG BUILD_VERSION BUILD_ARCH
LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="addon" \
  io.hass.arch="${BUILD_ARCH}"

# Install nginx (ingress proxy) and Node.js 20.x (needed for MCP servers
# that use npx, e.g. home-assistant-mcp-server).
# nginx listens on 8099 (ingress port), only accepts connections from
# 172.30.32.2 (HA Ingress), and forwards to Spacebot on 127.0.0.1:19898.
RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    npm install -g home-assistant-mcp-server

# Override SPACEBOT_DIR to use HA's /data persistent volume.
ENV SPACEBOT_DIR=/data

# Copy nginx ingress config and entrypoint
COPY nginx-ingress.conf /etc/nginx/sites-enabled/ingress
COPY run.sh /run.sh
RUN rm -f /etc/nginx/sites-enabled/default && chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
