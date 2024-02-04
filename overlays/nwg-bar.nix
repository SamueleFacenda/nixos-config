final: prev: {
  nwg-bar = prev.nwg-bar.overrideAttrs (old: {
    postPatch = old.postPatch + ''
      substituteInPlace main.go \
        --replace 'gtk.ImageNewFromPixbuf(pixbuf)' 'gtk.ImageNewFromIconName(b.Icon, gtk.ICON_SIZE_DIALOG)' \
        --replace 'pixbuf, err := createPixbuf(b.Icon, *imgSize)' 'var err []int = nil'
    '';
  });
}
