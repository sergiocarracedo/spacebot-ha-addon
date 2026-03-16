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

# Install nginx (ingress proxy), Node.js 20.x, and bun.
# Node.js brings npm, npx, and node — npx is used at runtime to run MCP servers
# (e.g. npx -y home-assistant-mcp-server). Bun is kept as an alternative runtime.
RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx ca-certificates curl gnupg unzip && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    curl -fsSL https://bun.sh/install | bash && \
    ln -s /root/.bun/bin/bun /usr/local/bin/bun && \
    ln -s /root/.bun/bin/bunx /usr/local/bin/bunx

# Pre-cache home-assistant-mcp-server so npx doesn't need internet at runtime.
RUN npx -y home-assistant-mcp-server --help 2>/dev/null || true

# Install ttyd (web-based terminal) for interactive container debugging.
# ttyd is not in Debian 12 apt repos so we download the static binary from
# GitHub releases. We select the binary by architecture using BUILD_ARCH.
ARG BUILD_ARCH
RUN case "${BUILD_ARCH}" in \
      amd64)   TTYD_BIN="ttyd.x86_64" ;; \
      aarch64) TTYD_BIN="ttyd.aarch64" ;; \
      *) echo "Unsupported arch: ${BUILD_ARCH}" && exit 1 ;; \
    esac && \
    curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/1.7.7/${TTYD_BIN}" \
      -o /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd

# Override SPACEBOT_DIR to use HA's /data persistent volume.
ENV SPACEBOT_DIR=/data

# Copy nginx ingress config and entrypoint
COPY nginx-ingress.conf /etc/nginx/sites-enabled/ingress
COPY run.sh /run.sh
RUN rm -f /etc/nginx/sites-enabled/default && chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
