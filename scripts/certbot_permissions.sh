#!/bin/sh

# Set some permissions at startup
chown -R "${USERNAME}":"${USERNAME}" "${CERTBOT_BASE_DIR}"
chmod 755 "${CERTBOT_LIVE_DIR}"
chmod 755 "${CERTBOT_ARCHIVE_DIR}"
