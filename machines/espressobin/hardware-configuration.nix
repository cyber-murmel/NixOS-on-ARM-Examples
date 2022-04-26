{ config, pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    kernelParams = [
      "console=ttyMV0,115200n8"
    ];
  };
}
