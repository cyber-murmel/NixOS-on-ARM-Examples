{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.armv7l-hf-multiplatform;

  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
  ];

  sdImage.imageBaseName = "nixos-raspberry-pi-2";

  boot = {
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 2;
        firmwareConfig = ''
          dtparam=i2c=on
        '';
      };
    };

    kernelPackages = pkgs.linuxPackages_rpi2;
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
