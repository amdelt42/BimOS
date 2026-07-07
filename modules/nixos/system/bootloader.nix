{ config, pkgs, lib, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["bootloader"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable bootloader configuration";
	};

	config = mkIf cfg.enable {
    # use latest kernel
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
    };

    # smooth boot splash
    boot.kernelParams = [ "quiet" "splash" ];
    boot.plymouth = {
      enable = true;
      theme = lib.mkForce "bgrt";
    };
    
    
  };
}