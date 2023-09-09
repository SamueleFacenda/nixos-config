{pkgs, lib, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    htop
    mdcat
    xclip
    (rpl.overrideAttrs (finalAttrs: previousAttrs:{
      src = fetchFromGitHub {
        owner = "rrthomas";
        repo = "rpl";
        rev = "v1.15.5";
        sha256 = "W9fbu4p2sMzD+1dMM8o45S/Q765qh7hvpYDZFZdyrtA=";
      };
      version = "1.15.5";
      patches = [];
      format = "pyproject";
      doCheck = false;
      postPatch = ''
        sed -i "s/importlib.metadata.version('rpl')/'1.15.5'/g" rpl/__init__.py
      '';
      installPhase = "";

      propagatedBuildInputs = [
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
    }))

    # misc
    xdg-utils
    tree
    wakatime
    spotify-tui
    editorconfig-core-c

    # productivity
    obsidian

    # web
    brave

    # code
    (python3.withPackages(ps: with ps; [
      pillow # for ranger kitty image preview
      # ranger deps
      chardet
      python-bidi
    ]))

    # ranger dependencies
    file
    libcaca
    imagemagick
    librsvg
    ffmpegthumbnailer
    highlight
    atool
    libarchive
    unrar
    lynx
    poppler_utils
    # djvulibre
    # calibre
    # transmission-qt
    exiftool
    odt2txt
    # fontforge
    # openscad
    # drawio
  ];

  programs = {
    btop.enable = true;  # replacement of htop/nmon
    exa.enable = true;   # A modern replacement for ‘ls’
    ssh.enable = true;
  };

  services = {
    # syncthing.enable = true;

    # auto mount usb drives
    udiskie.enable = true;
    udiskie.settings.program_options = {
      file_manager = "${pkgs.xdg-utils}/bin/xdg-open";
      # tray = false;
    };
  };

  # fix udiskie problem
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
