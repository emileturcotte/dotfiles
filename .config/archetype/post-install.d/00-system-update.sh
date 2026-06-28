#!/usr/bin/env bash
# Refresh package databases and apply pending updates.
# Without this, freshly-referenced packages report "target not found".
set -euo pipefail

sudo pacman -Syu --noconfirm
