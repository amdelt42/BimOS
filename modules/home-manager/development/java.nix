{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["java"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Java development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      temurin-bin-25
      #temurin-jre-bin-25
    ];
  };
}