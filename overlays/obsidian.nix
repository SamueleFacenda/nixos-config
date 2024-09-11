final: prev: {
  # just add graphviz to the $PATH
  obsidian = prev.runCommandLocal prev.obsidian.name { } ''
    mkdir $out

    ln -st $out ${prev.obsidian}/share

    mkdir $out/bin
    source "${prev.makeWrapper}/nix-support/setup-hook" # bad way
    makeWrapper ${prev.obsidian}/bin/obsidian $out/bin/obsidian \
      --prefix PATH : ${prev.lib.makeBinPath [ prev.graphviz ]}

  '';
}
