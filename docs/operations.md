# Operations

## Common Commands

Validate Compose:

```bash
./manage.sh config
```

Start services:

```bash
./manage.sh up
```

Show status:

```bash
./manage.sh ps
```

Follow logs:

```bash
./manage.sh logs
./manage.sh logs couchdb
```

Stop services without deleting volumes:

```bash
./manage.sh down
```

## Forbidden Destructive Command

Do not run:

```bash
docker compose down -v
```

`manage.sh` refuses this, but direct Docker commands can still delete data if run manually.

## Backups

Backups should be taken from the external Docker volumes or through service-native export mechanisms.

For CouchDB, prefer database replication or `_dump` style service tooling rather than copying live database files while the container is running.

For Obsidian vault data, stop the Obsidian container or use a filesystem-consistent backup method before archiving the volume.

## Ollama

Ollama stores models in the `aibrain_ollama` external volume. Pull models after the service is running:

```bash
./manage.sh exec ollama ollama pull llama3.1
```
