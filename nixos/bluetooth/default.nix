{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    (cwiid.overrideAttrs (oldAttrs: {
      # needed for cross compilation
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ bintools-unwrapped bison flex ];
    }))
  ];

  hardware.bluetooth.enable = true;
}