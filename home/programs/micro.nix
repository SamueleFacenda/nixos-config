{ config, pkgs, ... }: {
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
      colorscheme = "custom";

      "*.nix" = {
        tabsize = 2;
      };
    };
  };

  xdg.configFile."micro/plug/wakatime" = {
    enable = true;
    recursive = true;
    source = pkgs.micro-wakatime;
  };

  xdg.configFile."micro/colorschemes/custom.micro".text = with config.lib.stylix.colors.withHashtag; ''
    # no default, use terminal bg
    # color-link default "#F8F8F2,#282828"
    color-link comment "${base06}"
    color-link identifier "#66D9EF"
    color-link constant "${magenta}"
    color-link constant.string "${yellow}"
    color-link constant.string.char "${green}"
    color-link statement "#F92672"
    color-link symbol.operator "#F92671"
    color-link preproc "#CB4B16"
    color-link type "#66D9EF"
    color-link special "#A6E22E"
    color-link underlined "#D33682"
    color-link error "bold #CB4B16,#282828"
    color-link todo "bold #D33682,#282828"
    color-link hlsearch "${base00},${base04}"
    color-link statusline "${base00},${base04}"
    color-link tabbar "${base00},${base04}"
    color-link indent-char "#505050"
    color-link line-number "${base04},${base00}"
    color-link current-line-number "${base04},${base03}"
    color-link diff-added "${green}"
    color-link diff-modified "${yellow}"
    color-link diff-deleted "${orange}"
    color-link gutter-error "#CB4B16,#282828"
    color-link gutter-warning "#E6DB74,#282828"
    color-link cursor-line "${base03}"
    color-link color-column "#323232"
    #No extended types; Plain brackets.
    color-link type.extended "default"
    #color-link symbol.brackets "default"
    color-link symbol.tag "#AE81FF,#282828"
  '';
}
