{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libgcc,
}:

stdenv.mkDerivation rec {
  pname = "donsetch";
  version = "4.4.5";

  src = fetchurl {
    url = "https://github.com/dondai44423/donsetch/releases/download/v${version}/donsetch-linux-x64.tar.gz";
    hash = "sha256-pf/dZ2vJnEZkdH3clD2px0tEL9HhnKoi37yag4NfvzQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    libgcc
    stdenv.cc.cc.lib
  ];

  sourceRoot = ".";

  # why: donsetch dlopens libonnxruntime.so relative to its own executable path
  installPhase = ''
    mkdir -p $out/bin
    install -m755 donsetch $out/bin/donsetch
    install -m644 libonnxruntime.so $out/bin/libonnxruntime.so
  '';
}
