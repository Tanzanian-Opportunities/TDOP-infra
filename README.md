# TDOP Infra

Docker Compose orchestration for the **Tanzania Digital Opportunity Platform (TDOP)**,
fronted by **Cloudflare** in production.

## Tech Stack

| Area | Technology |
|---|---|
| Orchestration | Docker Compose |
| Database | PostgreSQL 16 |
| Edge / CDN / DNS / WAF | Cloudflare |
| Local debugging | Adminer (dev only) |
| Helpers | PowerShell smoke-check scripts (`check_db.ps1`, `check_servers.ps1`) |

> The Nginx reverse-proxy/edge configuration is **not** part of this repository -
> it lives with the API it protects: [`TDOP-backend/nginx.conf`](https://github.com/Tanzanian-Opportunities/TDOP-backend/blob/develop/nginx.conf).
> The frontend container image uses its own `nginx.conf` from `TDOP-frontend`.

## Clone layout (important)

The Compose files build from `../TDOP-backend` and `../TDOP-frontend`, so the
component repositories must be cloned **as siblings in the same directory**:

```bash
git clone https://github.com/Tanzanian-Opportunities/TDOP-infra.git
git clone https://github.com/Tanzanian-Opportunities/TDOP-backend.git
git clone https://github.com/Tanzanian-Opportunities/TDOP-frontend.git
```

## Contents

| File | Purpose |
|---|---|
| `docker-compose.yml` | Full stack: PostgreSQL 16, backend, frontend, Adminer (dev only) |
| `docker-compose.dev.yml` | Development overrides (dev profile, dev JVM settings) |
| `.env.example` | Environment template — copy to `.env` (never commit `.env`) |
| `check_db.ps1` / `check_db.sql` | Dev helper: row-count smoke check against the local database |
| `check_servers.ps1` | Dev helper: smoke-check backend and frontend HTTP endpoints |

## Quick start

```bash
cd TDOP-infra
cp .env.example .env
# Edit .env: set POSTGRES_PASSWORD and JWT_SECRET (both required)
docker compose up -d --build
```

## Services

| Service | Port | Notes |
|---|---|---|
| `tdop-postgres` | 5432 | PostgreSQL 16, health-checked |
| `tdop-backend` | 8080 | Spring Boot API (`/api/v1`, health at `/api/v1/public/health`) |
| `tdop-frontend` | 3000 | React SPA served by the frontend Nginx image |
| `tdop-adminer` | 8082 | **Dev only — never deploy Adminer to production** |

Useful commands:

```bash
docker compose ps
docker compose logs tdop-backend
docker compose logs -f            # follow all logs
docker compose down                # stop
```

Deployment follows `TDOP-docs/Specs/DEPLOYMENT_CHECKLIST.md`.

## Cloudflare (production edge)

Cloudflare is part of the TDOP project and fronts the deployment in production:

| Concern | Cloudflare role |
|---|---|
| DNS | TDOP zone hosted on Cloudflare (proxied records for the app) |
| TLS | TLS termination at the edge; origin reached over HTTPS |
| CDN / cache | Static assets cached at the edge (respecting cache headers set by Nginx) |
| WAF / bot protection | Web application firewall and rate shielding in front of the API |
| Availability | Health-checked origin, global edge network |

Rules:
- Cloudflare settings are environment-specific and are **never** committed to the
  repository; they are managed in the Cloudflare dashboard/API with account
  credentials kept out of git (`.env` is git-ignored).
- Local development does not require Cloudflare - `docker compose up` works fully
  offline against `localhost`.
- The origin server runs the Compose stack plus the Nginx edge configuration from
  `TDOP-backend/nginx.conf` (rate limiting, `/api` `/ws` `/swagger-ui` proxying,
  security headers).

## Environment variables

Set in `.env` (see `.env.example`):

| Variable | Purpose |
|---|---|
| `POSTGRES_DB` / `POSTGRES_USER` / `POSTGRES_PASSWORD` | Database bootstrap (password required) |
| `JWT_SECRET` | Backend signing secret (required, 64-char random recommended) |

Rules: no secrets in the repository; `.env` is git-ignored; rotate immediately if a
secret leaks (`TDOP-docs/SECURITY.md`).

## License

MIT - see [`LICENSE`](https://github.com/Tanzanian-Opportunities/TDOP-docs/blob/develop/LICENSE) (single license of record, kept in `TDOP-docs`).

## Related

- [TDOP Docs](https://github.com/Tanzanian-Opportunities/TDOP-docs) — governance, specs, project management
- [TDOP Backend](https://github.com/Tanzanian-Opportunities/TDOP-backend) — Spring Boot REST API + Nginx edge config
- [TDOP Frontend](https://github.com/Tanzanian-Opportunities/TDOP-frontend) — React SPA
- [Project overview](https://github.com/Tanzanian-Opportunities/TDOP-docs/blob/develop/PROJECT_OVERVIEW.md) - repository map, stack, quick start
- [Kanban board](https://github.com/orgs/Tanzanian-Opportunities/projects/1) — task tracking
