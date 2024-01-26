{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, meson
, rustc
, git
, ninja
, cargo
, xdg-desktop-portal
}:
stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-shana";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "xdg-desktop-portal-shana";
    rev = "v${version}";
    sha256 = "cgiWlZbM0C47CisR/KlSV0xqfeKgM41QaQihjqSy9CU=";
  };

  meta = with lib; {
    description = "A filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = licenses.mit;
    platforms = platforms.linux;
    mainteiners = with mainteiners; [ ];
  };

  nativeBuildInputs = [
    meson
    rustc
    git
    ninja
    cargo
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    xdg-desktop-portal
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-EUcpvOdkvVW8gdRVBfbK1A6JkqnTnt6dO1823Wrz+84=";
  };

  mesonBuildType = "release";
}
