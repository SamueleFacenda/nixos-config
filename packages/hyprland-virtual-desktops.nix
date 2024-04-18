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
    rev = "e1ef29d06112ba0cf309b3b9bd715e743a8ada6b";
    sha256 = "7R4LZdfJD8Z8Nssh3/pKrIzTfYrgLheZjfUsoAn2++A=";
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
