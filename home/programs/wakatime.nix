{config, pkgs, ...}:{
  home.file.".wakatime.cfg".text =
    ''
      [settings]
      api_key = @wakatime-key@
    '';
  home.file.".wakatime.cfg".force = true;
}
