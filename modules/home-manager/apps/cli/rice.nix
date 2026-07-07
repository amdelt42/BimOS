{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["rice"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path { 
    enable = mkEnableOption "Enable RICE";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # RICE
      tty-clock
      cowsay
      cmatrix
      asciiquarium
      pipes-rs
      cbonsai
      cava
    ];
  };
}