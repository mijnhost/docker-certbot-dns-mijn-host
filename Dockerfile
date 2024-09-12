ARG CERTBOT_VERSION=latest
ARG VERSION=0.0.1

FROM certbot/certbot:${CERTBOT_VERSION}

LABEL org.opencontainers.image.authors="shubhamku044@gmail.com"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/your-dockerhub-repo"
LABEL org.opencontainers.image.source="https://github.com/your-github-repo"
LABEL org.opencontainers.image.base.name="certbot/certbot:${CERTBOT_VERSION}"
LABEL org.opencontainers.image.version="${VERSION}"

# arch and version envs
ARG TARGETPLATFORM

ENV DNS_PLUGIN_VERSION=0.0.4
ENV TARGETPLATFORM=${TARGETPLATFORM}

# user envs
ENV USERNAME=certbot
ENV USER_UID=1000
ENV USER_GID=${USER_UID}

# certbot envs
ENV CERTBOT_BASE_DIR="/certbot"
ENV CERTBOT_CONFIG_DIR="${CERTBOT_BASE_DIR}/etc/letsencrypt"
ENV CERTBOT_LIVE_DIR="${CERTBOT_CONFIG_DIR}/live"
ENV CERTBOT_ARCHIVE_DIR="${CERTBOT_CONFIG_DIR}/archive"
ENV CERTBOT_LOGS_DIR="${CERTBOT_BASE_DIR}/var/log/letsencrypt"
ENV CERTBOT_WORK_DIR="${CERTBOT_BASE_DIR}/var/lib/letsencrypt"

# update image, create user and set some permissions
SHELL ["/bin/sh", "-o", "pipefail", "-c"]
RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache curl bash \
    && mkdir -p "${CERTBOT_BASE_DIR}" \
    && addgroup -g "${USER_GID}" -S "${USERNAME}" \
    && adduser -u "${USER_UID}" -S "${USERNAME}" -G "${USERNAME}" -h "${CERTBOT_BASE_DIR}" \
    && chown -R "${USERNAME}:${USERNAME}" "${CERTBOT_BASE_DIR}" 

# install supercronic for cron jobs
ENV SUPERCRONIC_BASE_URL="https://github.com/aptible/supercronic/releases/download/v0.2.29"
RUN wget -q "${SUPERCRONIC_BASE_URL}/supercronic-linux-$(echo "${TARGETPLATFORM}" | cut -d '/' -f 2)" -O /usr/local/bin/supercronic \
    && chmod +x /usr/local/bin/supercronic \
    && echo "done"

# install mijn-host plugin
RUN pip install --upgrade pip && pip install --no-cache-dir "certbot-dns-mijn-host==${DNS_PLUGIN_VERSION}"

# copy and configure scripts
COPY scripts/* /
RUN chmod 555 /*.sh

USER ${USERNAME}

# create necessary directories
WORKDIR "${CERTBOT_BASE_DIR}"
RUN mkdir -p "${CERTBOT_LIVE_DIR}" \
    "${CERTBOT_ARCHIVE_DIR}" \
    "${CERTBOT_LOGS_DIR}" \
    "${CERTBOT_WORK_DIR}" \
    /tmp/crontabs \
    && touch "/tmp/crontabs/${USERNAME}"

HEALTHCHECK CMD ["pgrep", "-f", "certbot_entry.sh"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/supercronic", "-passthrough-logs", "/tmp/crontabs/certbot"]

