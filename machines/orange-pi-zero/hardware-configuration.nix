{ config, pkgs, lib, ... }:
let
  xradio = pkgs.callPackage ./xradio.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
  xr819-firmware = pkgs.callPackage ./xr819-firmware.nix { };
in
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = [
      "console=ttyMV0,115200n8"
    ];
    extraModulePackages = [ xradio ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ xr819-firmware ];
  };
}
