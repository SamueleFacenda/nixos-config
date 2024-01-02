self: super: {
  #!!!!! 😡😡😡😤😤 overridePythonAttrs, >5h lost here because of nixpkgs docs
  ranger = super.ranger.overridePythonAttrs (previousAttrs: {
    version = "unstable-1.9.3";
    src = super.fetchFromGitHub {
      owner = "ranger";
      repo = "ranger";
      rev = "136416c7e2ecc27315fe2354ecadfe09202df7dd";
      sha256 = "nW4KlatugmPRPXl+XvV0/mo+DE5o8FLRrsJuiKbFGyY=";
    };

    buildInputs = with super; [
      python3Packages.astroid
      python3Packages.pylint
      python3Packages.flake8
      which
      shellcheck
    ];
  });
}
