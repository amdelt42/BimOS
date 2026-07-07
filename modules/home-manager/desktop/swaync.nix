{ config, lib, pkgs, flakePath, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["swaync"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path { 
    enable = mkEnableOption "Enable SwayNC";
    
    useConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom config";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      stylix.targets.swaync.enable = false;
      services.swaync.enable = true;
      home.packages = with pkgs; [
        libnotify
      ];
    }
    (mkIf cfg.useConfig {
      xdg.configFile."swaync/config.json".enable = false;
      xdg.configFile."swaync/style.css".enable = false;
      xdg.configFile."swaync" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/swaync";
      };
    })
  ]);
}