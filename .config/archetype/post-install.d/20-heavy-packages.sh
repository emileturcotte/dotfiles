#!/usr/bin/env bash
# Install heavy GUI apps intentionally left out of the base ISO.
# Edit these lists to taste — re-running is safe (--needed skips installed pkgs).
set -uo pipefail

# Official-repo packages (installed with pacman).
REPO_PKGS=(
    emacs
)

# AUR packages (installed with aura — see 10-aur-helper.sh).
AUR_PKGS=(
    brave-bin
    slack-desktop
)

if [ "${#REPO_PKGS[@]}" -gt 0 ]; then
    echo "Repo packages: ${REPO_PKGS[*]}"
    sudo pacman -S --needed --noconfirm "${REPO_PKGS[@]}"
fi

if [ "${#AUR_PKGS[@]}" -gt 0 ]; then
    if ! command -v aura >/dev/null 2>&1; then
        echo "aura not found — the AUR helper (10-aur-helper.sh) did not complete." >&2
        echo "Run the full runner so aura is bootstrapped first: archetype-postinstall" >&2
        exit 1
    fi
    echo "AUR packages: ${AUR_PKGS[*]}"
    aura -A --noconfirm "${AUR_PKGS[@]}"
fi
