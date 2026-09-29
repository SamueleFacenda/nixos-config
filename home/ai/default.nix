{ lib, utils, disabledFiles, ... }: {
  imports = utils.listDirPathsExcluding disabledFiles ./.;
  
  options.ai = {  
    plugins = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = {};
    };

    mcpServers = lib.mkOption {
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

    lsp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          command = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };
          extensions = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };
        };
      });
      default = {};
    };

    rules = lib.mkOption {
      type = lib.types.submodule {
        options = {
          codingRulesMarkdown = lib.mkOption { type = lib.types.str; default = ""; };
          comments = lib.mkOption { type = lib.types.attrs; default = {}; };
          documentation = lib.mkOption { type = lib.types.attrs; default = {}; };
          cleanCode = lib.mkOption { type = lib.types.attrs; default = {}; };
          naming = lib.mkOption { type = lib.types.attrs; default = {}; };
          functions = lib.mkOption { type = lib.types.attrs; default = {}; };
          errorHandling = lib.mkOption { type = lib.types.attrs; default = {}; };
          testing = lib.mkOption { type = lib.types.attrs; default = {}; };
          formatting = lib.mkOption { type = lib.types.attrs; default = {}; };
          gitWorkflow = lib.mkOption { type = lib.types.attrs; default = {}; };
          changelog = lib.mkOption { type = lib.types.attrs; default = {}; };
          security = lib.mkOption { type = lib.types.attrs; default = {}; };
          nixFlake = lib.mkOption { type = lib.types.attrs; default = {}; };
          agentBehavior = lib.mkOption { type = lib.types.attrs; default = {}; };
        };
      };
      default = {};
      description = "Coding rules configuration for AI agents";
    };
  };
}
