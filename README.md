# Modernized Database Lab Automation (Podman Edition)

## Overview

This project provides a fully automated solution for a legacy database lab exercise, modernized to use **Podman** and **MariaDB**. It replaces the original manual setup (Denwer, MySQL 5, phpMyAdmin) with a single, executable bash script that handles all aspects of the lab, from infrastructure provisioning to data management.

The solution is designed to be idempotent, meaning it can be run multiple times without causing errors. It cleans up any previously created resources before starting.

## Features

-   **Podman-Native:** Uses Podman to create a rootless and secure environment.
-   **Pod Architecture:** Runs MariaDB and phpMyAdmin in a single Pod, allowing them to communicate over `localhost`.
-   **Automated:** A single script (`run_lab.sh`) handles all required tasks.
-   **Modernized:** Uses the latest official MariaDB image and `utf8mb4_unicode_ci` for character encoding.
-   **Programmatic:** All database operations (schema creation, data seeding, backup, restore) are performed via CLI commands, eliminating the need for manual GUI interaction.

## Prerequisites

-   **Podman:** You must have Podman installed and running.
-   **Rootless Configuration:** For rootless Podman to function correctly, your user account needs to have subuid and subgid ranges configured. You can typically set this up with the following command (logging out and back in may be required):
    ```bash
    sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER
    ```
-   **Bash:** A standard Unix-like shell (bash, zsh, etc.) is required to run the script.

## How to Run the Lab

1.  **Make the script executable:**
    Open your terminal and run the following command to give the script execution permissions:
    ```bash
    chmod +x run_lab.sh
    ```

2.  **Execute the script:**
    Run the script from your terminal:
    ```bash
    ./run_lab.sh
    ```
    The script will now perform all the necessary steps:
    -   Clean up any old pods.
    -   Create a Podman pod named `db-lab`.
    -   Launch the MariaDB and phpMyAdmin containers inside the pod.
    -   Wait for the database to be ready.
    -   Create the `book` database and `user` table.
    -   Insert 3 dummy records.
    -   Simulate a backup and restore cycle.

## Accessing phpMyAdmin

Once the script completes, you can access the phpMyAdmin web interface to view the database:

-   **URL:** `http://localhost:8080`
-   **Server:** `localhost` (since it's in the same pod)
-   **Username:** `root`
-   **Password:** `root`

## Cleaning Up

To stop the containers and remove all resources created by the script (pod, containers, and the `backup.sql` file), you can run the cleanup function within the script:

```bash
./run_lab.sh cleanup
```

This command will gracefully stop and remove the pod and all associated resources.
