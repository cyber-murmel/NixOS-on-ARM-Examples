{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xradio-wireless-firmware";
  version = "2020-11-28";

  src = fetchFromGitHub {
    owner = "armbian";
    repo = "firmware";
    rev = "aff348fa9eef0fcc97d4f2bb7304f0862baffc20";
    sha256 = "08gd180rh5f621gfl1a2xjr86s5k1r81nl7l5nz17vk0kqbvbkkq";
  };

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/firmware/xr819"

    for filename in $src/xr819/*.bin; do
      cp "$filename" "$out/lib/firmware/xr819"
      echo $filename
    done

    runHook postInstall
  '';
}