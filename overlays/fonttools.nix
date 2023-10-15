_:

(self: super:{
  fonttools = super.python310Packages.fonttools.overrideAttrs rec {
    version = "4.43.1";
    src = super.fetchFromGitHub {
      owner = "fonttools";
      repo = "fonttools";
      rev = version;
      sha256 = "jWn0gF91Baq7bZT4HDr+NTqGoTosYRMF6bsaReqWBRo=";
    };

    passthru.optional-dependencies = let
      extras = with super; {
        ufo = [ fs ];
        lxml = [ lxml ];
        woff = [ (if isPyPy then brotlicffi else brotli) zopfli ];
        unicode = lib.optional (pythonOlder "3.11") unicodedata2;
        graphite = [ lz4 ];
        interpolatable = [ (if isPyPy then munkres else scipy) fs ];
        plot = [ matplotlib ];
        symfont = [ sympy ];
        type1 = lib.optional stdenv.isDarwin xattr;
        pathops = [ skia-pathops ];
        repacker = [ uharfbuzz ];
      };
    in extras // {
      all = super.lib.concatLists (super.lib.attrValues extras);
    };
  };
})
