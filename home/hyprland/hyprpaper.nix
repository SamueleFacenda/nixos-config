{ config, pkgs, self, ... }:
let
  bg = "${self.outPath}/assets/bg7.png";
in
{
  wayland.windowManager.hyprland.settings.exec-once = [ "pkill hyprpaper; ${pkgs.hyprpaper}/bin/hyprpaper" ];
  xdg.configFile."hypr/hyprpaper.conf" = {
    text = ''
      preload = ${bg}

      wallpaper = desc:Fujitsu Siemens Computers GmbH E22W-5 YV2C027320, ${bg}
      wallpaper = desc:Ancor Communications Inc ASUS VW199 DCLMTF153087, ${bg}
      wallpaper = eDP-1, ${bg}

      # fallback
      wallpaper = , ${bg}

      ipc = off
    '';
  };
}
