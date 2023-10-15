_:

(self: super:{
  fonttools = super.python310Packages.fonttools.overrideAttrs rec {
    version = "4.43.1";
    src = super.fetchFromGitHub {
      owner = "fonttools";
      repo = "fonttools";
      rev = version;
      sha256 = super.lib.fakeSha256;
    };
  };
})
