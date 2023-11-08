{ config, pkgs, ... }: {

#  xdg.configFile."xdg-desktop-portal-termfilechooser/Hyprland".text = ''
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/ranger-wrapper.sh
    default_dir=${config.xdg.userDirs.download}
  '';
}
