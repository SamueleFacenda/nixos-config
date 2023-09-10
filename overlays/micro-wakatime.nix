{...}:

(self: super: {
  micro-wakatime = super.stdenv.mkDerivation rec {
    name = "micro-wakatime";
    version = "1.0.6";
    src = super.fetchFromGitHub {
      owner = "wakatime";
      repo = "micro-wakatime";
      rev = version;
      sha256 = "2NzEqKg6Bw2uF5Zee6Aa/WmvSHk8I0cx5P5cE8a7vJM=";
    };
    patchPhase = ''
      sed -i "s/    checkCli()//g" wakatime.lua
      sed -i "s/micro.InfoBar():Message(\"WakaTime initialized\")//g" wakatime.lua
      sed -i "s/micro.InfoBar():Message(\"WakaTime initializing...\")//g" wakatime.lua
    '';
    installPhase = ''
      mkdir -p $out
      mv * $out
    '';
  };
})
