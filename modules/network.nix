{config, pkgs, lib, ...}:{

  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    userControlled.enable = true;

    environmentFile = config.age.secrets.network-keys.path;
    networks = {
      fazzenda = {
        priority = 5;
        psk = "@FAZZENDA_PSW@";
      };
      unitn-x = {
        priority = 7;
        auth = ''
          eap=PEAP
          identity="samuele.facenda@unitn.it"
          password="@UNITN_PSW@"
        '';
      };
      nenephone = {
        priority = 10;
        psk = "@HOTSPOT_PSW@";
      };
    };
  };
}
