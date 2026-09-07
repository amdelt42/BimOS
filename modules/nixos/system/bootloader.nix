{ config, pkgs, lib, stylix, ... }:
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
    # smooth boot splash
    boot.kernelParams = [ "quiet" "splash" ];
    boot.plymouth = {
      enable = true;
      theme = lib.mkForce "bgrt";
    };

    stylix.targets.grub.enable = false;
    boot.loader.grub = {
      backgroundColor = lib.mkForce "#000000";
      splashImage = lib.mkForce null;
    };
    
  };
}