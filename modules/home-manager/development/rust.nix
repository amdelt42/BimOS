{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["rust"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Rust development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
    ];
  };
}