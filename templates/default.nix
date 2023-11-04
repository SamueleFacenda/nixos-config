{
  cpp = {
    path = ./cpp;
    description = "A basic c/c++ project";
    welcomeText = ''
      # A simple c and c++ project
      No bundling included, just plain cpp and gcc to run the apps.
    '';
  };
  python = {
    path = ./python;
    description = "A basic python project";
    welcomeText = ''
      # A simple python 3 project
      No bundling included, just python and some modules.
    '';
  };
  default = {
    path = ./basic;
    description = "A basic nix flake project";
    welcomeText = ''
      # A simple flake
      Some of the common options have placeholders
    '';
  };
}
