{ pkgs, config, lib, fetchurl, stdenv, buildPackages, ... }:
{
  imports = [
    <machine>
    ./nixos/configuration.nix
    ./minification.nix
  ] ++ lib.optionals (builtins.pathExists ./custom.nix) [ ./custom.nix ];
}
