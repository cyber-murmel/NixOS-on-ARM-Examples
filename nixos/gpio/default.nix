{ config, pkgs, lib, ... }:
let
  adafruit-blinka = pkgs.callPackage ./adafruit-blinka { };
in
{
  environment.systemPackages = with pkgs; [
    gpio-utils
    (python3.withPackages(ps: with ps;[
      adafruit-blinka
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
    extraGroups = { gpio = {}; };
  };

  services.udev = {
    extraRules = ''
      KERNEL=="gpiochip[0-9]*", GROUP="gpio", MODE="0660"
    '';
  };
}