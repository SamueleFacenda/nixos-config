{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, meson
, rustc
, git
, ninja
, cargo
, xdg-desktop-portal
}:
stdenv.mkDerivation rec {
	pname = "xdg-desktop-portal-shana";
	version = "0.3.5.1";
	
	src = fetchFromGitHub {
		owner = "Decodetalkers";
		repo = "xdg-desktop-portal-shana";
		rev = "v${version}";
		sha256 = "ujHIJSaUxm3c3/fz9QSQnHEWYYy92etI7ULexRj5UoA=";
	};
	
	meta = with lib; {
		description = "A filechooser portal backend for any desktop environment";
		homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
		license = licenses.mit;
		platforms = platforms.linux;
		mainteiners = with mainteiners; [ ];
	};
		
	nativeBuildInputs = [
		meson
		rustc
		git
		ninja
		cargo
		rustPlatform.cargoSetupHook
	];
	
	buildInputs = [
		xdg-desktop-portal
	];
	
	cargoDeps = rustPlatform.fetchCargoTarball {
		inherit src;
		hash = "sha256-KNHOK/qg4vPDsQSnrI1/40aWdbPiLLr3VsUFuRuGwVs=";
	};
	
	# This in not executed
	#  rustPlatform.fetchCargoTarball {
	#		inherit src;
	#		sourceRoot = "tools/shanatest";
	#		hash = lib.fakeHash;
	#	}
	
	mesonBuildType = "debug";
}