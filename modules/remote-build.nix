{ config, pkgs, ... }: {
  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
      SetEnv NIXBUILDNET_SETTINGS_FROM_DRV_ENV=true
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile /home/${config.users.default.name}/.ssh/nixbuild
  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

  nix = {
    distributedBuilds = false; # Opt in with --builders '@/etc/nix/machines'
    buildMachines = [
      {
        hostName = "eu.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [ "benchmark" "big-parallel" ];
        speedFactor = 1;
      }
    ];

    settings.builders-use-substitutes = true;
  };
}
