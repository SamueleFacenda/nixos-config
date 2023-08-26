{ pkgs, ... }: pkgs.mkShell {

  packages = with pkgs; [
    # misc
  	php
  	curl
  	git
  	jdk17
    ngrok
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
    postman

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

  	# crypto
  	# sage

  	(python3.withPackages (ps: with ps; [
  		pycryptodome
  		pwntools
  		ropper
  	]))
  ];

  shellHook = ''
    echo "Ready to pwn!"
    exec zsh
  '';
}
