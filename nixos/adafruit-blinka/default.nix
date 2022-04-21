{ lib
, pkgs
}:
let
  rpi-gpio = pkgs.callPackage ./rpi-gpio { };
in
with pkgs.python3Packages;
buildPythonPackage rec {
  pname = "Adafruit-Blinka";
  version = "7.2.0";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "1xsw4c01vzd4kwwg80mq7x850cc4nd289h3mpgyg3fzmhkfwnysj";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    setuptools
    adafruit-platformdetect
    adafruit-pureio
    rpi-gpio
    pyftdi
    sysv_ipc
  ];

  # Physical SMBus is not present
  #doCheck = false;
  pythonImportsCheck = [ "adafruit_blinka" ];

  meta = with lib; {
    description = "Python interface to Linux IO including I2C and SPI";
    homepage = "https://github.com/adafruit/Adafruit_Python_PureIO";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
