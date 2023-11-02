{ pkgs, lib, spicetify-nix, secrets, ... }:
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
      theme = spicePkgs.themes.DefaultDynamic;
      # colorScheme = "flamingo";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        fullAlbumDate
        wikify
        history
      ];
    };

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "2pxqknxvfuz2yuigiqd4wazlt";
        password_cmd = "cat ${secrets.spotify.path}";
        use_mpris = true; # global controls
        device_name = "spotifyd_surfacenene";
        device_type = "computer";
      };
    };
  };
}
