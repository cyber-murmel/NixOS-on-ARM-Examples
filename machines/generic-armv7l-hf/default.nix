{ config, pkgs, lib, ... }:
{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.armv7l-hf-multiplatform;

  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix>
  ];
}
