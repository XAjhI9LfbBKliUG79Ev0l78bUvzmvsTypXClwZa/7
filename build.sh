#!/bin/bash
# Install dependencies and format code
podman run --rm -v "$(pwd):/app" composer install
podman run --rm -v "$(pwd):/app" composer fix-style

podman build -t php-app .
