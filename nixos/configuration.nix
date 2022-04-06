{ config, pkgs, lib, ... }:
{
  boot.loader.grub.enable = false;

  environment.systemPackages = with pkgs; [
    libgpiod gpio-utils
    i2c-tools
    evtest
    screen
    vim
    (python39.withPackages(ps: with ps;[
      adafruit-pureio
      pyserial
      evdev
    ]))
  ];

  users = {
    extraGroups = {
      gpio = {};
    };
    extraUsers.nixos = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" "input" "dialout" "gpio" "i2c" ];
    };
  };

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  services = {
    getty.autologinUser = "nixos";
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
    udev = {
      extraRules = ''
        KERNEL=="gpiochip[0-9]*", GROUP="gpio", MODE="0660"
      '';
    };
  };

  hardware.i2c.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  system.stateVersion = "nixos-unstable";
}
