#!/bin/sh
cd /server

echo "Running database migrations..."
pnpm medusa db:migrate

echo "Seeding database..."
pnpm run seed || echo "Seeding failed or already seeded, continuing..."

echo "Starting Medusa development server..."
pnpm dev