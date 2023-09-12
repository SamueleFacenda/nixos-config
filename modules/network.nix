{config, pkgs, lib, ...}:{

  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    userControlled.enable = true;

    environmentFile = config.age.secrets.network-keys.path;
    networks = {
      fazzenda = {
        priority = 10;
        psk = "@FAZZENDA_PSW@";
      };
      unitn-x = {
        priority = 9;
        auth = ''
          eap=PEAP
          identity="samuele.facenda@unitn.it"
          password="@UNITN-PSW@"
        '';
      };
    };
  };
}
