self: super: {
  trashy = super.trashy.overrideAttrs rec {
    version = "unstable-2.0.0";
    src = super.fetchFromGitHub {
      owner = "oberblastmeister";
      repo = "trashy";
      rev = "7c48827e55bca5a3188d3de44afda3028837b34b";
      sha256 = "1pxmeXUkgAITouO0mdW6DgZR6+ai2dax2S4hV9jcJLM=";
    };
    cargoDeps = super.rustPlatform.fetchCargoTarball {
      inherit src;
      hash = "sha256-/q/ZCpKkwhnPh3MMVNYZw6XvjyQpoZDBXCPagliGr1M=";
    };
  };
}
