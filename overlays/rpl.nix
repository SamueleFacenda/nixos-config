{ lib, ... }:

(self: super: {
  rpl = super.rpl.overrideAttrs (finalAttrs: previousAttrs: rec {
    src = super.fetchFromGitHub {
      owner = "rrthomas";
      repo = "rpl";
      rev = "v1.15.5";
      sha256 = "W9fbu4p2sMzD+1dMM8o45S/Q765qh7hvpYDZFZdyrtA=";
    };
    version = "1.15.5";
    patches = [ ];
    format = "pyproject";
    doCheck = false;
    postPatch = ''
      # brute replace of error
      substituteInPlace rpl/__init__.py \
        --replace "importlib.metadata.version('rpl')" "'${version}'"
    '';
    installPhase = "";

    propagatedBuildInputs = with super; [
      python3.pkgs.chardet
      python3.pkgs.regex
      (
        python3.pkgs.buildPythonPackage rec {
          pname = "argparse-manpage";
          version = "4.4";
          src = fetchPypi {
            inherit pname version;
            sha256 = "w3SucQVgZXmLnrbk2TIy3clyyc1ZZGvNnYRhkzYpD7Q=";
          };
          doCheck = false;
          propagatedBuildInputs = [
            python310Packages.toml
          ];
        }
      )
      (
        python3.pkgs.buildPythonPackage rec {
          pname = "chainstream";
          version = "1.0.1";
          src = fetchPypi {
            inherit pname version;
            sha256 = "302P1BixEmkODm+qTLZwaWLktrlf9cEziQ/TIVfI07c=";
          };
          format = "pyproject";
          doCheck = false;
          propagatedBuildInputs = [
            python310Packages.setuptools
          ];
        }
      )
    ];
  });
})
