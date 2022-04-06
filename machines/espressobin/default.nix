{ config, pkgs, lib, ... }:
{
  imports = [
    ../generic-aarch64
  ];

  boot.kernelParams = [
    "console=ttyMV0,115200n8"
  ];
}
