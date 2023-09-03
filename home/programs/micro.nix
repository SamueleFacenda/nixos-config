{config, pkgs, ...}:{
  programs.micro = {
    enable = true;
    settings = {
      autosave = 5;
      autosu = true;
      clipboard = "terminal";
      diffgutter = true;
      eofnewline = false;
      keepautoindent = true;
      mkparents = true;
      savecursor = true;
      saveundo = true;
      smartpaste = true;
      tabtospaces = true;
      tabmovement = true;

      "*.nix" = {
        tabsize = 2;
      };
    }
  }
}
