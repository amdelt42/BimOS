{ config, lib, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["localsend"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Localsend";
  };

  config = mkIf cfg.enable {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}