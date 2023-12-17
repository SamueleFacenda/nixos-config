{ config, pkgs, lib, ... }: {

  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    userControlled.group = "network";

    environmentFile = config.age.secrets.network-keys.path;
    networks = {
      fazzenda = {
        priority = 50;
        psk = "@FAZZENDA_PSW@";
      };
      unitn-x = {
        priority = 70;
        auth = ''
          eap=PEAP
          key_mgmt=WPA-EAP
          identity="samuele.facenda@unitn.it"
          password="@UNITN_PSW@"
          ca_cert="/etc/ssl/certs/ca-bundle.crt"
        '';
      };
      eduroam = {
        priority = 60;
        auth = ''
          eap=PEAP
          key_mgmt=WPA-EAP
          identity="samuele.facenda@unitn.it"
          password="@UNITN_PSW@"
          ca_cert="/etc/ssl/certs/ca-bundle.crt"
        '';
      };
      nenephone = {
        priority = 100;
        psk = "@HOTSPOT_PSW@";
      };
      TrentinoWifi = {
        priority = 10;
      };
      FASTWEB-B2219F = {
        priority = 30;
        psk = "@WHITE_HOUSE_PSW@";
      };
      TIM-20569857 = {
        priority = 31;
        psk = "@CASA_ALESSANDRO@";
      };
    };
  };

  networking.resolvconf.extraConfig = ''
    name_servers="1.1.1.1"
  '';
}
