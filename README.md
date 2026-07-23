# Medusa Project — Nuxt Storefront + Medusa v2 Backend (Docker)

A reproduction of [nuxt-starter-medusa](https://github.com/OlivierBelaud/nuxt-starter-medusa) running entirely in Docker, with a Medusa v2 backend ([medusa-starter-default](https://github.com/medusajs/medusa-starter-default)).

Built & tested on **Windows 10 + PowerShell + Docker Desktop (WSL2 backend)**.

## Architecture

```
medusa-project/
├── medusa-backend/          # Medusa v2 backend (API + Admin Dashboard)
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── .npmrc                # pnpm hoist config (REQUIRED for Medusa Admin)
│   ├── .env
│   ├── start.sh              # migrate -> seed -> dev server
│   └── medusa-config.ts
├── nuxt-storefront/          # Nuxt 3 storefront
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── .npmrc                # pnpm hoist config (REQUIRED for @nuxt/ui + Tailwind v4)
│   └── .env
├── docker-compose.yml
└── README.md
```

| Service           | Image/Build         | Port(s)             | Purpose                            |
|--------------------|---------------------|----------------------|------------------------------------|
| `postgres`         | postgres:15-alpine  | 5432                 | Medusa database                    |
| `redis`            | redis:7-alpine      | 6379                 | Medusa cache & event bus           |
| `medusa-backend`   | custom build         | 9000, 7001, 5173     | API + Admin Dashboard + Vite HMR   |
| `nuxt-storefront`  | custom build         | 3000                 | Storefront (shop)                  |

## Prerequisites

- Docker Desktop (WSL2 backend) — already running
- Git, with `core.autocrlf` set to `input` (**important on Windows**, so that `.sh` files don't get their line endings mangled):
  ```powershell
  git config --global core.autocrlf input
  ```

## Running from scratch

```powershell
cd medusa-project
docker compose up --build -d
```

Wait for the build + migration + seed process to finish (can take 5-15 minutes on the first run). Watch the progress:

```powershell
docker compose logs -f medusa-backend
```

Wait until you see:
```
✔ Server is ready on port: 9000
info: Admin URL → http://localhost:9000/app
```

### Create an admin user

```powershell
docker compose exec medusa-backend sh -c "pnpm medusa user -e admin@example.com -p supersecret"
```

### Log in to the Admin Dashboard

`http://localhost:9000/app` → log in with the email/password above.

### Get the Publishable API Key

If the seed data (`pnpm run seed`) ran successfully, a key is created automatically. Check it under:
**Settings → Publishable API Keys** in the Admin Dashboard, then copy the `pk_...` value.

Put it into `nuxt-storefront/.env`:
```env
NUXT_PUBLIC_MEDUSA_BACKEND_URL=http://medusa-backend:9000
NUXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_xxxxxxxxxxxxx
```

Then restart the storefront:
```powershell
docker compose up -d --force-recreate nuxt-storefront
```

### Check the storefront

`http://localhost:3000` — you should now see the sample products from the seed data.

## Everyday commands

```powershell
# Check status of all containers
docker compose ps

# Follow live logs (backend / frontend)
docker compose logs -f medusa-backend
docker compose logs -f nuxt-storefront

# Restart a single service after changing .env
docker compose up -d --force-recreate <service-name>

# Full rebuild of a single service (after changing Dockerfile/.npmrc/package.json)
docker compose stop <service-name>
docker compose rm -f -v <service-name>
docker compose build --no-cache <service-name>
docker compose up -d <service-name>

# Stop all containers (data is preserved in volumes)
docker compose down

# Stop and wipe all data (full reset, including the database)
docker compose down -v
```

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `read-only file system` during build/pull | WSL2 Docker virtual disk corrupted/stuck | `wsl --shutdown`, wait, reopen Docker Desktop, retry. If it still fails: Docker Desktop → Settings → Troubleshoot → Clean/Purge data |
| `./start.sh: not found` | `.sh` file was saved with CRLF instead of LF | Convert to LF, or re-clone after setting `core.autocrlf input` |
| `dependencies... could not be resolved` (`@medusajs/dashboard`, etc.) in the backend | pnpm didn't hoist the packages Medusa Admin needs | Make sure `.npmrc` (`public-hoist-pattern[]=*@medusajs/*` etc.) is `COPY`'d into the image **before** `RUN pnpm install` in the Dockerfile |
| `Can't resolve 'tailwindcss'` / 500 error on the storefront | `@nuxt/ui` v3 uses Tailwind v4 as a nested dependency, pnpm doesn't hoist it | Make sure `.npmrc` (`shamefully-hoist=true`) is `COPY`'d **before** `RUN pnpm install` in the frontend Dockerfile |
| Error persists even after fixing `.npmrc` | Old `node_modules` anonymous volume is still being used | `docker compose rm -f -v <service>` (the `-v` flag removes the volume), then rebuild |
| `Countries with codes "..." are already assigned to a region` when running `pnpm run seed` | Seed data was partially inserted previously (an earlier seed run failed midway) | Reset the database: `docker compose down`, `docker volume rm medusa-project_postgres_data`, `docker compose up -d` |
| HMR websocket fails to connect in the Admin Dashboard | Vite HMR client port doesn't match when running inside Docker | Set `admin.vite` in `medusa-config.ts` with explicit `hmr.port`/`hmr.clientPort`, and expose that port (5173) in `docker-compose.yml` |
| Repeated 503 errors when first opening the storefront | Vite/Nitro is still compiling/warming up, especially after a large install | Wait 10-20 seconds, then refresh the browser |

## Important note on pnpm + Docker

There are two `.npmrc` files in this project (one in `medusa-backend/`, one in `nuxt-storefront/`) because pnpm, by default, does **not** hoist nested/peer dependencies to the root `node_modules` — unlike npm/yarn. Both the Medusa Admin Dashboard and `@nuxt/ui` v3 (Tailwind CSS v4) need their packages to be resolvable directly from the root, so hoisting must be enabled.

**The `COPY` order in each `Dockerfile` is critical**: `.npmrc` must be copied into the image **before** `RUN pnpm install` runs — otherwise hoisting won't take effect at all, even if the file's contents are correct.

## Backend REST API

Medusa v2 exposes two separate REST API groups from the backend, both served from the same base URL (`http://localhost:9000` in this setup, or `http://<VM-IP>:9000` after deployment):

| API group | Prefix | Audience | Auth method |
|---|---|---|---|
| **Store API** | `/store/*` | Storefront, customer-facing apps | Publishable API key (`x-publishable-api-key` header) + optional customer JWT/session cookie |
| **Admin API** | `/admin/*` | Admin Dashboard, back-office tools | JWT bearer token or session cookie (from admin login) |

Full, always-up-to-date references:
- Store API: https://docs.medusajs.com/api/store
- Admin API: https://docs.medusajs.com/api/admin

### Store API

Every request to `/store/*` must include the publishable API key created earlier (see [Get the Publishable API Key](#get-the-publishable-api-key)):

```
x-publishable-api-key: pk_xxxxxxxxxxxxx
```

Common endpoints used by `nuxt-storefront`:

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | `/store/products` | List products (supports `limit`, `offset`, `region_id`, `q`, etc.) |
| `GET` | `/store/products/:id` | Get a single product |
| `GET` | `/store/regions` | List regions (needed for pricing/currency) |
| `GET` | `/store/product-categories` | List product categories |
| `POST` | `/store/carts` | Create a cart |
| `GET` | `/store/carts/:id` | Retrieve a cart |
| `POST` | `/store/carts/:id/line-items` | Add an item to a cart |
| `POST` | `/store/carts/:id/complete` | Complete checkout / place order |
| `POST` | `/store/auth/customer/emailpass/register` | Register a customer |
| `POST` | `/store/auth/customer/emailpass` | Log in a customer (returns a JWT) |

Example — list products:

```bash
curl http://localhost:9000/store/products \
  -H "x-publishable-api-key: pk_xxxxxxxxxxxxx"
```

Example — create a cart (requires a `region_id`, obtained from `GET /store/regions` first):

```bash
curl -X POST http://localhost:9000/store/carts \
  -H "x-publishable-api-key: pk_xxxxxxxxxxxxx" \
  -H "Content-Type: application/json" \
  -d '{"region_id": "reg_xxxxxxxxxxxxx"}'
```

### Admin API

Requests to `/admin/*` require an authenticated session. Log in first to get a JWT, then send it as a Bearer token on subsequent requests:

```bash
# 1. Log in, capture the token
curl -X POST http://localhost:9000/auth/user/emailpass \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@example.com", "password": "supersecret"}'

# Response: { "token": "eyJhbGciOi..." }

# 2. Use the token on admin requests
curl http://localhost:9000/admin/products \
  -H "Authorization: Bearer eyJhbGciOi..."
```

Common endpoints:

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | `/admin/products` | List/manage products |
| `POST` | `/admin/products` | Create a product |
| `GET` | `/admin/orders` | List orders |
| `GET` | `/admin/customers` | List customers |
| `GET` | `/admin/regions` | Manage regions |
| `GET` | `/admin/sales-channels` | Manage sales channels |
| `GET` | `/admin/api-keys` | Manage publishable/secret API keys

## References

- [Medusa Docs — Docker Installation](https://docs.medusajs.com/learn/installation/docker)
- [Medusa Docs — pnpm Configuration](https://docs.medusajs.com/learn/configurations/pnpm)
- [nuxt-starter-medusa (original repo)](https://github.com/OlivierBelaud/nuxt-starter-medusa)
- [medusa-starter-default (original repo)](https://github.com/medusajs/medusa-starter-default)
