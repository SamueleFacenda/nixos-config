# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # disable some default gnome apps
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
    gnome-console
  ]) ++ (with pkgs.gnome; [
    # cheese # webcam tool
    gnome-music
    # gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-contacts
    gnome-weather
    gnome-maps
    gnome-calendar
  ]);

  # enable dconf for global config
  programs.dconf.enable = true;

  # install extensions
  environment.systemPackages = (with pkgs.gnomeExtensions; [
    user-themes
    caffeine
    # system-monitor-next not working
    # tophat
    # system-monitor-2
  ]) ++ (with pkgs; [
    # libgtop # dependecy of tophat
    # gtop
  ]);

}
