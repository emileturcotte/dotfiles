#!/usr/bin/env bash
# Bootstrap the aura AUR helper (aura-bin) if not already installed.
set -euo pipefail

if command -v aura >/dev/null 2>&1; then
    echo "aura already present."
    exit 0
fi

echo "Installing build prerequisites (base-devel, git)..."
sudo pacman -S --needed --noconfirm base-devel git

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
git clone --depth 1 https://aur.archlinux.org/aura-bin.git "$tmp/aura-bin"
( cd "$tmp/aura-bin" && makepkg -si --noconfirm )
