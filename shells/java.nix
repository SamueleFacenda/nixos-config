{ pkgs, ... }: pkgs.mkShell {

  packages = with pkgs; [
  	jdk17
  ];
}
