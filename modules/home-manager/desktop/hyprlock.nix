{ config, lib, pkgs, flakePath, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["hyprlock"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Hyprlock";
    
    useConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom config";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.hyprlock.enable = true;
    }
    (mkIf cfg.useConfig {
      xdg.configFile."hypr/hyprlock.conf" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/hypr/hyprlock.conf";
      };
    })
  ]);
}