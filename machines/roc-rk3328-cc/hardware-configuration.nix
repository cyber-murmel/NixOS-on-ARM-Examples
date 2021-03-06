{ config, pkgs, lib, ... }:
{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  systemd.services."hardware-setup" = {
    enable = true;
    script = ''
      # enable USB power (this is a hack compensating for the wrong device tree)
      ${pkgs.libgpiod}/bin/gpioset 1 26=1
      # initialize IR protocol handlers
      ${pkgs.v4l-utils.override{withGUI = false;}}/bin/ir-keytable -p rc-5 -p rc-5-sz -p jvc -p sony -p nec -p sanyo -p mce_kbd -p rc-6 -p sharp -p xmp -p imon -p rc-mm
    '';
    wantedBy = [ "default.target" ];
    serviceConfig = {
      RestartSec = 1;
      Restart = "on-failure";
    };
  };
}
