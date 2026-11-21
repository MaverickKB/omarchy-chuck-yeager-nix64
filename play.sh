#!/bin/sh
set -eu

machine=chuck-yeager-aft
config_root=${XDG_CONFIG_HOME:-"$HOME/.config"}
if [ -n "${NIX64_HOME:-}" ]; then
  config_root=$NIX64_HOME/config
fi

if [ ! -f "$config_root/nix64/machines/$machine.toml" ]; then
  echo "Set up a game disk first: ./setup.sh /path/to/game.d64" >&2
  exit 1
fi

for command in nix64 c64ctl; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "Missing $command. Install Nix64: https://github.com/nixfred/nix64#install" >&2
    exit 1
  fi
done

nix64 stop "$machine" >/dev/null
nix64 start "$machine"
c64ctl wait READY. --machine "$machine" --timeout 40 >/dev/null
c64ctl warp on --machine "$machine" >/dev/null
c64ctl line 'LOAD"*",8,1' --machine "$machine" >/dev/null

loaded=no
attempt=0
while [ "$attempt" -lt 300 ]; do
  screen=$(c64ctl screen --machine "$machine")
  ready_count=$(printf '%s\n' "$screen" | grep -ic 'READY\.' || true)
  if [ "$ready_count" -ge 2 ]; then
    loaded=yes
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

if [ "$loaded" != yes ]; then
  c64ctl warp off --machine "$machine" >/dev/null
  echo "The game loader did not finish within 5 minutes. Check the Nix64 screen." >&2
  exit 1
fi

c64ctl line RUN --machine "$machine" >/dev/null
c64ctl warp off --machine "$machine" >/dev/null
echo "Game started. Press Space at the Eagle Soft intro, then use joystick port 2."
nix64
