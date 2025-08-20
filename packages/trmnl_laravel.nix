{ lib
, php
, fetchFromGitHub
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "trmnl_laravel";
  version = "0.12.0";
  src = fetchFromGitHub {
    owner = "usetrmnl";
    repo = "byos_laravel";
    rev = finalAttrs.version;
    sha256 = "sha256-IwwV+/KTDZCYSAIGGJvnE5PS332MKwcgrn8ecthpRds=";
  };
  php = php.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [ imagick ]));
  };
  vendorHash = "sha256-wIEGzJFjtEtVOel2BYV0/GDZGSqxnslkWALnxko6ALI=";
})
