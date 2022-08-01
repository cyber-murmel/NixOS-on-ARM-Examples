# [NixOS](https://nixos.org/) on ARM Examples
Examples of Nix expressions for cross compiling NixOS images for ARM

## Customizing
If you want to setup wireless networking, public SSH keys or the like, copy `custom.nix.template` to `custom.nix` and edit its content to your requirements.

## Building
Set `MACHINE` to the desired value and run the command as shown below.
```bash
export MACHINE=foobar
# use submodule
export NIXPKGS=$PWD/nixpkgs
nix-build -I nixpkgs=$NIXPKGS -I machine=machines/$MACHINE --out-link out-links/$MACHINE
```
### Boards
`MACHINE` can be set to the name of any directory in `machines`.
| Board               | `MACHINE`          |
|---------------------|-----------------------|
| generic AArch64     | `generic-aarch64`     |
| generic ARMv7l      | `generic-armv7l-hf`   |
| ESPRESSObin         | `espressobin`         |
| Orange Pi Zero      | `orange-pi-zero`      |
| ROC-RK3328-CC       | `roc-rk3328-cc`       |
| Raspberry Pi Zero W | `raspberry-pi-zero-w` |
| Raspberry Pi 1      | `raspberry-pi-1`      |
| Raspberry Pi 2      | `raspberry-pi-2`      |
| Raspberry Pi 3      | `raspberry-pi-3`      |

#### Building All
Run this command to build images for all available boards. I just added this section to have something to copy and paste for a "release build".
```bash
export NIXPKGS=$PWD/nixpkgs
for machine in $(find machines -maxdepth 1 -mindepth 1 -type d)
do
    export MACHINE=$(basename $machine);
    nix-build -I nixpkgs=$NIXPKGS -I machine=machines/$MACHINE --out-link out-links/$MACHINE
done
```

## Flashing
```bash
# set correct path for SD card
export SD_CARD=/dev/sda
# inflate image, write to SD card and eject
sudo sh -c "zstd -dcf out-links/$MACHINE/sd-image/*.img.zst | sudo dd status=progress bs=64k iflag=fullblock oflag=direct of=$SD_CARD && sync && sudo eject $SD_CARD"
```

## First Steps
```bash
sudo nix-channel --update
```

## Attribution
- repo inspired by [**illegalprime**/nixos-on-arm](https://github.com/illegalprime/nixos-on-arm)
- **mirrexagon** wrote a Nix expressions for building [u-boot for the ESPRESSObin](https://github.com/mirrexagon/espressobin-nix)
- big thanks to **sternenseemann** for helping me with cross compilation
