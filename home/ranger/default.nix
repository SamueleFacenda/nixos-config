{ config, pkgs, ... }: {
  xdg.configFile.ranger = {
    source = ./config;
    recursive = true;
  };
  home.sessionVariables.RANGER_LOAD_DEFAULT_RC = "false";

  home.packages = with pkgs; [
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
    poppler-utils
    # djvulibre
    # calibre
    # transmission-qt
    exiftool
    odt2txt
    fontforge
    # openscad
    drawio
  ];
}
