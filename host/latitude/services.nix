{config, lib, pkgs, ...}:{
  
  services.photoprism = {
    enable = true;
    # package = pkgs.photoprism.override { ffmpeg_7 = pkgs.ffmpeg_7-full; };
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
      PHOTOPRISM_FFMPEG_ENCODER = "vaapi";
      PHOTOPRISM_ORIGINALS_LIMIT = "-1";
      PHOTOPRISM_FFMPEG_SIZE = "1920";
      PHOTOPRISM_FFMPEG_BITRATE = "8";
      # PHOTOPRISM_LOG_LEVEL = "trace";
    };
  };
  
  users.groups.photos = {};
  users.users.samuelef.extraGroups = [ "photos" ];

  systemd.services.photoprism = {
    environment.LIBVA_DRIVER_NAME = "i965";
    serviceConfig = {
      SupplementaryGroups = [ "video" "render" "photos" ];
      PrivateDevices = lib.mkForce false;
      # DeviceAllow = "/dev/dri/renderD128";
    };
  };
  
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver # For older processors. LIBVA_DRIVER_NAME=i965
    ];
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
    logError = "stderr";
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
  
  # TRMNL
  
  virtualisation.oci-containers.containers."trmnl-server-app" = {
    image = "ghcr.io/usetrmnl/terminus:latest";
    environment = {
      API_URI = "http://192.168.68.109:2300";
      HANAMI_PORT = "2300";
      DATABASE_URL = "postgresql://terminus:password@192.168.68.109:5432/terminus";
    };
    ports = [ "2300:2300" ];
  };
  
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    package = pkgs.postgresql_17_jit;
    ensureDatabases = [ "terminus" ];
    ensureUsers = [
      {
        name = "terminus";
        ensureDBOwnership = true;
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE  USER      ADDRESS          METHOD
      local   all      postgres                  peer map=postgres
      local   all      all                       peer
      host    all      all       127.0.0.1/32    md5
      host    all      all       ::1/128         md5

      # allow podman containers
      host    all      all       10.88.0.0/16    md5
    '';
  };
}
