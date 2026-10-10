#!/usr/bin/env bash
# Installs this niri (+ optional Noctalia) config into ~/.config, backing up anything it replaces.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

backup() {
    if [ -e "$1" ] || [ -L "$1" ]; then
        mv "$1" "$1.bak-$STAMP"
        echo "  backed up $1 -> $1.bak-$STAMP"
    fi
}

echo "==> niri"
mkdir -p "$CFG/niri"
backup "$CFG/niri/config.kdl"
cp "$REPO/niri/config.kdl" "$CFG/niri/config.kdl"

if [ "${1:-}" != "--no-noctalia" ]; then
    echo "==> noctalia"
    mkdir -p "$CFG/noctalia"
    for f in colors.json plugins.json; do
        backup "$CFG/noctalia/$f"
        cp "$REPO/noctalia/$f" "$CFG/noctalia/$f"
    done
    backup "$CFG/noctalia/settings.json"
    sed "s#__HOME__#$HOME#g" "$REPO/noctalia/settings.json" > "$CFG/noctalia/settings.json"
fi

mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Pictures/Wallpapers"

echo
echo "Done. Next: run 'niri msg outputs' and edit the output blocks in $CFG/niri/config.kdl,"
echo "then validate with: niri validate"
