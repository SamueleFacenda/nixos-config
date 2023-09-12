{ config, pkgs, ... }: {

  home.packages = with pkgs; [
  ];

  xdg.configFile."xdg-desktop-portal-shana/config.toml".text = ''
    open_file = "Gnome"
    save_file = "Gtk"
    
    [tips]
    open_file_when_folder = "Gnome"
  '';
}
