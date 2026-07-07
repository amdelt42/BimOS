{ config, lib, pkgs, flakePath, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["waybar"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path { 
    enable = mkEnableOption "Enable Waybar";
    
    useConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom config";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      stylix.targets.waybar.enable = false;
      programs.waybar.enable = true;
    }
    (mkIf cfg.useConfig {
      xdg.configFile."waybar" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/waybar";
      };
    })
  ]);
}