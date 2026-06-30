# AI Brain

AI Brain is a Docker Compose project intended for the Ubuntu server `epyc`.

Planned runtime path:

```text
/dockersites/aibrain
```

Primary domain:

```text
brain.cryptocomputer.ca
```

Subdomains:

```text
couchdb.brain.cryptocomputer.ca
obsidian.brain.cryptocomputer.ca
```

## Services

- CouchDB for Obsidian LiveSync.
- Browser-based Obsidian through `obsidian-remote`.
- Ollama for local model serving.
- Nginx examples for TLS reverse proxying.

## Storage Policy

Persistent data must live in external named Docker volumes. This repo must not use bind-mounted host data paths for persistent service state, and must never use `/srv/data`.

Declared external volumes:

- `aibrain_couchdb_data`
- `aibrain_obsidian_vault`
- `aibrain_obsidian_config`
- `aibrain_ollama`

`bootstrap.sh` creates missing external volumes. `manage.sh` refuses `docker compose down -v` and direct volume removal commands.

## Initial Setup

On the target host, after placing the repo at the runtime path:

```bash
cd /dockersites/aibrain
./bootstrap.sh
```

Then edit `.env` and replace every `CHANGEME` value with a generated secret.

Validate the Compose file:

```bash
./manage.sh config
```

Start services only when deployment is intended:

```bash
./manage.sh pull
./manage.sh up
```

## LiveSync Notes

Create a dedicated CouchDB database for Obsidian LiveSync after CouchDB is running. Use the CouchDB admin credentials from `.env` and point the Obsidian LiveSync plugin at:

```text
https://couchdb.brain.cryptocomputer.ca
```

Keep database names lowercase. A common choice is:

```text
obsidian_livesync
```

## Documentation

- [Deployment](docs/deployment.md)
- [Cloudflare Origin Lockdown](docs/cloudflare-origin-lockdown.md)
- [Operations](docs/operations.md)
- [Storage Policy](docs/storage-policy.md)
