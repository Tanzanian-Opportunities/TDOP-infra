# TDOP Infra

Docker Compose and Nginx orchestration for the **Tanzania Digital Opportunity Platform (TDOP)**.

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
| `nginx/nginx.conf` | Reverse-proxy configuration used by the frontend image |
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
| `tdop-frontend` | 3000 | React SPA behind Nginx |
| `tdop-adminer` | 8082 | **Dev only — never deploy Adminer to production** |

Useful commands:

```bash
docker compose ps
docker compose logs tdop-backend
docker compose logs -f            # follow all logs
docker compose down                # stop
```

Deployment follows `TDOP-docs/Specs/DEPLOYMENT_CHECKLIST.md`.

## Environment variables

Set in `.env` (see `.env.example`):

| Variable | Purpose |
|---|---|
| `POSTGRES_DB` / `POSTGRES_USER` / `POSTGRES_PASSWORD` | Database bootstrap (password required) |
| `JWT_SECRET` | Backend signing secret (required, 64-char random recommended) |

Rules: no secrets in the repository; `.env` is git-ignored; rotate immediately if a
secret leaks (`TDOP-docs/SECURITY.md`).

## Related

- [TDOP Docs](https://github.com/Tanzanian-Opportunities/TDOP-docs) — governance, specs, project management
- [TDOP Backend](https://github.com/Tanzanian-Opportunities/TDOP-backend) — Spring Boot REST API
- [TDOP Frontend](https://github.com/Tanzanian-Opportunities/TDOP-frontend) — React SPA
- [Umbrella index](https://github.com/Tanzanian-Opportunities/Tanzanian_Opportunities) — full project overview
- [Kanban board](https://github.com/orgs/Tanzanian-Opportunities/projects/1) — task tracking
