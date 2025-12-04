# font patched with bullet point right (not an animal paw like the original one)
self: super:
let
  getMonoName = fontType: font: "${font}NerdFontMono-${fontType}.ttf";
  getCompletePath = pkg: fontName: fontType: "${pkg}/share/fonts/truetype/NerdFonts/${fontName}/" + getMonoName fontType fontName;
  source = fontType: getCompletePath super.nerd-fonts.caskaydia-mono "CaskaydiaMono" fontType;
  dest = fontType: getMonoName fontType "Monofur";
  script = ../assets/character-replace.py;
  py = super.python3.withPackages (ps: [ ps.fonttools ]);
  
  patchCommand = char: fontType: "${py}/bin/python ${script} ${source fontType} ${dest fontType} ${char}";
  patchBullet = patchCommand "bullet";
  patchFilledBox = patchCommand "filledbox";
in
{
  nerd-fonts = super.nerd-fonts // { 
    monofur = super.nerd-fonts.monofur.overrideAttrs (finalAttrs: previousAttrs: {
      version = "${previousAttrs.version}-patched";
      __intentionallyOverridingVersion = true;
      patchPhase = ''
        runHook prePatch

        ${patchBullet "Regular"}
        ${patchBullet "Bold"}
        ${patchBullet "Italic"}

        ${patchFilledBox "Regular"}
        ${patchFilledBox "Bold"}
        ${patchFilledBox "Italic"}

        runHook postPatch
      '';
    });
  };
}
