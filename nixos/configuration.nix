{ config, pkgs, lib, ... }:
let
  adafruit-blinka = pkgs.callPackage ./adafruit-blinka { };
in
{
  boot.loader.grub.enable = false;

  environment.systemPackages = with pkgs; [
    screen
    vim
    htop bottom
    git
    gpio-utils
    i2c-tools
    evtest
    (cwiid.overrideAttrs (oldAttrs: {
      # needed for cross compilation
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ bintools-unwrapped bison flex ];
    }))
    (python3.withPackages(ps: with ps;[
      adafruit-pureio
      adafruit-blinka
      pyserial
      evdev
      # quick fix for failing cross compilation
      (libgpiod.overrideAttrs (oldAttrs: {
        pname = "${python.libPrefix}-gpiod";

        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ python3 ];

        postInstall = ''
          ${oldAttrs.postInstall or ""}
          # for pythonImportsCheck
          export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
        '';

        pythonImportsCheck = [ "gpiod" ];
      }))
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
    #getty.autologinUser = "nixos";
    openssh = {
      enable = true;
      # enable password authentication if no public key is set
      passwordAuthentication = if config.users.extraUsers.nixos.openssh.authorizedKeys.keys == [] then true else false;
      permitRootLogin = "no";
    };
    udev = {
      extraRules = ''
        KERNEL=="gpiochip[0-9]*", GROUP="gpio", MODE="0660"
      '';
    };
  };

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  system.stateVersion = "nixos-unstable";
}
