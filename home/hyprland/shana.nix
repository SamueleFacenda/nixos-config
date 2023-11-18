{ config, pkgs, ... }:
let
  toml = pkgs.formats.toml { };
in
{

  xdg.configFile."xdg-desktop-portal-shana/config.toml".source = toml.generate "config.toml" {
    open_file = "Gtk";
    save_file = "Gtk";
    tips.open_file_when_folder = "Gtk";
  };
}
