{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.armv7l-hf-multiplatform;

  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix>
  ];

  sdImage.imageBaseName = "nixos-orange-pi-zero";

  nixpkgs.config.allowUnfree = true;
  sdImage.postBuildCommands = with pkgs; ''
    dd if=${ubootOrangePiZero}/u-boot-sunxi-with-spl.bin of=$img conv=fsync,notrunc bs=1024 seek=8
  '';
}
