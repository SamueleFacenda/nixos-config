{ config, pkgs, lib, agenix, ... }: {

  imports = [
    # get the fillPlacehodersFiles option for secrets
    ../modules/agenix-utils.nix
  ];

  # needed client programs
  environment.systemPackages = with pkgs; [
    agenix.packages.${stdenv.hostPlatform.system}.default

    gnupg
    pinentry-gnome3
    pinentry-tty
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    settings = {
      allow-preset-passphrase = "";
    };
  };

  # secrets config
  age.secrets = {
    github-token = lib.mkIf config.secrets.github-token.enable {
      file = ./github-token.age;
    };

    wakatime-key = lib.mkIf config.secrets.wakatime-key.enable {
      file = ./wakatime-key.age;
      owner = config.users.default.name;
      group = "users";
      # fillPlaceholdersFiles = [ "/home/samu/.wakatime.cfg" ];
    };

    network-keys = lib.mkIf config.secrets.network-keys.enable {
      file = ./network-keys.age;
    };

    spotify = lib.mkIf config.secrets.spotify.enable {
      file = ./spotify.age;
      owner = config.users.default.name;
      group = "users";
    };

    nix-access-tokens = lib.mkIf config.secrets.nix-access-tokens.enable {
      file = ./nix-access-tokens.age;
      owner = config.users.default.name;
      group = "users";
    };
    
    pingpov-env = lib.mkIf config.secrets.pingpov-env.enable {
      file = ./pingpov-env.age;
    };
  };

  age.identityPaths = [
    "/home/${config.users.default.name}/.ssh/id_rsa"
    "/home/${config.users.default.name}/.ssh/id_ed25519"
  ];
}
