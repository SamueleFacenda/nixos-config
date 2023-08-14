{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    htop
    mdcat

    # misc
    xdg-utils
    tree
    wakatime

    # productivity
    obsidian

    # web
    brave
  ];
  
  programs = {
    btop.enable = true;  # replacement of htop/nmon
    exa.enable = true;   # A modern replacement for ‘ls’
    ssh.enable = true;
  };

  services = {
    # syncthing.enable = true;

    # auto mount usb drives
    udiskie.enable = true;
  };

  home.sessionVariables = {
  	ZLE_RPROMPT_INDENT = 0;
  };
}
