{ config, pkgs, lib, ... }:
let
  format = pkgs.formats.ini { };
  wrapper = pkgs.runCommand "ranger-wrapper.sh" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    script = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/ranger-wrapper.sh";
  } ''
    makeWrapper $script $out/wrapper \
      --prefix PATH : ${lib.makeBinPath [ pkgs.kitty pkgs.ranger pkgs.coreutils ]}
  '';
in
{
  #  xdg.configFile."xdg-desktop-portal-termfilechooser/Hyprland".text = ''
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".source = format.generate "config" {
    filechooser = {
      cmd = "${wrapper}/wrapper";
      default_dir = "${config.xdg.userDirs.download}";
    };
  };

}
