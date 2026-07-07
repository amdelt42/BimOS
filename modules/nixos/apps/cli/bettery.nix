{ config, lib, pkgs, inputs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["bettery"];
  cfg = attrByPath path {} config;
  
  bettery = pkgs.rustPlatform.buildRustPackage {
    pname = "bettery";
    version = "0.1.0";
    src = inputs.bettery;
    cargoHash = "sha256-n3CpB/JTrIojhmdfwYYbEr7RRncPSC/xnglTByq+BVs";
  };
in
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Bettery";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ bettery ];
  };
}