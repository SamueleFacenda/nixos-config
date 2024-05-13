{ config, pkgs, ... }: {
  programs.ssh = {
    enable = true;

    matchBlocks = {
      leo = {
        user = "pi";
        hostname = "10.0.0.1";
      };
    };
  };
}
