{ config, pkgs, lib, osConfig, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["zsh"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
		shellAliases = mkOption {
			type = types.attrsOf types.str;
			default = {};
			description = "ZSH Shell Aliases";
		};
		initContent = mkOption {
			type = types.str;
			default = "";
			description = "Initial zsh commands";
		};
		fastFetch = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Fastfetch";
    };
	};

	config = mkIf osConfig.programs.zsh.enable {
		programs.zoxide = {
			enable = true;
			enableZshIntegration = true;
		};
		
		programs.zsh = mkMerge [
			{
				enable = true;
				autosuggestion.enable = true;
				syntaxHighlighting.enable = true;
				shellAliases = cfg.shellAliases;
				oh-my-zsh = {
					enable = true;
					theme = "robbyrussell";
				};
			}
			(mkIf cfg.fastFetch {
				initContent = ''
					fastfetch
				'';
			})
		];
	};
}