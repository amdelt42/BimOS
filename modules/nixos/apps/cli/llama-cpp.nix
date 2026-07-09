{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["llama-cpp"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable llama.cpp";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.llama-cpp.override { cudaSupport = true; })
    ];
  };
}