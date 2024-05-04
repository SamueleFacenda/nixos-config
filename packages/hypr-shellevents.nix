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
    rev = "110e6dc761d5c3d352574def3479a9c39dfc4358";
    sha256 = "DDAYNGSnrBwvVfpKx+XjkuecpoE9HiEf6JW+DBQgvm0=";
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
    maintainers = with maintainers; [fufexan];
    mainProgram = "shellevents";
  };
}
