# [NixOS](https://nixos.org/) on ARM Examples
Examples of Nix expressions for cross compiling NixOS images for ARM

## Customizing
If you want to setup wireless networking, public SSH keys or the like, copy `custom.nix.template` to `custom.nix` and edit its content to your requirements.

## Building
Set `BOARD_TYPE` to the desired value and run the command as shown below.
```bash
$ export BOARD_TYPE=foobar
# nixpkgs pinned to master as of Thu Mar 31 08:01:29 2022 -0700
$ export NIXPKGS="https://github.com/NixOS/nixpkgs/archive/3e481ad.tar.gz"
$ nix-build -I nixpkgs=$NIXPKGS -I machine=machines/$BOARD_TYPE --out-link out-links/$BOARD_TYPE
```
### Boards
`BOARD_TYPE` can be set to the name of any directory in `machines`.
| Board               | `BOARD_TYPE`          |
|---------------------|-----------------------|
| generic AArch64     | `generic-aarch64`     |
| generic ARMv7l      | `generic-armv7l-hf`   |
| ESPRESSObin         | `espressobin`         |
| Orange Pi Zero      | `orange-pi-zero`      |
| ROC-RK3328-CC       | `roc-rk3328-cc`       |
| Raspberry Pi Zero W | `raspberry-pi-zero-w` |

#### Building All
Run this command to build images for all available boards. I just added this section to have something to copy and paste for a "release build".
```bash
$ export NIXPKGS=https://github.com/NixOS/nixpkgs/archive/3e481ad.tar.gz
$ for machine in $(find machines -maxdepth 1 -mindepth 1 -type d)
do
    export BOARD_TYPE=$(basename $machine);
    nix-build -I nixpkgs=$NIXPKGS -I machine=machines/$BOARD_TYPE --out-link out-links/$BOARD_TYPE
done
```

## Flashing
```bash
# set correct path for SD card
export SD_CARD=/dev/sda
# inflate image and write to SD card
zstd -dcf out-links/$BOARD_TYPE/sd-image/*.img.zst | sudo dd status=progress bs=64k iflag=fullblock oflag=direct of=$SD_CARD && sync && sudo eject $SD_CARD
```

## Attribution
- repo inspired by [**illegalprime**/nixos-on-arm](https://github.com/illegalprime/nixos-on-arm)
- **mirrexagon** wrote a Nix expressions for building [u-boot for the ESPRESSObin](https://github.com/mirrexagon/espressobin-nix)
- big thanks to **sternenseemann** for helping me with cross compilation
