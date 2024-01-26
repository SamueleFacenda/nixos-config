{ lib
, stdenv
, fetchFromGitHub
, nerd-font-patcher
}:

stdenv.mkDerivation {
  # meta TODO
  pname = "monofurx";
  version = "56.0";
  src = fetchFromGitHub {
    owner = "noisnemid";
    repo = "monofurx-the-monospace-font";
    rev = "d29e388e217719a5a7a4d90d3280d61de3798d2f";
    sha256 = "eCzcApztEiYEpHRMFkr9Zl79/i8fcS9x+P3MxpC+1iE=";
  };
  nativeBuildInputs = [
    nerd-font-patcher
  ];
  buildPhase = ''
    ${nerd-font-patcher}/bin/nerd-font-patcher \
      --complete \
      --makegroups 0 \
      monofurx.ttf
  '';
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/monofurx
    cp monofurxNerdFont-Regular.ttf $out/share/fonts/truetype/monofurx
  '';
}
