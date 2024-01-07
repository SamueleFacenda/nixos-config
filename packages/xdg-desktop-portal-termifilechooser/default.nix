{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, scdoc
, xdg-desktop-portal
, pkgconf
, inih
, systemd
, ranger
, kitty
, coreutils
}:
stdenv.mkDerivation {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "GermainZ";
    repo = "xdg-desktop-portal-termfilechooser";
    rev = "71dc7ab06751e51de392b9a7af2b50018e40e062";
    sha256 = "645hoLhQNncqfLKcYCgWLbSrTRUNELh6EAdgUVq3ypM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    scdoc
    pkgconf
  ];

  buildInputs = [
    xdg-desktop-portal
    inih
    systemd
  ];

  # Add hyprland support and set multiple directory and upload a directory false as default
  # fix some problems in ranger wrapper and line counting in filechooser
  patches = [ ./termfilechooser.patch ];

  mesonFlags = [
    (lib.mesonEnable "systemd" true)
    (lib.mesonEnable "man-pages" true)
    (lib.mesonOption "sd-bus-provider" "libsystemd")
  ];

  mesonBuildType = "release";
}
