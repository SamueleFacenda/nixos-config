{ lib
, stdenv
, fetchFromGitHub
, nerd-font-patcher
, fetchurl
# , google-fonts
}:

stdenv.mkDerivation {
  pname = "x-typewriter";
  version = "1.0";
  srcs = [
    (fetchurl {
      url = "https://st.1001fonts.net/download/font/x-typewriter.regular.ttf";
      hash = "sha256-JT/8bljelqOnRr2e3arVjZIf823yUBkEkyxUesdBJdk=";
    })
    (fetchurl {
      url = "https://st.1001fonts.net/download/font/x-typewriter.bold.ttf";
      hash = "sha256-R7HKuBtZzw2nKqAImb7plGNMo8Drup7Y7Il4Ivbus/w=";
    })
  ];
  # src = google-fonts.override { fonts = [ "Special Elite" ]; }; SpecialElite-Regular.ttf
  
  unpackPhase = ''
    for srcFile in $srcs; do
      cp $srcFile $(stripHash $srcFile)
    done
  '';
  
  nativeBuildInputs = [
    nerd-font-patcher
  ];
  
  buildPhase = ''
    nerd-font-patcher \
      --complete \
      --makegroups 0 \
      --mono \
      x-typewriter.regular.ttf
      
    nerd-font-patcher \
      --complete \
      --makegroups 0 \
      --mono \
      x-typewriter.bold.ttf
  '';
  
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/x-typewriter
    
    cp XTypewriterNerdFontMono-*.ttf $out/share/fonts/truetype/x-typewriter
  '';
}
