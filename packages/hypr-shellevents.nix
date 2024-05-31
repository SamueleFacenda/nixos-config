{ lib
, stdenvNoCC
, makeWrapper
, coreutils
, bash
, hyprland
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "hypr-shellevents";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "33b38358559054d316eb605ccb733980dfa7dc63";
    sha256 = "y+LOXuSRMfkR2Vfwl5K2NVrszi1h5MJpML+msLnVS8U=";
  };
  sourceRoot = "${src.name}/shellevents";

  buildInputs = [ bash ];
  makeFlags = [ "PREFIX=$(out)" ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/shellevents --prefix PATH ':' \
      "${lib.makeBinPath ([coreutils]
        ++ lib.optional (hyprland != null) hyprland)}"
  '';

  meta = with lib; {
    description = "Run shell scripts in response to Hyprland events";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fufexan ];
    mainProgram = "shellevents";
  };
}
