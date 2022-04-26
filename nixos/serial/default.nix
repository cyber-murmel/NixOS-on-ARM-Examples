{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    i2c-tools
    (python3.withPackages(ps: with ps;[
      pyserial
      adafruit-pureio
      spidev
    ]))
  ];

  hardware.i2c.enable = true;
}