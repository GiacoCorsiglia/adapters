#!/usr/bin/env bash

npx supabase start

echo "Waiting 5 sec for db to start..." && sleep 5

docker exec \
-i "supabase-db" \
sh -c 'psql -h localhost -U postgres' < "$(pwd)/tests/empty.sql"

docker exec \
-i "supabase-db" \
sh -c 'psql -h localhost -U postgres' < "$(pwd)/supabase/schema.sql"

echo "Waiting 1 sec before running tests..." && sleep 1

# Always stop container, but exit with 1 when tests are failing
if npx jest;then
    npx supabase stop
else
    npx supabase stop && exit 1
fi
