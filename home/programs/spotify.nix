{ config, pkgs, lib, spicetify-nix, secrets, ... }:
let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  # import the flake's module for your system
  imports = [ spicetify-nix.homeManagerModule ];

  # configure spicetify :)
  programs.spicetify =
    {
      enable = true;
      theme = spicePkgs.themes.Onepunch;

      colorScheme = "custom";
      customColorScheme = with config.lib.stylix.scheme; {
        text = cyan;
        subtext = base05;
        sidebar-text = cyan;
        main = base00;
        sidebar = base01;
        player = base02;
        card = base02;
        shadow = base0D;
        selected-row = base04;
        button = base06;
        button-active = cyan;
        button-disabled = brown;
        tab-active = base03;
        notification = yellow;
        notification-error = red;
        misc = brown;
      };

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
        new-releases
        marketplace
      ];
    };

  services.spotifyd = {
    enable = true;
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
