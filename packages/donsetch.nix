{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libgcc,
}:

stdenv.mkDerivation rec {
  pname = "donsetch";
  version = "4.4.2";

  src = fetchurl {
    url = "https://github.com/dondai44423/donsetch/releases/download/v${version}/donsetch-linux-x64.tar.gz";
    hash = "sha256-vkgT0NozKixG3d+rQrBKfLwWKz7cSfOodEIWj4RDlzk=";
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
