{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.aarch64-multiplatform;

  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
  ];

  sdImage = {
    imageBaseName = "nixos-raspberry-pi-3";
    populateRootCommands = "";
    populateFirmwareCommands = with config.system.build; ''
      ${installBootLoader} ${toplevel} -d ./firmware
    '';
    firmwareSize = 128;
  };
}
