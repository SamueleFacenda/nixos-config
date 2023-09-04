{config, pkgs, ...}:{

  home.packages = [
    (callPackage ../../packages/xdg-desktop-portal-shana.nix {})
  ];
  
  xdg.configFile."xdg-desktop-portal-shana/config.toml".text = ''
    open_file = "Gnome"
    save_file = "Gnome"
    
    [tips]
    open_file_when_folder = "Gnome"
  '';
}