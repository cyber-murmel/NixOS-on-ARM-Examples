{ config, pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi1;
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 1;
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

    # prefent zfs cross compilation error
    supportedFilesystems = lib.mkForce [ "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  };
}
