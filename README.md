<a href="https://mijn.host" target="_blank">
    <center>
        <img src="https://assets.eu.apidog.com/app/apidoc-image/custom/20240626/f1508b02-a360-4b89-b7a9-b939a9180c0e.png"
        alt="mijn.host"
        />
    </center>
</a>

# [mijn.host](https://mijn.host) Docker DNS Certbot Authenticator Plugin

The [mijn.host](https://mijn.host) DNS Certbot Plugin automates SSL/TLS certificate creation by enabling DNS-01 challenges using the mijn.host API. This plugin is designed to work with the Certbot tool, allowing seamless integration for automated certificate management.

I created a Docker image for certbot-dns-mijn-host plugin from [github.com/mijnhost/certbot-dns-mijn-host](https://github.com/mijnhost/certbot-dns-mijn-host)

The image is based on certbot original image with the addition of the plugin and include some variations to run all the scripts as non root user, set some permissions and schedule the certificate update with 'supercronic'. The only script that run with highest privileges is for settings some folder permission.

You need mapping of the following internal folders, that certbot uses as base dirs.

```bash
- /certbot # base folder
- /certbot/etc/letsencrypt/live # generated certificates folder
- /certbot/etc/letsencrypt/.secrets # path containing Ionos credential file
```

Create the file containing the credentials for the mijn.host api login, you can specify the path via env variable (change the volume accordingly). Make sure you created the API key on mijn.host control panel

This is the template to use (also available in the repository mijn-host.ini.tmpl or in the original project repo)

```ini
# Replace with your values
dns_mijn_host_api_key = YOUR_API_KEY_HERE
```

## Usage

The image is available on Dockerhub [mijnhost/certbot-dns-mijn-host](https://hub.docker.com/r/mijnhost/certbot-dns-mijn-host)

For a fast run from command line with the following example make sure:

- you created all dirs to mount as volume
- you created the 'mijnhost.ini' file with correct credentials under ~/certbot/etc/letsencrypt/.secrets
- create a .env file, for simplicity, with all the envs needed

```bash
docker run -it --rm \
  -v $(pwd)/certbot:/certbot \
  mijnhost/certbot-dns-mijn-host \
  certbot certonly \
  --authenticator dns-mijn-host \
  --dns-mijn-host-credentials /certbot/etc/letsencrypt/.secrets/mijnhost.ini \
  --dns-mijn-host-propagation-seconds 60 \
  --agree-tos \
  --rsa-key-size 4096 \
  --config-dir /certbot/etc/letsencrypt \
  --work-dir /certbot/var/lib/letsencrypt \
  --logs-dir /certbot/var/log/letsencrypt \
  -d 'example.com' \
  -d '*.example.nl'
```
