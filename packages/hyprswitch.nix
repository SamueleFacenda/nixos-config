{ lib
, pkgs
, pkg-config
, rustPlatform
, makeWrapper
, fetchFromGitHub
}:
let
  src = fetchFromGitHub {
      repo = "hyprswitch";
      owner = "H3rmt";
      rev = "v1.2.2";
      sha256 = "w1AkbI/hrW3gcIZ+Fydcde2Ob8zzBRlzJSlk03MrJr0=";
    };
  meta = (builtins.fromTOML (builtins.readFile (src + "/Cargo.toml"))).package;
in
rustPlatform.buildRustPackage {
  name = meta.name;
  version = meta.version;

  inherit src;

  cargoHash = "sha256-LiH7OqQL7te1GVF3qfYVRQpAhQmsVGtgwhKhZorQp2k=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = with pkgs; [
    glib
    gtk4
    gtk4-layer-shell
  ];

  postInstall = ''
    wrapProgram $out/bin/${meta.name}
  '';

  meta = with lib; {
    description = meta.description;
    homepage = meta.repository;
    license = licenses.mit;
  };
}
