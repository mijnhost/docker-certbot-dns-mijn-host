#!/bin/sh

# Check that MIJNHOST_DOMAINS are populated
if env | grep -w MIJNHOST_DOMAINS >/dev/null; then
	DOMAINS=$(echo "${MIJNHOST_DOMAINS}" | tr "," " ")
	for domain in ${DOMAINS}; do
		DOMAINS_ARGS=${DOMAINS_ARGS}" -d ${domain}"
	done
else
	echo "MIJNHOST_DOMAINS env not set"
	exit 10
fi

# Start certbot
/usr/local/bin/certbot certonly \
    --config-dir "${CERTBOT_CONFIG_DIR}" \
    --logs-dir "${CERTBOT_LOGS_DIR}" \
	--work-dir "${CERTBOT_WORK_DIR}" \
	--authenticator dns-mijn-host \
	--dns-mijn-host-credentials "${MIJNHOST_CREDENTIALS}" \
	--dns-mijn-host-propagation-seconds "${MIJNHOST_PROPAGATION}" \
	--non-interactive \
	--expand \
	--agree-tos \
	--email "${MIJNHOST_EMAIL}" \
	--rsa-key-size 4096 ${DOMAINS_ARGS} \
	${MIJNHOST_ARGS}
