{ lib
, gcc13Stdenv
, hyprland
, fetchFromGitHub
}:

gcc13Stdenv.mkDerivation {
  pname = "Hyprspace";
  version = "0.41.2";

  src = fetchFromGitHub {
    repo = "Hyprspace";
    owner = "KZDKM";
    rev = "e8662093ae5b6e13a3cf1145d21d4804a3e84aeb";
    sha256 = "9aM4MCBJn4UstcsSdukOFTxg79keUMTw9Kmqr7Wsfmw=";
  };

  inherit (hyprland) nativeBuildInputs;
  buildInputs = [ hyprland ] ++ hyprland.buildInputs;

  dontUseCmakeConfigure = true;

  meta = with lib; {
    homepage = "https://github.com/KZDKM/Hyprspace";
    description = "Workspace overview plugin for Hyprland";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
