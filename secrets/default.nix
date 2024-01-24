{ config, pkgs, agenix, ... }: {

  imports = [
    # get the fillPlacehodersFiles option for secrets
    ../modules/agenix-utils.nix
  ];

  # needed client programs
  environment.systemPackages = with pkgs; [
    agenix.packages.${system}.default

    gnupg
    pinentry
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    settings = {
      allow-preset-passphrase = "";
    };
  };

  # secrets config
  age.secrets = {
    github-token = {
      file = ./github-token.age;
    };

    wakatime-key = {
      file = ./wakatime-key.age;
      owner = config.users.default.name;
      group = "users";
      # fillPlaceholdersFiles = [ "/home/samu/.wakatime.cfg" ];
    };

    network-keys = {
      file = ./network-keys.age;
    };

    spotify = {
      file = ./spotify.age;
      owner = config.users.default.name; # TODO make group for spotifyd
      group = "users";
    };

    nix-access-tokens = {
      file = ./nix-access-tokens.age;
      owner = config.users.default.name;
      group = "users";
    };
  };

  age.identityPaths = [
    "/home/${config.users.default.name}/.ssh/id_rsa"
    "/home/${config.users.default.name}/.ssh/id_ed25519"
  ];
}
