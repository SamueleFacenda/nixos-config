{ pkgs, config, options, lib, ...}: 
# https://github.com/NixOS/nixpkgs/blob/3667e0b7e47a2fad4d802c76440bc01b6bc78ab7/nixos/modules/misc/nixpkgs.nix#L37
let
  # update nixpkgs config to enable cuda
  cfg = lib.recursiveUpdate
    pkgs
    { config = {
      allowUnfree = true;
      cudaSupport = true;
    };};
    
  cudaPkgs =
      let
        isCross = cfg.buildPlatform.config != cfg.hostPlatform.config;
        systemArgs =
          if isCross then
            {
              localSystem = cfg.buildPlatform;
              crossSystem = cfg.hostPlatform;
            }
          else
            {
              localSystem = cfg.hostPlatform;
            };
      in
      import cfg.path (
        {
          inherit (cfg) config overlays;
        }
        // systemArgs
      );
in
{
  # add pkgs-cuda input to modules
  config._module.args.pkgs-cuda = cudaPkgs;
}
