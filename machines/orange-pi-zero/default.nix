{ config, pkgs, lib, ... }:
let
  xradio = pkgs.callPackage ./xradio.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
  xr819-firmware = pkgs.callPackage ./xr819-firmware.nix { };
in
{
  imports = [
    ../generic-armv7l-hf
  ];

  sdImage.imageBaseName = "nixos-orange-pi-zero";

  sdImage.postBuildCommands = with pkgs; ''
    dd if=${ubootOrangePiZero}/u-boot-sunxi-with-spl.bin of=$img conv=fsync,notrunc bs=1024 seek=8
  '';

  boot.extraModulePackages = [ xradio ];
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ xr819-firmware ];
}
