{ pkgs, ... }: pkgs.mkShell {

  packages = with pkgs; [
    # misc
    php
    curl
    git
    jdk17
    # ngrok
    docker
    docker-compose

    # stego
    binwalk
    stegsolve
    zsteg
    john

    # network
    wireshark
    tshark
    # py pyshark

    # web
    burpsuite
    # postman

    # software
    ht
    ltrace
    pwndbg
    gdb
    patchelf
    elfutils
    one_gadget
    # seccomp-tools
    ghidra
    gdb

    # crypto
    # sage
    z3

    (python3.withPackages (ps: with ps; [
      pillow
      pycryptodome
      pwntools
      ropper
      tqdm
      gmpy2
      sympy
      pip
      z3
    ]))
  ];

  shellHook = ''
    echo "Ready to pwn!"
    exec zsh
  '';
}
