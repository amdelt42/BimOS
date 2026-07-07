{ config, lib, pkgs, flakePath, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["waypaper"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path { 
    enable = mkEnableOption "Enable Waypaper";
    
    useConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom config";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # wallpaper management
      services.awww.enable = true;
      home.packages = with pkgs; [
        waypaper
      ];
    }
    (mkIf cfg.useConfig {
      xdg.configFile."waypaper" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/waypaper";
      };
    })
  ]);
}