{ stdenv
, writeShellApplication
, git
}:

writeShellApplication {
  name = "installer";
  runtimeInputs = [ git ];
  text = ''
    echo ciao
  '';
}
