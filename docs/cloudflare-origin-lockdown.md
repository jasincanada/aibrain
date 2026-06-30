# Cloudflare Origin Lockdown

The public origin should accept HTTP and HTTPS only from Cloudflare edge IP ranges after DNS is proxied through Cloudflare.

## Recommended Controls

- Bind Compose services to `127.0.0.1` only. This project does that by default.
- Expose public traffic through Nginx only.
- Restrict inbound ports `80` and `443` at the host firewall to Cloudflare IP ranges.
- Keep SSH restricted separately. Do not rely on Cloudflare HTTP proxying for SSH protection.
- Use Full Strict TLS mode in Cloudflare once Certbot certificates are installed.

## UFW Example

Fetch Cloudflare IP ranges from Cloudflare documentation before applying firewall rules. The ranges can change, so verify them during deployment.

Example shape:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from <trusted-admin-ip> to any port 22 proto tcp
sudo ufw allow from <cloudflare-ipv4-cidr> to any port 80 proto tcp
sudo ufw allow from <cloudflare-ipv4-cidr> to any port 443 proto tcp
sudo ufw enable
sudo ufw status verbose
```

Repeat the Cloudflare allow rules for every current IPv4 and IPv6 Cloudflare range.

## Nginx Real IP

If the origin is locked to Cloudflare, configure Nginx `real_ip_header CF-Connecting-IP` and `set_real_ip_from` for Cloudflare ranges so access logs show client IPs instead of Cloudflare proxy IPs.

Keep this configuration in a separate host-level include, because the Cloudflare IP list is operational data that should be refreshed.
