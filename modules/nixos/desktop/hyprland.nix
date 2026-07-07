{ pkgs, lib, config, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["hyprland"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Hyprland desktop";
	};

  config = mkIf cfg.enable {
		sys.desktop.keyring.enable = mkDefault true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    security.polkit.enable = true;

    xdg.portal = {
      enable = mkForce true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      config.common.default = "*";
    };

    environment.systemPackages = with pkgs; [
      qt6.qtwayland
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    } // optionalAttrs config.sys.hardware.nvidia.enable {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    stylix.targets.console.enable = false;
  };
}