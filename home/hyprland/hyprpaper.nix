{config, pkgs, self, ...}:{
  xdg.configFile."hypr/hyprpaper.conf" = {
    text = ''
      preload = ${self.outPath}/assets/bg1.png
      #preload = ${self.outPath}/assets/bg2.png
      #preload = ${self.outPath}/assets/bg3.png
      #preload = ${self.outPath}/assets/bg4.png

      wallpaper = DP-3, ${self.outPath}/assets/bg1.png
      wallpaper = DP-4, ${self.outPath}/assets/bg1.png
      wallpaper = eDP-1, ${self.outPath}/assets/bg1.png
      wallpaper = DP-6, ${self.outPath}/assets/bg1.png

      ipc = off
    '';
  };
}
