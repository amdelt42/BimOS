{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["nix-ld"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Nix-LD";
  };
  
  config = mkIf cfg.enable {
    # Nix-LD (Traditional style loader for executables)
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        qt6.qtbase
        qt6.qtdeclarative
        stdenv.cc.cc
        vulkan-loader
        libGL
        libglvnd
        libx11
        libxcursor
        libxrandr
        libxi
      ];
    };
  };
}