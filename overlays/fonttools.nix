_:

(self: super: {
  fonttools = super.python310Packages.fonttools.overrideAttrs rec {
    version = "4.43.1";
    src = super.fetchFromGitHub {
      owner = "fonttools";
      repo = "fonttools";
      rev = version;
      sha256 = "jWn0gF91Baq7bZT4HDr+NTqGoTosYRMF6bsaReqWBRo=";
    };

    disabledTests = [
      "test_recalc_timestamp_ttf"
      "test_recalc_timestamp_otf"
      "test_ttcompile_timestamp_calcs"
      "test_designspace"
      "test_interpolatable_ufo"
      "test_sparse_designspace"
      "test_sparse_interpolatable_ufos"
    ];
  };
})
