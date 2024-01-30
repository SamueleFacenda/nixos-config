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
    rev = "de85bbf29b4246d89d11dd44709b41b73e4014a7";
    sha256 = "Gp90pM9rKUnANL8ZgDjFT1ladbWCDTO3X2uPOTRWWcY=";
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
