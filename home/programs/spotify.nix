{ config, pkgs, lib, spicetify-nix, secrets, ... }:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  # import the flake's module for your system
  imports = [ spicetify-nix.homeManagerModules.default ];

  # configure spicetify :)
  programs.spicetify =
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        fullAlbumDate
        wikify
        history
        playlistIcons
      ];

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        marketplace
        historyInSidebar
      ];
    };
    
  programs.spotify-player = {
    enable = true;
    settings = {
      client_id = "478557dfc9ab451f8d97ee4070634865";
      client_port = 8088;
      
    };
  };

  services.spotifyd = {
    enable = false; # wait for build to be fixed
    settings = {
      global = {
        username = "2pxqknxvfuz2yuigiqd4wazlt";
        use_mpris = true; # global controls
        device_name = "spotifyd_surfacenene";
        device_type = "computer";
      } // (if secrets ? spotify
      then { password_cmd = "cat ${secrets.spotify.path}"; }
      else { password = "placeholder"; });
    };
  };
}
