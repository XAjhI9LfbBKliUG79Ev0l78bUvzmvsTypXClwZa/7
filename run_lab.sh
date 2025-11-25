#!/bin/bash
#
# Description:
# This script automates the setup of a legacy database lab exercise using modern,
# containerized tools. It uses Podman (rootless) and the official MariaDB/phpMyAdmin
# images to provide a stable, automated, and modernized solution as requested.
#
# Features:
# - Creates a Podman Pod to allow containers to communicate over localhost.
# - Launches the latest official MariaDB and phpMyAdmin containers.
# - Includes a robust readiness check to ensure the database is available.
# - Programmatically creates the database schema and seeds it with data.
# - Demonstrates a full backup and restore cycle.
# - Idempotent: Cleans up existing resources before running.
#
# Requirements:
# - Podman must be installed and running.
# - For rootless Podman, the user must have subuid/subgid ranges configured.
#   (e.g., sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER)
#

set -euo pipefail

# --- Configuration ---
POD_NAME="db-lab"
DB_CONTAINER_NAME="mariadb-container"
PMA_CONTAINER_NAME="pma-container"

# MariaDB Settings
DB_ROOT_PASSWORD="root"
DB_DATABASE="book"

# phpMyAdmin Settings
PMA_HOST_PORT=8080

# --- Helper Functions ---
info() {
    echo " INFO: $1"
}

cleanup() {
    info "--- Starting Cleanup ---"
    if podman pod exists "$POD_NAME"; then
        info "Tearing down existing '$POD_NAME' pod..."
        podman pod rm -f "$POD_NAME"
    else
        info "No existing pod found. Skipping cleanup."
    fi
    rm -f backup.sql
    info "--- Cleanup Complete ---"
    echo
}

wait_for_db() {
    info "Waiting for MariaDB to be ready..."
    for i in {1..60}; do
        if podman exec "$DB_CONTAINER_NAME" mysql -u root -p"$DB_ROOT_PASSWORD" -e "SELECT 1" &> /dev/null; then
            info "MariaDB is ready!"
            return 0
        fi
        echo -n "."
        sleep 1
    done
    echo # Newline
    info "ERROR: MariaDB did not become ready in time."
    exit 1
}

# --- Main Logic ---

# Handle cleanup as a command-line argument
if [[ "${1:-}" == "cleanup" ]]; then
    cleanup
    exit 0
fi

# 1. Cleanup previous runs
cleanup

# 2. Infrastructure Setup (Podman)
info "--- Step 1: Infrastructure Setup ---"
info "Creating pod '$POD_NAME'..."
podman pod create --name "$POD_NAME" -p "${PMA_HOST_PORT}:80"

info "Launching MariaDB container inside the pod..."
podman run -d --pod "$POD_NAME" \
    --name "$DB_CONTAINER_NAME" \
    -e MARIADB_ROOT_PASSWORD="$DB_ROOT_PASSWORD" \
    -e MARIADB_DATABASE="$DB_DATABASE" \
    docker.io/library/mariadb:latest

info "Launching phpMyAdmin container inside the pod..."
podman run -d --pod "$POD_NAME" \
    --name "$PMA_CONTAINER_NAME" \
    -e PMA_HOST=localhost \
    docker.io/phpmyadmin:latest

info "Containers are running:"
podman ps --pod

# 3. Wait for DB and then Seed
wait_for_db

echo
info "--- Step 2 & 3: Database Schema and Data Seeding ---"

podman exec -i "$DB_CONTAINER_NAME" mysql -u root -p"$DB_ROOT_PASSWORD" <<EOF
USE ${DB_DATABASE};

ALTER DATABASE ${DB_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS user;

CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    login VARCHAR(15) NOT NULL,
    password VARCHAR(15) NOT NULL,
    name VARCHAR(15),
    surname VARCHAR(255),
    birthday DATE,
    email VARCHAR(30),
    description TEXT,
    photo BLOB,
    datecreate DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO user (login, password, name, surname, birthday, email, description, datecreate) VALUES
('jdoe', 'pass123', 'John', 'Doe', '1990-05-15', 'j.doe@example.com', 'A test user account.', NOW()),
('asmith', 'pass456', 'Alice', 'Smith', '1988-11-22', 'a.smith@example.com', 'Another test user.', NOW()),
('bgates', 'pass789', 'Bill', 'Gates', '1955-10-28', 'b.gates@microsoft.com', 'A technology pioneer.', NOW());

SELECT login, name, surname, email FROM user;
EOF

echo
info "--- Step 4: Backup & Restore Simulation ---"

info "Dumping '${DB_DATABASE}' database to backup.sql..."
podman exec "$DB_CONTAINER_NAME" mysqldump -u root -p"$DB_ROOT_PASSWORD" "$DB_DATABASE" > backup.sql
info "Backup file 'backup.sql' created on the host."

info "Dropping the '${DB_DATABASE}' database..."
podman exec "$DB_CONTAINER_NAME" mysql -u root -p"$DB_ROOT_PASSWORD" -e "DROP DATABASE ${DB_DATABASE};"
info "Database dropped. Verifying..."
podman exec "$DB_CONTAINER_name" mysql -u root -p"$DB_ROOT_PASSWORD" -e "SHOW DATABASES;"

info "Restoring the database from backup.sql..."
cat backup.sql | podman exec -i "$DB_CONTAINER_NAME" mysql -u root -p"$DB_ROOT_PASSWORD" "$DB_DATABASE"
info "Database restored. Verifying..."
podman exec "$DB_CONTAINER_NAME" mysql -u root -p"$DB_ROOT_PASSWORD" -e "SHOW TABLES FROM ${DB_DATABASE};"

echo
info "--- Lab Setup Complete ---"
info "You can now access phpMyAdmin at: http://localhost:${PMA_HOST_PORT}"
info "Server: localhost"
info "Username: root"
info "Password: ${DB_ROOT_PASSWORD}"
echo
info "To stop and remove all resources, run:"
info "bash run_lab.sh cleanup"
echo
