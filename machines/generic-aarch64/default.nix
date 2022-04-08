{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.aarch64-multiplatform;

  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];

  sdImage.imageBaseName = lib.mkDefault "nixos-generic";

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
}
