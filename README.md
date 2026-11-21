# Chuck Yeager's Advanced Flight Trainer on Omarchy and Nix64

Run a user-supplied Commodore 64 disk image of Chuck Yeager's Advanced Flight Trainer in [Nix64](https://github.com/nixfred/nix64) on [Omarchy](https://omarchy.org/). This project supplies a Nix64 machine configuration and launch scripts. It does not include the game.

## Requirements

- Omarchy on an x86-64 computer or VM
- Nix64 and its patched VICE engine, installed using the [upstream instructions](https://github.com/nixfred/nix64#install)
- Your own `.d64` disk image of the Commodore 64 game

## Set up and play

```sh
git clone https://github.com/MaverickKB/omarchy-chuck-yeager-nix64.git
cd omarchy-chuck-yeager-nix64
./setup.sh "/path/to/Chuck Yeager's Advanced Flight Trainer.d64"
./play.sh
```

`setup.sh` copies the disk to your Nix64 shelf with a name derived from its SHA-256 hash, creates a PAL C64C with a 1541-II drive, and records a Nix64 generation. It leaves your original disk file alone. `play.sh` starts a fresh C64, loads the first program from drive 8, runs it, and opens the Nix64 window. The first load may take a few minutes. Nix64 handles the keyboard and joystick; the game uses **joystick port 2**.

On the tested Eagle Soft disk, press Space when the Eagle Soft intro appears. In Nix64 Settings, enable **Keys as a joystick** so arrow keys and Space drive joystick port 2. Use those keys to select a flight mode at the game menu. Intro Flight reaches the cockpit.

For a remote browser client, `./play.sh --no-window` runs the game without opening Chromium inside Omarchy. The Nix64 server still needs to be started separately with `nix64 serve`.

To use a different disk image, run `./setup.sh` again with its path, then `./play.sh`.

## Game and rights

The game was published by Electronic Arts in 1987. [This game information page](https://pirates.emucamp.com/a/c/chuckyeager/c64/main.html) lists the Commodore 64 edition and its controls. The repository contains no game image, game code, crack, ROM, or artwork. Supply a copy you have the right to use.

## Tested path

The setup and play scripts were tested on Omarchy 4.5.0 with Nix64 built from source. An Eagle Soft Inc. `.d64` reached the game menu and Intro Flight cockpit using a PAL C64C and true 1541-II drive emulation. The scripts are shell code under the MIT license; Nix64 and the game retain their own licenses.
