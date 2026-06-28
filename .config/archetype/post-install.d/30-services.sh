#!/usr/bin/env bash
# Enable services and group memberships for installed tools.
# Runs after 20-heavy-packages, so the tools exist; each step is guarded and
# idempotent, so trimming the package list or re-running is safe.
set -uo pipefail

# Docker: start the daemon and let the user run it without sudo.
if command -v docker >/dev/null 2>&1; then
    echo "Enabling docker.service..."
    sudo systemctl enable --now docker.service

    if ! id -nG "$USER" | grep -qw docker; then
        echo "Adding $USER to the 'docker' group (re-login required to take effect)..."
        sudo usermod -aG docker "$USER"
    fi
fi
