{ stdenv, pkgs, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "xradio-${version}-${kernel.version}";
  version = "2020-01-21";

  src = fetchFromGitHub {
    owner = "fifteenhex";
    repo = "xradio";
    rev = "16180b6308e3c5dc42a92a663adf669028087ff7";
    sha256 = "1k3qjinpl39ij0r3swdggqrldd2g0ghkym83mni1q1ymwghrd6x7";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    cp -r ${src} xradio
    chmod -R 755 xradio
    pushd xradio >/dev/null
      make \
        ARCH=arm \
        CROSS_COMPILE=armv7l-unknown-linux-gnueabihf- \
        -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
        M=$(pwd) \
        modules
    popd
  '';

  installPhase = ''
    mkdir $out
    pushd xradio >/dev/null
      make \
        ARCH=arm \
        CROSS_COMPILE=armv7l-unknown-linux-gnueabihf- \
        -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
        M=$(pwd) \
        INSTALL_MOD_PATH=$out \
        modules_install
    popd
  '';
}