#!/bin/bash
podman run -d -p 8080:80 --name php-app-container php-app
