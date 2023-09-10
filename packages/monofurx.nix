{ lib
, stdenv
, fetchFromGitHub
, nerd-font-patcher
}:

stdenv.mkDerivation {
  # meta TODO
  pname = "monofurx";
  version = "5.1";
  src = fetchFromGitHub {
    owner = "noisnemid";
    repo = "monofurx-the-monospace-font";
    rev = "636a263faf53108ea813ef10f4e62a4ef2df790a";
    sha256 = "v1OiWKBgBpN7ptYTbm3lzM7M4Pn0o/vXwj29qGlFsho=";
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
