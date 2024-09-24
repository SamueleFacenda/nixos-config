{ config, pkgs, home-manager, specialArgs, ...}: 
let
  name = config.users.default.name;
in
{
  imports = [ home-manager.nixosModules.home-manager ];
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = specialArgs // {
      inherit (config.lib) utils;
      inherit (config.age) secrets;
      inherit (config.home-manager) disabledFiles;
    };

    users.${config.users.default.name} = { ... }: {
      imports = [ ../home ];
      home = {
        username = name;
        homeDirectory = "/home/" + name;
        stateVersion = config.system.stateVersion;
      };
    };
    backupFileExtension = "bak";

  };
}
