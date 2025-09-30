{ config, pkgs, lib, ... }:
let

  # https://people.freedesktop.org/~lkundrak/nm-docs/nm-settings.html
  mkWifi = { name, priority ? 0, ... }@extra: {
    ${name} = lib.recursiveUpdate
      {
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
      }
      (builtins.removeAttrs extra [ "name" "priority" ]);
  };

  mkPeapWifi = { name, identity, password, priority, ... }@extra: mkWifi (lib.recursiveUpdate
    {
      wifi-security.key-mgmt = "wpa-eap";
      "802-1x" = {
        eap = "peap";
        ca-cert = "/etc/ssl/certs/ca-bundle.crt";
        # phase1-peapver = 1;
        phase2-auth = "mschapv2";
        inherit identity password;
      };
    }
    (builtins.removeAttrs extra [ "identity" "password" ]));

  mkWpaWifi = { name, password, priority, ... }@extra: mkWifi (lib.recursiveUpdate
    {
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
        psk = password;
      };
    }
    (builtins.removeAttrs extra [ "password" ]));

in

{

  networking.extraHosts = ''
    10.0.0.1 leo
  '';
  networking.networkmanager = {
    enable = true;

    # insertNameservers = [ "1.1.1.1" ]; # "1.0.0.1"

    ensureProfiles = {
      environmentFiles = lib.mkIf (config.age.secrets ? network-keys) [ config.age.secrets.network-keys.path ];
      profiles = lib.fold (a: b: a // b) { } [
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
        (mkPeapWifi {
          name = "eduroam-fbk";
          wifi.ssid = "eduroam";
          identity = "sfacenda@fbkeduroam.it";
          password = "$FBK_PSW";
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
        (mkWpaWifi {
          name = "LeoRover-58c0";
          priority = 80;
          password = "$LEO_PSW";
        })
      #   (mkPeapWifi {
      #     name = "eduroam-ethernet";
      #     identity = "@fbkeduroam.it";
      #     password = "$FBK_PSW";
      #     priority = 75;
      #     connection.type = "ethernet";
      #     ethernet = {};
      #   })
      ];
    };
  };
  
  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIFPjCCBCagAwIBAgIUEqPA90lgb+zZW6dNbdiwOtmZQHowDQYJKoZIhvcNAQEL
      BQAwgawxCzAJBgNVBAYTAklUMRwwGgYDVQQIDBNUcmVudGluby1BbHRvIEFkaWdl
      MQ8wDQYDVQQHDAZUcmVudG8xITAfBgNVBAoMGEZvbmRhemlvbmUgQnJ1bm8gS2Vz
      c2xlcjEcMBoGCSqGSIb3DQEJARYNc3lzb3BzQGZiay5ldTEtMCsGA1UEAwwkRkJL
      IFJhZGl1cyBFQVAgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MB4XDTIxMDMyNTE4NDMy
      MVoXDTQwMTIxMDE4NDMyMVowgawxCzAJBgNVBAYTAklUMRwwGgYDVQQIDBNUcmVu
      dGluby1BbHRvIEFkaWdlMQ8wDQYDVQQHDAZUcmVudG8xITAfBgNVBAoMGEZvbmRh
      emlvbmUgQnJ1bm8gS2Vzc2xlcjEcMBoGCSqGSIb3DQEJARYNc3lzb3BzQGZiay5l
      dTEtMCsGA1UEAwwkRkJLIFJhZGl1cyBFQVAgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvaCYL+rI1PSwQ+T6fVaJ
      Un2EaLGIT2gblgiNfufjmfmd3FiDbDzTL5WqaXVta/NrY68cl8ZaqEVUCactk2g6
      mnEj0t71CyVGDOMlv61VA+ogJUawyw07SckYVuf1Qy+fQNSqtEWzJrv1azcea/Vt
      SnRwP0PmBl9ipVfjiRakGr9jxQnQM1nAHjoqCC6rdjnKhkDAezgbJsV99Q+3zPZD
      RkDzB7fbUDCtciH+EZEIQm+v12gU4e/q7lb2RiSe8iAsEuDPYTxohyPlCzI0SpJT
      VwIP5wwiHjpa7NEaMicGBHX2R8AiX56PN51350b/fJM2hz7RCHq0oa0KF2jumAmK
      CwIDAQABo4IBVDCCAVAwHQYDVR0OBBYEFGHfUl4opW91EJHyATtmgSKz/qTqMIHs
      BgNVHSMEgeQwgeGAFGHfUl4opW91EJHyATtmgSKz/qTqoYGypIGvMIGsMQswCQYD
      VQQGEwJJVDEcMBoGA1UECAwTVHJlbnRpbm8tQWx0byBBZGlnZTEPMA0GA1UEBwwG
      VHJlbnRvMSEwHwYDVQQKDBhGb25kYXppb25lIEJydW5vIEtlc3NsZXIxHDAaBgkq
      hkiG9w0BCQEWDXN5c29wc0BmYmsuZXUxLTArBgNVBAMMJEZCSyBSYWRpdXMgRUFQ
      IENlcnRpZmljYXRlIEF1dGhvcml0eYIUEqPA90lgb+zZW6dNbdiwOtmZQHowDwYD
      VR0TAQH/BAUwAwEB/zAvBgNVHR8EKDAmMCSgIqAghh5odHRwOi8vY2FjcmwuZmJr
      LmV1L2Zia19jYS5jcmwwDQYJKoZIhvcNAQELBQADggEBAARzEWMPH5lFFeMoYDO8
      /M2Wkte/rrCviyQl8UPeAyZPxBJYx2MWM9qn6M6dhMmr1drvC+6xxePIkLhcr0Lk
      fsBn8dOtW4uGQpt/aTaICPLCH7YtBR7YnOaL3tazpOgEmqwBEVeH1rlGsfWT0CXF
      nyOsY24TiSpoVPpt9t50cUuSrBm1mTZHuLPIS/qThPjDShdHj+wbh7rSWmPnB+Cn
      oPv/ijwmhn5tEQfwcaxBTVknHgllWxjh5kXsn4sQWyDsNW4eAQ+7UsRgn05fU/s3
      ZOD/+IcOLuNF/JM5A2Ygsbn2ziVMTdZb5Crjams5/SZZFU0+G59zTCyTs5JOL9EU
      EWY=
      -----END CERTIFICATE-----
    ''
  ];
}
