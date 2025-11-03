#!/bin/bash
set -e

if [ -d /docker-entrypoint-initdb.d/db ]; then
    echo "[SUCCESS]: Located db directory"
    for sql_script in /docker-entrypoint-initdb.d/db/*.sql; do
        if [ -f "$sql_script" ]; then
            echo "[SUCCESS] Running SQL file: $sql_script"
            psql -U $POSTGRES_USER -d $POSTGRES_DB -f $sql_script
        else
            echo "[INFO] No SQL file found inside the db directory"
        fi
    done
else
    echo "[ERROR] Directory not found: /docker-entrypoint-initdb.d/db/"
fi

echo "[END] Database initialization complete"