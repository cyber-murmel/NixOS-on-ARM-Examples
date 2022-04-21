{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;

  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
  ];

  sdImage.imageBaseName = "nixos-raspberry-pi-1";

  boot = {
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 1;
      };
    };

    kernelPackages = pkgs.linuxPackages_rpi1;
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
}
