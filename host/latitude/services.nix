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
    image = "ghcr.io/usetrmnl/byos_laravel:latest";
    environment = {
      # REGISTRATION_ENABLED = "0";
      PHP_OPCACHE_ENABLE = "1";
      APP_TIMEZONE = "Europe/Rome";
      DB_DATABASE = "database/storage/database.sqlite";
      PUPPETEER_WINDOW_SIZE_STRATEGY = "v2";
    };
    volumes = [
      "database:/var/www/html/database/storage"
      "storage:/var/www/html/storage/app/public/images/generated"
    ];
    ports = [ "2300:8080" ];
  };

  ## Trmnl calendar update timer
  
  systemd.timers."trmnl-calendar" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*:0/10"; # Every 10 minutes
        Persistent = true;
        Unit = "trmnl-calendar.service";
      };
    };
  
    systemd.services."trmnl-calendar" = {
      script = "${pkgs.trmnl-calendar}/bin/trmnl-calendar";
      serviceConfig = {
        Type = "oneshot";
        User = config.users.default.name;
      };
      environment = {
        TRMNL_TITLE = "Calendario lezioni Samu";
        TRMNL_WEBHOOK_URL = "http://192.168.68.109:2300/api/custom_plugins/728011e6-bf28-4825-9e6d-4bcf7a59b631";
        TRMNL_ICS_URL = builtins.concatStringsSep "," [
          "https://webapi.unitn.it/unitrentoapp/profile/me/calendar/C57C1F7D08BEF5551658CC7B2D299297A1F500FCD56280D6E03BA51A3E6E1F77"
          "https://calendar.google.com/calendar/ical/75607d8028ce751b368530686bd514ad295458dc8c6086b7b3bcc2048b83e226%40group.calendar.google.com/public/basic.ics"
          ];
        TRMNL_DAYS = 30;
        TRMNL_TZ = "Europe/Rome";
        TRMNL_NUMBER_COLUMNS = 5;
        TRMNL_LOCALE = "it_IT.UTF-8";
        
      };
    };

}
