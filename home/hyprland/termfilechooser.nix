{ config, pkgs, ... }:
let
  format = pkgs.formats.ini { };
in
{
  #  xdg.configFile."xdg-desktop-portal-termfilechooser/Hyprland".text = ''
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".source = format.generate "config" {
    filechooser = {
      cmd = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/ranger-wrapper.sh";
      default_dir = "${config.xdg.userDirs.download}";
    };
  };

}
