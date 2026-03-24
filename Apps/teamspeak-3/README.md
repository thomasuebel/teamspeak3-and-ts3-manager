# TeamSpeak 3 + ts3-manager

A Docker Compose setup for a self-hosted TeamSpeak 3 server with the [ts3-manager](https://github.com/joni1802/ts3-manager) web interface. Compatible with CasaOS, ZimaOS, and other Docker app stores via the included `app.json`.

## Services

| Service | Image | Description |
|---|---|---|
| `teamspeak-server` | `teamspeak:latest` | TeamSpeak 3 voice server |
| `teamspeak-manager` | `joni1802/ts3-manager:latest` | Web-based administration UI |

## Ports

| Port | Protocol | Description |
|---|---|---|
| `9987` | UDP | Voice (connect clients here) |
| `10011` | TCP | ServerQuery (raw TCP) |
| `10022` | TCP | ServerQuery (SSH) |
| `30033` | TCP | File transfer |
| `8080` | TCP | ts3-manager web UI |

## Getting Started

### 1. Accept the license

TeamSpeak requires explicit license acceptance. The `TS3SERVER_LICENSE=accept` environment variable in `docker-compose.yml` handles this. By deploying this stack you agree to the [TeamSpeak License Agreement](https://www.teamspeak.com/en/teamspeak3-server-license-agreement/).

### 2. Start the stack

```bash
docker compose up -d
```

### 3. Get the ServerQuery admin token

On first start, TeamSpeak generates a one-time admin token. Retrieve it from the container's logs:

```bash
docker logs teamspeak-server 2>&1 | grep token
```

### 4. Connect ts3-manager

Open `http://<your-host>:8080` in your browser and connect to the TeamSpeak server using:

- **Host:** `teamspeak-server` (internal Docker service name)
- **Port:** `10011`
- **Username:** `serveradmin`
- **Password/Token:** from step 3

### 5. Connect a TeamSpeak client

Use your host IP or domain and port `9987` (UDP) in your TeamSpeak client.

## Data

Server data (database, logs, uploaded files) is persisted to `/DATA/AppData/teamspeak3/server` on the host (via the bind mount on `/var/ts3server` inside the container). Uploaded files and channel/avatar icons are stored in the `files/` subdirectory within that path.

## File Transfers & Avatars

If clients cannot upload files or avatars, the cause is usually the server advertising its internal Docker IP for file transfer connections instead of the host IP. The `TS3SERVER_IP=0.0.0.0` environment variable forces the server to bind and advertise on all interfaces, making port `30033` reachable from outside the container.

If you are running behind a NAT or reverse proxy, you may need to set `TS3SERVER_IP` to your actual public or LAN IP address instead of `0.0.0.0`.

## ServerQuery SSH

TeamSpeak supports an SSH-based ServerQuery interface on port `10022` as a secure alternative to the raw TCP interface on port `10011`. SSH ServerQuery is enabled by default in this stack via the `TS3SERVER_QUERY_PROTOCOLS=raw,ssh` environment variable.

On first start with SSH enabled, the server generates an SSH host key at `/var/ts3server/ssh_host_rsa_key`. To connect via SSH ServerQuery:

```bash
ssh -p 10022 serveradmin@<your-host>
```

To disable SSH ServerQuery, change `TS3SERVER_QUERY_PROTOCOLS` to `raw`.

## License

MIT — see [LICENSE](LICENSE).

TeamSpeak is a product of TeamSpeak Systems GmbH and subject to its own [license agreement](https://www.teamspeak.com/en/teamspeak3-server-license-agreement/).

A big thank you to [Jonathan Francke](https://github.com/joni1802) for building and maintaining [ts3-manager](https://github.com/joni1802/ts3-manager), released under the MIT license.
