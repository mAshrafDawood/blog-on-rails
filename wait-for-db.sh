#!/bin/bash
set -e

# Ensure required environment variables are set.
: "${BLOG_ON_RAILS_PROD_DATABASE_HOST:?Environment variable BLOG_ON_RAILS_PROD_DATABASE_HOST not set}"
: "${BLOG_ON_RAILS_PROD_DATABASE_PORT:?Environment variable BLOG_ON_RAILS_PROD_DATABASE_PORT not set}"
: "${BLOG_ON_RAILS_PROD_DATABASE_USERNAME:?Environment variable BLOG_ON_RAILS_PROD_DATABASE_USERNAME not set}"
: "${BLOG_ON_RAILS_PROD_DATABASE_PASSWORD:?Environment variable BLOG_ON_RAILS_PROD_DATABASE_PASSWORD not set}"

echo "Waiting for PostgreSQL to be ready at ${BLOG_ON_RAILS_PROD_DATABASE_HOST}:${BLOG_ON_RAILS_PROD_DATABASE_PORT} ..."

# Optionally, export PGPASSWORD so pg_isready can use it for authentication.
export PGPASSWORD=${BLOG_ON_RAILS_PROD_DATABASE_PASSWORD}

# Loop until pg_isready confirms that PostgreSQL is available.
until pg_isready -h "$BLOG_ON_RAILS_PROD_DATABASE_HOST" -p "$BLOG_ON_RAILS_PROD_DATABASE_PORT" -U "$BLOG_ON_RAILS_PROD_DATABASE_USERNAME"; do
  echo "Postgres is unavailable - waiting..."
  sleep 2
done

echo "PostgreSQL is up and ready!"

# Execute the command passed as parameters to this script.
exec "$@"
