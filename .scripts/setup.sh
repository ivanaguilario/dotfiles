#!/bin/sh

set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
SOURCE_FILE="$REPO_ROOT/gnupg/gpg-agent.conf"
TARGET_DIR="$HOME/.gnupg"
TARGET_FILE="$TARGET_DIR/gpg-agent.conf"

if [ "$(uname -s)" != "Darwin" ]; then
  printf 'This setup is intended for macOS only.\n' >&2
  exit 1
fi

if [ ! -f "$SOURCE_FILE" ]; then
  printf 'Missing source file: %s\n' "$SOURCE_FILE" >&2
  exit 1
fi

if ! command -v pinentry-mac >/dev/null 2>&1; then
  printf 'pinentry-mac is not installed. Install it with: brew install pinentry-mac\n' >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
chmod 700 "$TARGET_DIR"

if [ -e "$TARGET_FILE" ] && [ ! -L "$TARGET_FILE" ]; then
  printf 'Refusing to replace existing non-symlink: %s\n' "$TARGET_FILE" >&2
  exit 1
fi

ln -sfn "$SOURCE_FILE" "$TARGET_FILE"

if command -v gpgconf >/dev/null 2>&1; then
  gpgconf --kill gpg-agent
  gpgconf --launch gpg-agent
fi

printf 'Linked %s -> %s\n' "$TARGET_FILE" "$SOURCE_FILE"
