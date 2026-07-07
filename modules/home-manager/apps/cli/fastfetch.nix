{ config, lib, pkgs, flakePath, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["fastfetch"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable FastFetch";
    };

    useConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom config";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
       programs.fastfetch.enable = true;
    }
    (mkIf cfg.useConfig {
      xdg.configFile."fastfetch" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/fastfetch";
      };
    })
  ]);
}