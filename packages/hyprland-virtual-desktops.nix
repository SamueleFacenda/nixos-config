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
    rev = "v${version}";
    sha256 = "VzOfiw82xLhoOfx8NiEhq/ZWTnQOQ9Uqey/1FHYu3lo=";
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
