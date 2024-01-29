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
    rev = "3c75f863473a5bbce306bdcf0150c5a01359dac9";
    sha256 = "mrczZEXHE/dxIn4FkCdozRQz+CqhfjUbJygSsPmHPZU=";
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
