#!/bin/sh
set -eu

machine=chuck-yeager-aft
marker='# Managed by omarchy-chuck-yeager-nix64'

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /path/to/Chuck-Yeager-game.d64" >&2
  exit 2
fi

disk_source=$1
if [ ! -f "$disk_source" ]; then
  echo "Game disk not found: $disk_source" >&2
  exit 1
fi

case "$disk_source" in
  *.[dD]64) ;;
  *) echo "Expected a Commodore 64 .d64 disk image" >&2; exit 1 ;;
esac

if ! command -v nix64 >/dev/null 2>&1; then
  echo "Install Nix64 first: https://github.com/nixfred/nix64#install" >&2
  exit 1
fi

config_root=${XDG_CONFIG_HOME:-"$HOME/.config"}
shelf=${NIX64_SHELF:-"$HOME/Nix64/shelf"}
if [ -n "${NIX64_HOME:-}" ]; then
  config_root=$NIX64_HOME/config
  shelf=${NIX64_SHELF:-"$NIX64_HOME/Nix64/shelf"}
fi
machine_file=$config_root/nix64/machines/$machine.toml

if [ -e "$machine_file" ] && ! grep -Fxq "$marker" "$machine_file"; then
  echo "An existing Nix64 machine uses the name $machine. Move it before setup." >&2
  exit 1
fi

hash=$(sha256sum "$disk_source" | cut -d ' ' -f 1)
disk_name=chuck-yeager-${hash}.d64
mkdir -p "$shelf" "$(dirname "$machine_file")"
if [ ! -e "$shelf/$disk_name" ]; then
  cp "$disk_source" "$shelf/$disk_name"
fi

if [ -e "$machine_file" ]; then
  nix64 stop "$machine" >/dev/null
fi

cat > "$machine_file" <<EOF
$marker
name = "$machine"
description = "Chuck Yeager's Advanced Flight Trainer"
model = "c64c"
region = "pal"

[drive.8]
type = "1541-II"
mode = "image"
image = "shelf:$disk_name"
true_drive = true
EOF

nix64 switch "$machine"
echo "Game disk installed in Nix64. Run ./play.sh to start it."
