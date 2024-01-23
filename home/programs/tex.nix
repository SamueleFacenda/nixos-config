{config, pkgs, ...}:
let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      titlesec graphics eso-pic;
  };

in
{
  home.packages = with pkgs; [
    texmaker
    tex
  ];
}
