final: prev: {
  # copy everithing but edit the desktop entry
  # just to enable the touchpad gestures (should have done with a wrapper)
  brave = prev.runCommandLocal prev.brave.name {} ''
    mkdir $out

    ln -st $out ${prev.brave}/opt

    mkdir $out/bin
    source "${prev.makeWrapper}/nix-support/setup-hook" # bad way
    makeWrapper ${prev.brave}/bin/brave $out/bin/brave \
      --add-flags "--enable-features=TouchpadOverscrollHistoryNavigation"

    mkdir $out/share
    ln -st $out/share ${prev.brave}/share/*

    rm -r $out/share/applications
    mkdir $out/share/applications
    sed 's#/bin/brave#/bin/brave --enable-features=TouchpadOverscrollHistoryNavigation#g' \
      ${prev.brave}/share/applications/brave-browser.desktop \
      > $out/share/applications/brave-browser.desktop
  '';
}
