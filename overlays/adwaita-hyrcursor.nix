# font patched with bullet point right (not an animal paw like the original one)
final: prev:
let
  mkHyprcursorTheme = { pkg, name }: prev.stdenv.mkDerivation {
    name = "Hypr" + pkg.name;
    src = pkg;
    nativeBuildInputs = with prev; [
      hyprcursor
      xcur2png
    ];
    buildPhase = ''
      
      hyprcursor-util -x share/icons/${name} \
        -o .
        
      echo "name = ${name}
      description = Automatically extracted with hyprcursor-util
      version = 0.1
      cursors_directory = hyprcursors" > extracted_${name}/manifest.hl
      
      hyprcursor-util -c extracted_${name} \
        -o .
    '';
    installPhase = ''
      mkdir $out
      cp -r share $out
      cp -r theme_${name}/* $out/share/icons/${name}
    '';
  };
in
{
  adwaita-icon-theme-hyprcursor = mkHyprcursorTheme {
    pkg = prev.adwaita-icon-theme;
    name = "Adwaita";
  };  
}
