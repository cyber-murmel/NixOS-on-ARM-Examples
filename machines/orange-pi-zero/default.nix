{ config, pkgs, lib, ... }:
{
  imports = [
    ../generic-armv7l-hf
  ];

  sdImage.imageBaseName = lib.mkDefault "nixos-orange-pi-zero";

  sdImage.postBuildCommands = with pkgs; ''
    dd if=${ubootOrangePiZero}/u-boot-sunxi-with-spl.bin of=$img conv=fsync,notrunc bs=1024 seek=8
  '';
}
