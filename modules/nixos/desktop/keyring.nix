{ pkgs, lib, config, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["keyring"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable GNOME keyring integration";
  };
  
  config = mkIf cfg.enable {
    security.pam.services = {
      login.enableGnomeKeyring = true;
      hyprlock.enableGnomeKeyring = true;
    };

    services.gnome.gnome-keyring.enable = true;
    services.dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];

    environment.systemPackages = with pkgs; [
      gnome-keyring
      libsecret
      gcr
      seahorse
    ];
  };
}