{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    htop

    # misc
    xdg-utils
    tree

    # productivity
    obsidian

    # web
    brave
  ];

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      # keyMode = "vi";
      # extraConfig = "mouse on";
    };

    btop.enable = true;  # replacement of htop/nmon
    exa.enable = true;   # A modern replacement for ‘ls’
    ssh.enable = true;

  };

  services = {
    # syncthing.enable = true;

    # auto mount usb drives
    udiskie.enable = true;
  };
}
