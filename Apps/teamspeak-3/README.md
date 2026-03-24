# app.json

`app.json` is a metadata file that makes the TeamSpeak 3 stack installable from Docker app stores and home lab platforms without any manual configuration. It describes the app — its ports, volumes, environment variables, and UI — in a format each platform understands.

The actual server definition lives in [`docker-compose.yml`](../../docker-compose.yml) at the repo root. `app.json` is a companion to it, not a replacement.

## What it's used for

When a platform installs from a GitHub release, it downloads `teamspeak-3.zip` which contains both `docker-compose.yml` and `app.json` together. The platform reads `app.json` to populate its UI (port labels, env var descriptions, icons, etc.) and uses `docker-compose.yml` to actually run the stack.

### Supported platforms

| Platform | How it uses app.json |
|---|---|
| CasaOS / ZimaOS | Reads `app.json` alongside the `x-casaos` extensions embedded in `docker-compose.yml` |
| Portainer | Uses `app.json` as an app template descriptor |
| Runtipi | Reads `app.json` for app metadata and configuration schema |
| Dockge | File-based; uses `docker-compose.yml` directly, `app.json` provides metadata |
| Cosmos | Uses `app.json` for ServApp routing and port configuration |
| Umbrel | Uses `app.json` as the app manifest |

## Keeping it in sync

When you change `docker-compose.yml` — adding a port, a volume, or an environment variable — update the corresponding entry in `app.json` to match. The fields that need staying in sync are:

- `deployment.ports` — mirrors the `ports:` section
- `deployment.volumes` — mirrors the `volumes:` section
- `deployment.environment_variables` — mirrors the `environment:` section
- `metadata.version` — the project release version (e.g. `1.0.1`), updated when cutting a new GitHub release
