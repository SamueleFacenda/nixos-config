{config, pkgs, ...}:{
  xdg.configFile.ranger = {
    source = ./config;
    recursive = true;
  };
  home.sessionVariables.RANGER_LOAD_DEFAULT_RC = "false";
}
