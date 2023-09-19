{ pkgs, ... }: pkgs.mkShell {

  packages = with pkgs; [
    libgcc
    gdb
  ];

  shellHook = ''
    echo c++
    exec zsh
  '';
}
