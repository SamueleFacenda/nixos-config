{ config, pkgs, agenix, ... }: {

  imports = [
    # get the fillPlacehodersFiles option for secrets
    ../modules/agenix-utils.nix
  ];

  # needed client programs
  environment.systemPackages = with pkgs; [
    agenix.packages."${system}".default

    gnupg
    pinentry
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    settings = {
      allow-preset-passphrase = true;
    };
  };

  # secrets config
  age.secrets = {
    github-token = {
      file = ./github-token.age;
    };

    wakatime-key = {
      file = ./wakatime-key.age;
      owner = "samu";
      group = "users";
      # fillPlaceholdersFiles = [ "/home/samu/.wakatime.cfg" ];
    };

    network-keys = {
      file = ./network-keys.age;
    };

    spotify = {
      file = ./spotify.age;
      owner = "samu"; # TODO make group for spotifyd
      group = "users";
    };

    nix-access-tokens = {
      file = ./nix-access-tokens.age;
      owner = "samu";
      group = "users";
    };
  };

  age.identityPaths = [
    "/home/samu/.ssh/id_rsa"
    "/home/samu/.ssh/id_ed25519"
  ];
}
