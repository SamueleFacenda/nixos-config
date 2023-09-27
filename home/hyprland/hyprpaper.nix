{ config, pkgs, self, ... }:
let
  bg = "${self.outPath}/assets/bg4.png";
in
{
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
