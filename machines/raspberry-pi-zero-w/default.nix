{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;

  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
  ];

  sdImage.imageBaseName = lib.mkDefault "nixos-raspberry-pi-zero";

  boot = {
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 0;
      };
    };

    kernelPackages = pkgs.linuxPackages_rpi0;
    consoleLogLevel = lib.mkDefault 7;

    # prevent `modprobe: FATAL: Module ahci not found`
    initrd.availableKernelModules = pkgs.lib.mkForce [
      "mmc_block"
    ];
  };

  sdImage = {
    populateRootCommands = "";
    populateFirmwareCommands = with config.system.build; ''
      ${installBootLoader} ${toplevel} -d ./firmware
    '';
    firmwareSize = 64;
  };

  hardware = {
    # needed for wlan0 to work (https://github.com/NixOS/nixpkgs/issues/115652)
    enableRedistributableFirmware = pkgs.lib.mkForce false;
    firmware = with pkgs; [
      raspberrypiWirelessFirmware
    ];
  };
}
