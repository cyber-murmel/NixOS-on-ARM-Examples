{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;

  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
  ];

  sdImage = {
    imageBaseName = "nixos-raspberry-pi-zero-w";
    populateRootCommands = "";
    populateFirmwareCommands = with config.system.build; ''
      ${installBootLoader} ${toplevel} -d ./firmware
    '';
    firmwareSize = 64;
  };
}
