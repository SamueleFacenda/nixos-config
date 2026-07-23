{ config, pkgs, ... }:
let
  tex = pkgs.texliveSmall.withPackages (
    ps: with ps; [scheme-medium
      hyphenat collection-langitalian
      etoolbox txfonts
      titlesec graphics eso-pic
    ]
  );

in
{
  home.packages = with pkgs; [
    texmaker
    tex
  ];
}
