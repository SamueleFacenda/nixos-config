{ config, pkgs, lib, utils, disabledFiles, ... }:
{

  imports = utils.listDirPathsExcluding (disabledFiles ++ [ "dunst.nix" ]) ./.;

  home.packages = with pkgs; [
    wofi
    wvkbd
    libinput
    # hyprswitch

    # screenshots tools
    slurp
    grim

    # audio video
    pamixer
    pavucontrol
    playerctl

    # displays
    wlr-randr
    # nwg-displays # wait for https://nixpk.gs/pr-tracker.html?pr=438729
    nwg-bar
    hyprshade
    swaylock-effects

    # utilities
    nautilus
    eog
    file-roller
    totem
    lollypop # gnome audio player

    # screen recorder via xdg-desktop-portal
    kooha
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    maxNWorkspaces = 7;
    plugins = with pkgs.hyprlandPlugins; [
      # hyprfocus # animation on focus change TODO wait for build fix
      # hyprspace
      # hyprexpo # hyprctl dispatch hyprexpo:expo toggle
    ];
    settings.exec-once = [
      "hyprctl setcursor Adwaita 24"
      "brave"
      "kitty"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    ];
    portalPackage = null; # fix wrong portal config dir set, use option from nixos
  };

  services.gnome-keyring.enable = true;

  services.swayosd.enable = true;
  
  services.flameshot.package = pkgs.flameshot.override { enableWlrSupport = true; };
  
  # Link gpus to home
  
  systemd.user.tmpfiles.rules = [
    "L /home/${config.home.username}/.config/hypr/nvidia - - - - /dev/dri/by-path/pci-0000:01:00.0-card"
    "L /home/${config.home.username}/.config/hypr/intel - - - - /dev/dri/by-path/pci-0000:00:02.0-card"
  ];
  
  programs.zathura = {
    enable = true;
    options = with config.lib.stylix.colors.withHashtag; {
      default-bg = lib.mkForce "alpha(${base00}, 0.2)";
      adjust-open = "width";
      selection-clipboard = "clipboard";
      # recolor-lightcolor = lib.mkForce "#000000";
    };
  };
  
  services.playerctld.enable = true;
  services.mpris-proxy.enable = false; # handle bluetooth mpris status
  
  services.batsignal = {
    enable = true;
    package = pkgs.batsignal.overrideAttrs { # wait for #476228
      env.NIX_CFLAGS_COMPILE = toString [
        "-Wno-error=incompatible-pointer-types"
      ];
    };
    extraArgs = lib.cli.toCommandLineGNU { } {
      w = "20"; # "-W" "message"
      c = "5"; # "-C" "message"
      d = "2"; # "-D" "message"
      # "-p" "-P" "charging message" "-U" "discharging message"
      m = "30"; # interval
    };
  };
}
