{config, pkgs, ...}:{
  home.file."wakatime.cfg".text =
    ''
      [settings]
      api_key = @wakatime-key@
    '';
}
