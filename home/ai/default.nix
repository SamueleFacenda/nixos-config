{ lib, utils, disabledFiles, ... }: {
  imports = utils.listDirPathsExcluding disabledFiles ./.;
  
  options.ai = {  
    plugins = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = {};
    };

    skills = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
    };

    agents = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
    };  
    
    commands = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
    };  
  };
}
