{ lib
, stdenv
, fetchFromGitHub
, nerd-font-patcher
, python3Packages
}:

stdenv.mkDerivation {
  # meta TODO
  pname = "monofurx";
  version = "6.0";
  src = fetchFromGitHub {
    owner = "noisnemid";
    repo = "monofurx-the-monospace-font";
    rev = "d29e388e217719a5a7a4d90d3280d61de3798d2f";
    hash = "sha256-eCzcApztEiYEpHRMFkr9Zl79/i8fcS9x+P3MxpC+1iE=";
  };
  nativeBuildInputs = [
    nerd-font-patcher
    python3Packages.fonttools
  ];
  buildPhase = ''
    fontforge -lang=py -c \
      'import fontforge, psMat, sys; f=fontforge.open(sys.argv[1]); f.selection.all(); f.transform(psMat.scale(float(sys.argv[2]))); f.em=int(sys.argv[3]); f.generate(sys.argv[4])' \
      original/monof55.ttf 0.8 2000 fallback_scaled.ttf
  
    pyftmerge monofurx.ttf fallback_scaled.ttf
    mv merged.ttf monofurx.ttf
  
    ${nerd-font-patcher}/bin/nerd-font-patcher \
      --complete \
      --makegroups 0 \
      --mono \
      monofurx.ttf
  '';
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/monofurx
    cp monofurxNerdFontMono-*.ttf $out/share/fonts/truetype/monofurx
  '';
}
