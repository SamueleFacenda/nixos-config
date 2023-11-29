{ config, pkgs, ... }:
let
  format = pkgs.formats.toml { };
in
{

  xdg.configFile."xdg-desktop-portal-shana/config.toml".source = format.generate "config.toml" {
    open_file = "Gtk";
    save_file = "Gtk";
    tips.open_file_when_folder = "Gtk";
  };
}
