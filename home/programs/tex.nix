{config, pkgs, ...}:
let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      hyphenat collection-langitalian
      etoolbox txfonts
      titlesec graphics eso-pic;
  };

in
{
  home.packages = with pkgs; [
    texmaker
    tex
  ];
}
