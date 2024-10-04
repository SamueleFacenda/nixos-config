{config, lib, pkgs, ...}:{
  
  services.photoprism = {
    enable = true;
    originalsPath = "/var/lib/private/photoprism/originals";
    port = 2342;
    address = "0.0.0.0";
    passwordFile = "/home/samuelef/photoprismPsw.txt";
    
    settings = {
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_SITE_URL = "https://samuele.freeddns.it";
      PHOTOPRISM_SITE_TITLE = "Samu's photos";
      PHOTOPRISM_DEFAULT_LOCALE = "it";
      PHOTOPRISM_ADMIN_USER = "admin";
      # PHOTOPRISM_LOG_LEVEL = "debug";
    };
  };
  
  fileSystems."/var/lib/private/photoprism/originals" =
      { device = "/home/samuelef/Pictures";
        options = [ "bind" ];
      };
  
  services.mysql = {
    enable = true;
    # dataDir = "/data/mysql";
    package = pkgs.mariadb;
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [ {
      name = "photoprism";
      ensurePermissions = {
        "photoprism.*" = "ALL PRIVILEGES";
      };
    } ];
  };
  
  security.acme = {
    defaults.email = "samuele.facenda@gmail.com";
    acceptTerms = true;
  };
  
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "500m";
    logError = "stderr debug";
    virtualHosts = {
      "samuele.freeddns.it" = {
        forceSSL = true;
        enableACME = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:2342";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
    };
  };
}
