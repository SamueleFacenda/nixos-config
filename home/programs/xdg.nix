{ config, pkgs, ... }: {
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/.Desktop";
      music = "${config.home.homeDirectory}/.Music";
      templates = "${config.home.homeDirectory}/.Templates";
      download = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/documents";
      # templates = "${config.home.homeDirectory}/.Videos";
    };

    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      # ls /etc/profiles/per-user/samu/share/applications for home-manager apps
      # ls /run/current-system/sw/share/applications for system wide apps
      defaultApplications = {
        "text/plain" = "codium.desktop";
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/rar" = "org.gnome.FileRoller.desktop";
        "application/7z" = "org.gnome.FileRoller.desktop";
        "application/*tar" = "org.gnome.FileRoller.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/pdf" = "com.github.xournalpp.xournalpp.desktop";
        "image/*" = "org.gnome.eog.desktop";
        "video/*" = "org.gnome.eog.desktop";
        "audio/*" = "org.gnome.Lollypop.desktop";
        #"x-scheme-handler/tg" = "telegramdesktop.desktop";
        "text/html" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-scheme-handler/ftp" = "brave-browser.desktop";
        "x-scheme-handler/chrome" = "brave-browser.desktop";
        "x-scheme-handler/about" = "brave-browser.desktop";
        "x-scheme-handler/unknown" = "brave-browser.desktop";
        "application/x-extension-htm" = "brave-browser.desktop";
        "application/x-extension-html" = "brave-browser.desktop";
        "application/x-extension-shtml" = "brave-browser.desktop";
        "application/xhtml+xml" = "brave-browser.desktop";
        "application/x-extension-xhtml" = "brave-browser.desktop";
        "application/x-extension-xht" = "brave-browser.desktop";
      };
    };
  };
}
