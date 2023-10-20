{ pkgs, ... }: pkgs.mkShell {

  packages = with pkgs; [
    jdk17
    gradle
    maven
    processing
  ];

  shellHook = ''
    export JAVA_HOME=${pkgs.jdk17}
  '';
}
