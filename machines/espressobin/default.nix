{ config, pkgs, lib, ... }:
{
  imports = [
    ../generic-aarch64
  ];

  sdImage.imageBaseName = lib.mkDefault "nixos-espressobin";

  boot.kernelParams = [
    "console=ttyMV0,115200n8"
  ];
}
