{ pkgs, lib, ... }:

{
  # ...
  # Use `dconf watch /` to track stateful changes you are doing, then set them here.
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/#setting-gnome-options
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = lib.mkDefault "prefer-dark";
    };
  
    # "org/gnome/desktop/background" = {
    #     "picture-uri" = "file://${../../assets/bg7.png}" ;
    # };
    
    "org/gnome/shell" = {
      favorite-apps = [
        "brave-browser.desktop"
        #"code.desktop"
        # "org.gnome.Console.desktop"
        #"spotify.desktop"
        #"virt-manager.desktop"
        "org.gnome.Nautilus.desktop"
        "spotify.desktop"
        "kitty.desktop"
        "code.desktop"
        "idea-ultimate.desktop"
      ];
      
      enabled-extensions = [
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
      ];

      # enable the extensions for the user. "gnome-extensions list" to get the full name
      disable-user-extensions = false;
      disable-extension-version-validation = true;
    };
  };
  
  # https://github.com/nix-community/nur-combined/blob/f08289e1961ee896d665b1ade61549ec4e4fe6ad/repos/eownerdead/users/noobuser/gnome.nix#L9
  home.sessionVariables.JHBUILD_PREFIX = "${pkgs.gnome-shell}";
  
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = caffeine; }
      { package = user-themes; }
      { package = gjs-osk; }
      { package = blur-my-shell; }
      { package = screen-rotate; }
      { package = always-show-titles-in-overview; }
      { package = auto-activities; }
      # { package = buildShellExtension {
      #   
      # };}
      # https://extensions.gnome.org/extension/7196/maximized-by-default-reborn/
      # https://extensions.gnome.org/extension/3100/maximize-to-empty-workspace/
      # https://extensions.gnome.org/extension/4316/force-show-osk/
      # system-monitor-next not working
      # tophat
      # system-monitor-2
    ];
  };
}
