# Deployment Notes

These notes are for a later deployment on the Ubuntu server `epyc`. Do not run deployment steps from this initialization task.

## Runtime Path

The intended runtime path is:

```text
/dockersites/aibrain
```

Do not place persistent data under the project directory. Persistent state belongs in external Docker named volumes only.

## Certbot and Nginx

Install Nginx and Certbot on the host:

```bash
sudo apt update
sudo apt install nginx certbot python3-certbot-nginx
```

Create certificates for the main domain and subdomains:

```bash
sudo certbot --nginx \
  -d brain.cryptocomputer.ca \
  -d couchdb.brain.cryptocomputer.ca \
  -d obsidian.brain.cryptocomputer.ca
```

Install the example config:

```bash
sudo cp nginx/brain.cryptocomputer.ca.conf.example /etc/nginx/sites-available/brain.cryptocomputer.ca
sudo ln -s /etc/nginx/sites-available/brain.cryptocomputer.ca /etc/nginx/sites-enabled/brain.cryptocomputer.ca
sudo nginx -t
sudo systemctl reload nginx
```

Certbot may edit the site file after certificate issuance. Review paths under `/etc/letsencrypt/live/`.

## Compose Validation

Before starting services:

```bash
./bootstrap.sh
editor .env
./manage.sh config
```

Only after `.env` contains real generated values:

```bash
./manage.sh pull
./manage.sh up
```

## DNS

Create DNS records for:

- `brain.cryptocomputer.ca`
- `couchdb.brain.cryptocomputer.ca`
- `obsidian.brain.cryptocomputer.ca`

When Cloudflare proxying is enabled, also follow [Cloudflare Origin Lockdown](cloudflare-origin-lockdown.md).
