{ config, lib, pkgs, flakePath, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["wofi"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path { 
    enable = mkEnableOption "Enable Wofi";
    
    useConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom config";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      stylix.targets.wofi.enable = false;
      programs.wofi.enable = true;
    }
    (mkIf cfg.useConfig {
      xdg.configFile."wofi" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/wofi";
      };
    })
  ]);
}