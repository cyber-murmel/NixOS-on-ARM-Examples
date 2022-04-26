let
  lib = import <nixpkgs/lib>;
  nixos = import <nixpkgs/nixos> {
    configuration = { ... }: {
      imports = [
        <machine/sd-image.nix>
        <machine/hardware-configuration.nix>
        ./nixos/configuration.nix
      ] ++ lib.optionals (builtins.pathExists ./custom.nix) [ ./custom.nix ];
    };
  };
in
nixos.config.system.build.sdImage // {
  inherit (nixos) pkgs system config;
}
