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

# Install nginx to proxy HA Ingress traffic to Spacebot.
# nginx listens on 8099 (ingress port), only accepts connections from
# 172.30.32.2 (HA Ingress), and forwards to Spacebot on 127.0.0.1:19898.
RUN apt-get update && apt-get install -y --no-install-recommends nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Override SPACEBOT_DIR to use HA's /data persistent volume.
ENV SPACEBOT_DIR=/data

# Copy nginx ingress config and entrypoint
COPY nginx-ingress.conf /etc/nginx/sites-enabled/ingress
COPY run.sh /run.sh
RUN rm -f /etc/nginx/sites-enabled/default && chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
