{config, pkgs, ...}:{
  home.file.".scripts" = {
    executable = true;
    source = ./files;
    recursive = true;
  }
}
