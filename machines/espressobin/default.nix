{ config, pkgs, lib, ... }:
{
  imports = [
    ../generic-aarch64
  ];

  sdImage.imageBaseName = "nixos-espressobin";

  boot.kernelParams = [
    "console=ttyMV0,115200n8"
  ];
}
