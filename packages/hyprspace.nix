{ lib
, gcc13Stdenv
, hyprland
, fetchFromGitHub
}:

gcc13Stdenv.mkDerivation {
  pname = "hyprspace";
  version = "0.39.1";

  src = fetchFromGitHub {
    repo = "Hyprspace";
    owner = "KZDKM";
    rev = "8049b2794ca19d49320093426677d8c2911e7327";
    sha256 = "QKecFhWAB7sagSE+FXztINDqYqLro2nYp94f+ZtE/f4=";
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
