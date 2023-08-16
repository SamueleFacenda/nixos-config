{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    htop
    mdcat
    xclip

    # misc
    xdg-utils
    tree
    wakatime
    
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
  };
}
