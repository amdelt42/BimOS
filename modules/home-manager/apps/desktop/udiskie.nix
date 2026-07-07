{ config, lib, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["udiskie"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Udiskie";
  };

  config = mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
      settings = {
        program_options = {
          file_manager = "kitty yazi";
        };
      };
    };
  };
}