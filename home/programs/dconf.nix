{ pkgs, lib, ... }:

{
  # ...
  # Use `dconf watch /` to track stateful changes you are doing, then set them here.
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/#setting-gnome-options
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = lib.mkDefault "prefer-dark";
    };
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

      # enable the extensions for the user. "gnome-extensions list" to get the full name
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        # "system-monitor-next@paradoxxx.zero.gmail.com"
        # "tophat@fflewddur.github.io"
        # "System_Monitor@bghome.gmail.com"
      ];
    };
  };
}
