# Storage Policy

This project intentionally uses external named Docker volumes for all persistent service data.

## Required Rules

- Persistent data must use external named Docker volumes.
- `docker-compose.yml` must declare persistent volumes with `external: true`.
- `bootstrap.sh` may create missing external volumes.
- `manage.sh` must refuse `docker compose down -v`.
- Do not use `/srv/data`.
- Do not commit real secrets, databases, vault data, model caches, or backup archives.

## Volumes

| Volume | Purpose |
| --- | --- |
| `aibrain_couchdb_data` | CouchDB database files |
| `aibrain_obsidian_vault` | Obsidian vault files |
| `aibrain_obsidian_config` | Browser Obsidian app config |
| `aibrain_ollama` | Ollama model cache and metadata |

## Rationale

The server may have unsafe or obsolete storage mounted under paths such as `/srv/data`. External named Docker volumes keep this project independent from accidental host path choices and make volume lifecycle operations explicit.
