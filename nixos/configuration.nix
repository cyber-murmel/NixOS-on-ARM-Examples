{ config, pkgs, lib, ... }:
{
  imports = [
    ./gpio
    ./serial
    ./bluetooth
    ./sdr
  ];

  boot.loader.grub.enable = false;

  environment.systemPackages = with pkgs; [
    screen
    vim
    htop bottom
    git
    evtest
    (python3.withPackages(ps: with ps;[
      evdev
    ]))
  ];

  users = {
    extraUsers.nixos = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" "input" "dialout" "gpio" "i2c" "plugdev" ];
    };
  };

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  services = {
    #getty.autologinUser = "nixos";
    openssh = {
      enable = true;
      # enable password authentication if no public key is set
      passwordAuthentication = if config.users.extraUsers.nixos.openssh.authorizedKeys.keys == [] then true else false;
      permitRootLogin = "no";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  system.stateVersion = "nixos-unstable";
}
