{ stdenv
, fetchFromGitHub
, hyprland
}:

stdenv.mkDerivation rec {
  pname = "hyprland-virtual-desktops";
  version = "2.0.2";
  src = fetchFromGitHub {
    owner = "levnikmyskin";
    repo = pname;
    # rev = "v${version}";
    rev = "5c3bda1dfc297297d27084ea3c7271d49ec4512a";
    sha256 = "FBMoBVqdbRJdSGRrB8/kVR3z0dgHw2bnXc532ll9ctU=";
  };

  inherit (hyprland) nativeBuildInputs;
  buildInputs = [ hyprland ] ++ hyprland.buildInputs;

  dontUseMesonConfigure = true;
  dontUseNinjaInstall = true;

  buildPhase = ''
    make all
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp virtual-desktops.so $out/lib/lib${pname}.so
  '';
}
