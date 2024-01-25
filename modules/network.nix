{ config, pkgs, lib, ... }:
let

  removeAttrs = blacklist: lib.filterAttrs (name: v: lib.all (x: x!=name) blacklist);
  # https://people.freedesktop.org/~lkundrak/nm-docs/nm-settings.html
  mkWifi = {name, priority ? 0, ...}@extra: {
    ${name} = lib.recursiveUpdate {
      connection = {
        id = name;
        type = "wifi";
        autoconnect-priority = priority;
        # autoconnect = true;
        # permissions  = "";
        # read-only = false;
      };
      wifi = {
        # mode = "infrastructure";
        ssid = name;
      };
      ipv4.method = "auto";
      ipv6 = {
        method = "auto";
        # addr-gen-mode = "default";
      };
    } (removeAttrs ["name" "priority"] extra);
  };

  mkPeapWifi = {name, identity, password, priority, ...}@extra: mkWifi (lib.recursiveUpdate {
    wifi-security.key-mgmt = "wpa-eap";
    "802-1x" = {
      eap = "peap";
      ca-cert = "/etc/ssl/certs/ca-bundle.crt";
      # phase1-peapver = 1;
      phase2-auth = "mschapv2";
      inherit identity  password;
    };
  } (removeAttrs ["identity" "password"] extra));

  mkWpaWifi = {name, password, priority, ...}@extra: mkWifi (lib.recursiveUpdate {
    wifi-security = {
      auth-alg = "open";
      key-mgmt = "wpa-psk";
      psk = password;
    };
  } (removeAttrs ["password"] extra));

in

 {
  networking.networkmanager = {
    enable = true;

    insertNameservers = [ "1.1.1.1" "1.0.0.1" ];

    ensureProfiles = {
      environmentFiles = lib.mkIf (config.age.secrets ? network-keys) [ config.age.secrets.network-keys.path ];
      profiles = lib.fold (a: b: a // b) {} [
        (mkWpaWifi {
          name = "fazzenda";
          password = "$FAZZENDA_PSW";
          priority = 50;
        })
        (mkPeapWifi {
          name = "unitn-x";
          identity = "samuele.facenda@unitn.it";
          password = "$UNITN_PSW";
          priority = 70;
        })
        (mkPeapWifi {
          name = "eduroam";
          identity = "samuele.facenda@unitn.it";
          password = "$UNITN_PSW";
          priority = 60;
        })
        (mkWpaWifi {
          name = "nenephone";
          password = "$HOTSPOT_PSW";
          priority = 100;
        })
        (mkWifi {
          name = "TrentinoWifi";
          priority = 10;
          wifi.key-mgmt = "none";
          wifi.auth-alg = "open";
        })
        (mkWpaWifi {
          name = "chia";
          priority = 120;
          password = "$HOTSPOT_CHIA";
        })
        (mkWpaWifi {
          name = "FASTWEB-B2219F";
          priority = 40;
          password = "$WHITE_HOUSE_PSW";
        })
      ];
    };
  };
}
