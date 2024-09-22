{ config, pkgs, ... }: {
  services.flameshot.enable = true;
  services.flameshot.settings = with config.lib.stylix.colors.withHashtag; {
    General = {
      uiColor = "${brown}";
      contrastUiColor = "${base07}";
      savePath = "${config.xdg.userDirs.pictures}/screenshots";
      saveAsFileExtension = ".png";
      showDesktopNotification = true;
      filenamePattern = "flameshot_%F_%H-%M";
      disabledGrimWarning = true;
      disabledTrayIcon = false;
      checkForUpdates = true;
    };
  };
}
