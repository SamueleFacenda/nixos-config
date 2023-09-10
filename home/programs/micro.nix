{config, pkgs, ...}:{
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
    source = pkgs.stdenv.mkDerivation rec {
      name = "micro-wakatime";
      version = "1.0.6";
      src = pkgs.fetchFromGitHub {
        owner = "wakatime";
        repo = "micro-wakatime";
        rev = version;
        sha256 = "2NzEqKg6Bw2uF5Zee6Aa/WmvSHk8I0cx5P5cE8a7vJM=";
      };
      patchPhase = ''
        sed -i "s/    checkCli()//g" wakatime.lua
      '';
      installPhase = ''
        mkdir -p $out
        mv * $out
      '';
    };
  };
}
