{config, pkgs, micro-wakatime, ...}:{
  programs.micro = {
    enable = true;
    settings = {
      autosave = 0;
      autosu = true;
      clipboard = "terminal";
      diffgutter = true;
      eofnewline = true;
      keepautoindent = true;
      mkparents = true;
      savecursor = true;
      saveundo = true;
      smartpaste = true;
      tabstospaces = true;
      tabmovement = true;

      "*.nix" = {
        tabsize = 2;
      };
    };
  };

  xdg.configFile."micro/plug/wakatime" = {
    enable = true;
    recursive = true;
    source = "${micro-wakatime}";
  };
}
