{ lib
, pkgs
}:
with pkgs.python3Packages;
buildPythonPackage rec {
  pname = "RPi.GPIO";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "0w1v6zxi6ixaj1z5wag03333773lcacfmkss9ax2pdip7jqc8qfd";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
  ];

  # Physical SMBus is not present
  #doCheck = false;
  pythonImportsCheck = [ "RPi.GPIO" ];

  meta = with lib; {
    description = "Python interface to Linux IO including I2C and SPI";
    homepage = "https://github.com/adafruit/Adafruit_Python_PureIO";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
