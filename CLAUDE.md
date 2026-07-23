# Project Context for Claude

This file gives Claude (or any AI assistant) the background needed to work on this project without re-explaining the setup from scratch.

## What this project is

A learning reproduction of [nuxt-starter-medusa](https://github.com/OlivierBelaud/nuxt-starter-medusa) (a Nuxt 3 ecommerce storefront) paired with a [medusa-starter-default](https://github.com/medusajs/medusa-starter-default) backend (Medusa v2, an open-source Shopify alternative). Everything runs in Docker on Windows 10 (PowerShell + Docker Desktop with WSL2 backend).


## Stack

- **Backend**: Medusa v2 (`@medusajs/medusa` 2.16.x), Node 20, pnpm, PostgreSQL 15, Redis 7
- **Frontend**: Nuxt 3, `@nuxt/ui` v3 (Tailwind CSS v4 under the hood), pnpm, Vite
- **Orchestration**: Docker Compose, 4 services (`postgres`, `redis`, `medusa-backend`, `nuxt-storefront`)

## Repository / directory layout

```
medusa-project/
├── medusa-backend/       # cloned from medusajs/medusa-starter-default
├── nuxt-storefront/      # cloned from OlivierBelaud/nuxt-starter-medusa
├── docker-compose.yml
├── README.md
└── CLAUDE.md              # this file
```

Both `medusa-backend/` and `nuxt-storefront/` are separate pnpm projects (not a monorepo/workspace). Each has its own `Dockerfile`, `.npmrc`, and `.env`.

## Design decisions worth knowing

1. **pnpm was chosen deliberately** because `nuxt-starter-medusa` ships with a `pnpm-lock.yaml`. The backend (`medusa-starter-default`) defaults to yarn, but was switched to pnpm for consistency across both services.

2. **Two separate `.npmrc` files exist, and both are required**:
   - `medusa-backend/.npmrc` — `public-hoist-pattern[]` entries for `@medusajs/*`, `@tanstack/react-query`, `react-i18next`, `react-router-dom`. Without this, the Medusa Admin Dashboard (which is a Vite app served by the backend) fails with `Failed to resolve import "@medusajs/dashboard"`.
   - `nuxt-storefront/.npmrc` — `shamefully-hoist=true`. Without this, `@nuxt/ui` v3's nested Tailwind CSS v4 dependency (`tailwindcss`, `@tailwindcss/vite`) can't be resolved by Vite, causing a 500 error (`Can't resolve 'tailwindcss'`) on every page.
   - **Root cause in both cases**: pnpm's strict, non-flat `node_modules` structure doesn't hoist nested/peer dependencies to the root by default, unlike npm/yarn.

3. **`COPY` order in both Dockerfiles matters a lot.** `.npmrc` must be copied into the image *before* `RUN pnpm install` runs, or the hoist config has no effect (pnpm reads `.npmrc` at install time, not at runtime). The original Dockerfiles copied `.npmrc` too late (via a later `COPY . .`), which caused the two hoisting bugs above to resurface even after the `.npmrc` files were "correct."

4. **Anonymous volumes for `node_modules` can go stale.** `docker-compose.yml` uses:
   ```yaml
   volumes:
     - ./medusa-backend:/server
     - /server/node_modules   # anonymous volume
   ```
   This means `node_modules` persists independently of image rebuilds. After fixing a Dockerfile/`.npmrc` issue, `docker compose build` alone is *not* enough — the stale volume must be removed with `docker compose rm -f -v <service>` before rebuilding, or the old broken `node_modules` will still be mounted into the new container.

5. **Vite HMR needs an explicit port when containerized.** The Medusa Admin Dashboard's dev server (Vite in middleware mode) tried to open a WebSocket on a port not exposed by Docker, causing `ERR_CONNECTION_REFUSED` in the browser. Fixed by setting `admin.vite` in `medusa-config.ts`:
   ```ts
   admin: {
     vite: (config) => ({
       server: {
         host: "0.0.0.0",
         allowedHosts: ["localhost", ".localhost", "127.0.0.1"],
         hmr: { port: 5173, clientPort: 5173 },
       },
     }),
   },
   ```
   and exposing port `5173` in `docker-compose.yml`.

6. **Seed script (`pnpm run seed`) is run automatically on every container start** via `start.sh` (`migrate → seed → dev`), with the seed step wrapped in `|| echo "..."` so a seed failure doesn't crash the container. This caused a subtle bug: a partially-successful seed run (regions created, then failed on a later step) left the database in a state where re-running `pnpm run seed` manually failed with `Countries with codes "..." are already assigned to a region`. Fixed by fully resetting the Postgres volume (`docker volume rm medusa-project_postgres_data`) and letting `start.sh` seed a clean database.

## Known environment quirks (Windows + Docker Desktop)

- Docker Desktop's WSL2 virtual disk can intermittently flip to **read-only**, breaking `pnpm install`, `docker builder prune`, and any write inside containers, with no clear cause in the logs (not disk-space related in this case — `D:\` had 43GB free). Fix: `wsl --shutdown`, wait ~15s, restart Docker Desktop. If that fails, use Docker Desktop's "Clean / Purge data" option.
- `.sh` files (`start.sh`) must use **LF line endings**, not CRLF, or Alpine's shell fails with `not found`. Set `git config --global core.autocrlf input` before cloning, or convert manually.
- Docker's virtual disk defaults to `C:\`; it can be relocated to another drive via Docker Desktop → Settings → Resources → Advanced → Disk image location (or manually via `wsl --export` / `wsl --import` if the built-in migration hangs).

## Common tasks / commands

```powershell
# Full stack up
docker compose up --build -d

# Watch logs
docker compose logs -f medusa-backend
docker compose logs -f nuxt-storefront

# Create/reset admin user
docker compose exec medusa-backend sh -c "pnpm medusa user -e admin@example.com -p supersecret"

# Re-run seed manually (only safe on a fresh/empty DB — see known issue above)
docker compose exec medusa-backend sh -c "pnpm run seed"

# Full rebuild of one service after Dockerfile/.npmrc/package.json changes
docker compose stop <service>
docker compose rm -f -v <service>
docker compose build --no-cache <service>
docker compose up -d <service>

# Full reset (wipes DB too)
docker compose down -v
```

## Things to watch for in future changes

- If either `package.json` gains new Medusa Admin or Nuxt UI related dependencies, double-check whether the `.npmrc` hoist patterns need updating (backend uses explicit patterns, not `shamefully-hoist`, so new `@medusajs/*` sub-packages should already be covered, but non-`@medusajs` packages imported by the admin panel may need to be added explicitly).
- Any change to `Dockerfile` `COPY` order should keep `.npmrc` before `RUN pnpm install` in both services.
- After any Dockerfile change, remember the anonymous `node_modules` volume won't refresh on its own — use `rm -f -v` before rebuilding.
- Sample seed data (Medusa Sweatshirt, T-Shirt, Sweatpants, Shorts) is placeholder content, not real products — expect it to be replaced via the Admin Dashboard for anything beyond learning/testing.
