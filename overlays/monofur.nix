{...}:

(self: super:
  let
    # font patched with bullet point right (not an animal paw like the original one)
    src = ../assets/MonofurNFM.ttf;
  in {
    nerdfonts = super.nerdfonts.overrideAttrs (finalAttrs: previousAttrs: {
      version = "${previousAttrs.version}-patched";
      preInstall = ''
        if test -e MonofurNerdFontMono-Regular.ttf
        then
          echo "Replacing monofur with pathed font..."
          cp ${src} MonofurNerdFontMono-Regular.ttf
          echo "Copy returned $?"
        else
          echo "File not found"
        fi
      '';
      installPhase = ''
      runHook preInstall
      ${previousAttrs.installPhase}
      runHook postInstall
      '';
    });
  }
)
