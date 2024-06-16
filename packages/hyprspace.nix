{ lib
, gcc13Stdenv
, hyprland
, fetchFromGitHub
}:

gcc13Stdenv.mkDerivation {
  pname = "Hyprspace";
  version = "0.41.1";

  src = fetchFromGitHub {
    repo = "Hyprspace";
    owner = "KZDKM";
    rev = "b6f3fc37452ea9b38b5e2662a80fd80aed12018f";
    sha256 = "P7sg1jE0fAF0SuJJu1x8LXqaPHNIbmbyColYJFNzWhU=";
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
