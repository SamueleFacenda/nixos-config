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
      theme = spicePkgs.themes.Default;

      colorScheme = "custom";
      # https://github.com/spicetify/spicetify-themes/blob/3231c5e4d1a5f2dbae7aec65291364f863eaf9e0/Sleek/color.ini#L323
      customColorScheme = with config.lib.stylix.scheme; {
        text = cyan;
        subtext = base05;
        nav-active-text = base06;
        sidebar-text = cyan;
        main = base00;
        sidebar = base01;
        player = base02;
        card = base02;
        tab-active = base03;
        shadow = base0D;
        button = blue;
        button-active = base07;
        button-disabled = brown;
        button-secondary = blue;
        notification = brown;
        notification-error = red;
        playback-bar = cyan;
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
