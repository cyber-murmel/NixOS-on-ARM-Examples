{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.aarch64-multiplatform;

  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];

  nixpkgs.config.allowUnfree = true;
  sdImage = {
    imageBaseName = "nixos-roc-rk3328-cc";
    postBuildCommands = with pkgs; ''
      dd if=${ubootRock64}/idbloader.img of=$img conv=fsync,notrunc bs=512 seek=64
      dd if=${ubootRock64}/u-boot.itb of=$img conv=fsync,notrunc bs=512 seek=16384
    '';
  };
}
