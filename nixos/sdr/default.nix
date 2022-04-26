{ config, pkgs, lib, ... }:
let
  soapysdr-minimal = with pkgs; soapysdr.override {
    extraPackages = [
      soapyremote
      soapyhackrf
      soapyrtlsdr
    ];
  };
in
{
  environment.systemPackages = with pkgs; [
    rtl-sdr
    hackrf
    soapysdr-minimal
  ];

  hardware = {
    rtl-sdr.enable = true;
    hackrf.enable = true;
  };

  # based on https://github.com/pothosware/SoapyRemote/blob/f7a39bb/system/SoapySDRServer.service.in
  systemd.services.soapyremote = {
    description = ''
      Soapy SDR Remote Server
    '';
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    script = ''
      ${soapysdr-minimal}/bin/SoapySDRServer --bind
    '';
    serviceConfig = {
      RestartSec = 10;
      Restart = "on-failure";
      KillMode = "process";
      LimitRTPRIO = 99;
    };
  };

  # based on https://github.com/pothosware/SoapyRemote/blob/f7a39bb/system/SoapySDRServer.sysctl
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 104857600;
    "net.core.wmem_max" = 104857600;
  };
}