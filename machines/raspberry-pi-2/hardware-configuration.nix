{ config, pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi2;
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
    consoleLogLevel = lib.mkDefault 7;

    # prevent `modprobe: FATAL: Module ahci not found`
    initrd.availableKernelModules = pkgs.lib.mkForce [
      "mmc_block"
    ];
  };
}
