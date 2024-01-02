# Change the name of some icons directories (they are hardcoded in the source) and add some new ones
self: super: {
  eza = super.eza.overrideAttrs (finalAttrs: previousAttrs: {
    version = "${previousAttrs.version}-patched";
    patchPhase = ''
      runHook prePatch

      sed -i '129 i "downloads"           => '"'"'\\u{f024d}'"'"',' src/output/icons.rs
      sed -i '129 i ".Desktop"            => '"'"'\\u{f108}'"'"','  src/output/icons.rs
      sed -i '129 i "repos"               => '"'"'\\u{e5fd}'"'"','  src/output/icons.rs
      sed -i '129 i "documents"           => '"'"'\\u{f19f6}'"'"',' src/output/icons.rs
      sed -i '129 i "IdeaProjects"        => '"'"'\\u{e7b5}'"'"','  src/output/icons.rs


      runHook postPatch
    '';
  });
}
