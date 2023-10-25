_:
# font patched with bullet point right (not an animal paw like the original one)

(self: super:
let
  getFile = font: "${font}NerdFontMono-Regular.ttf";
  source = getFile "BlexMono";
  dest = getFile "Monofur";
  script = ../assets/character-replace.py;
in
{
  nerdfonts = super.nerdfonts.overrideAttrs (finalAttrs: previousAttrs: {
    version = "${previousAttrs.version}-patched";
    patchPhase = ''
      runHook prePatch

      python ${script} ${source} ${dest} bullet

      runHook postPatch
    '';
    nativeBuildInputs = [ super.python3Packages.fonttools ];
  });
})
