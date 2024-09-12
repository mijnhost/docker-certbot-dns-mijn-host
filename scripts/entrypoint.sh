#!/bin/sh

# Configure supercronic schedules
echo "${MIJNHOST_CRONTAB} /certbot_script.sh" | tee -a "/tmp/crontabs/certbot" >/dev/null

# Some startup log
echo time=\""$(date -Is || true)"\"' level=info msg='\""docker-certbot-dns-mijn-host v${DNS_PLUGIN_VERSION} started"\"
echo time=\""$(date -Is || true)"\"' level=info msg='\""Starting $*"\"

#Start supercronic from image CMD
"$@"
