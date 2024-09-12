self: super: {
  waybar = super.waybar.overrideAttrs rec {
    version = "${super.waybar.version}-unstable";
    src = super.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "6560e32bc1fd3c777d7094b2033a4358a98ca0ee";
      sha256 = "UbVApb+B5QyOl+zrc2oKQ6+M5aKRiw3EotrjxzUfp9A=";
    };
  };
}
