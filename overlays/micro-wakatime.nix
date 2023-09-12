{ ... }:

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
    # remove check for new versions and infobar log printing at startup
    patchPhase = ''
      substituteInPlace wakatime.lua \
        --replace "    checkCli()" "" \
        --replace "micro.InfoBar():Message(\"WakaTime initialized\")" "" \
        --replace "micro.InfoBar():Message(\"WakaTime initializing...\")" ""
    '';
    installPhase = ''
      mkdir -p $out
      mv * $out
    '';
  };
})
