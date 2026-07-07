{ config, lib, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["wivrn"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Wivrn";
  };

  config = mkIf cfg.enable {
    services.avahi.enable = true;
    services.wivrn = {
      enable = true;
      openFirewall = true;
      steam = {
        enable = true;
        importOXRRuntimes = true;
      };
    };
  };
}