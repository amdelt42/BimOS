{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["bluetooth"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Bluetooth configuration";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = true;
          # When enabled other devices can connect faster to us, however
          # the tradeoff is increased power consumption. Defaults to
          # 'false'.
          FastConnectable = true;
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      # Bluetooth
      bluez
      bluetui
    ];
  };
}