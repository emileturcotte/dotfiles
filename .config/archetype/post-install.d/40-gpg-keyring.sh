#!/usr/bin/env bash
# Set up the GnuPG keyring for commit signing with a YubiKey.
#
# The signing key's secret half lives on the YubiKey and never touches disk, so
# there's nothing to import there. What gpg needs locally is the PUBLIC key plus
# a secret-key "stub" pointing at the card — the stub is created automatically by
# `gpg --card-status` once the public key is present. This script:
#   1. fixes the homedir permissions gpg insists on,
#   2. imports the public key (from the URL stored on the card, a keyserver, or a
#      local backup via ARCHETYPE_GPG_PUBKEY),
#   3. runs --card-status to generate the on-card stubs,
#   4. marks the key ultimately trusted.
# Idempotent: re-running is a no-op once the stub exists. Insert the YubiKey first.
set -uo pipefail

# KEY_ID is exported from .zshenv; fall back so the script still works standalone.
KEY_ID="${KEY_ID:-0x58605F08885C6901}"
GNUPGHOME="${GNUPGHOME:-$HOME/.config/gnupg}"
PUBKEY_FILE="${ARCHETYPE_GPG_PUBKEY:-}"
KEYSERVER="hkps://keys.openpgp.org"

gpg() { command gpg --homedir "$GNUPGHOME" "$@"; }

# gpg refuses to use a homedir that group/others can read.
echo "Securing GnuPG homedir permissions ($GNUPGHOME)..."
mkdir -p "$GNUPGHOME/private-keys-v1.d"
chmod 700 "$GNUPGHOME" "$GNUPGHOME/private-keys-v1.d"
find "$GNUPGHOME" -maxdepth 1 -type f -exec chmod 600 {} +

# Already linked to the card? A '>' in the secret-key listing means a card stub.
if gpg --list-secret-keys --with-colons "$KEY_ID" 2>/dev/null | grep -q '^ssb>'; then
    echo "Signing key already linked to the smartcard. Skipping."
    exit 0
fi

# Step 1: get the PUBLIC key into the keyring.
if ! gpg --list-keys "$KEY_ID" >/dev/null 2>&1; then
    if [[ -n "$PUBKEY_FILE" && -r "$PUBKEY_FILE" ]]; then
        echo "Importing public key from $PUBKEY_FILE..."
        gpg --import "$PUBKEY_FILE"
    else
        # The card records a public-key URL; prefer it, fall back to a keyserver.
        url="$(gpg --card-status 2>/dev/null | sed -n 's/^URL of public key \.*: //p')"
        if [[ -n "$url" ]] && command -v curl >/dev/null 2>&1; then
            echo "Fetching public key from card URL: $url"
            curl -fsSL "$url" | gpg --import
        fi
        if ! gpg --list-keys "$KEY_ID" >/dev/null 2>&1; then
            echo "Fetching public key from $KEYSERVER..."
            gpg --keyserver "$KEYSERVER" --recv-keys "$KEY_ID"
        fi
    fi
fi

if ! gpg --list-keys "$KEY_ID" >/dev/null 2>&1; then
    echo "Could not obtain the public key for $KEY_ID." >&2
    echo "Insert the YubiKey and ensure network access, or pass a backup:" >&2
    echo "    ARCHETYPE_GPG_PUBKEY=/path/to/pubkey.asc $0" >&2
    exit 0
fi

# Step 2: generate the on-card secret-key stubs (requires the YubiKey inserted).
echo "Linking smartcard (creating secret-key stubs)..."
if ! gpg --card-status >/dev/null 2>&1; then
    echo "No YubiKey detected — insert it and re-run to finish linking." >&2
    exit 0
fi

# Step 3: trust our own key ultimately so signing/verification doesn't warn.
# import-ownertrust needs the full fingerprint, not the key id — read it back.
fpr="$(gpg --with-colons --fingerprint "$KEY_ID" | awk -F: '/^fpr:/ {print $10; exit}')"
if [[ -n "$fpr" ]]; then
    echo "Setting ultimate ownertrust on $fpr..."
    echo "$fpr:6:" | gpg --import-ownertrust
fi

echo "GPG keyring ready. Verify with: gpg --list-secret-keys $KEY_ID  (expect 'ssb>')"
