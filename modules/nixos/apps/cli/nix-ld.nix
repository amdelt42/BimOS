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
        # Qt6 and Core
        qt6.qtbase
        qt6.qtdeclarative
        stdenv.cc.cc
        vulkan-loader
        expat
        libxcb

        # Core GNOME / GTK Stack
        glib
        atk
        cups
        nss
        nspr
        dbus
        pango
        cairo
        gtk3

        # Graphics Drivers
        libGL
        libdrm
        libglvnd
        libgbm
        mesa

        # X11 / XCB & Input Libraries
        libxkbcommon
        libxcb
        libx11
        libxcursor
        libxrandr
        libxi
        libxcomposite  
        libxdamage     
        libxext        
        libxfixes      
        libxtst      

        # System Services & Font Utilities
        alsa-lib     
        atk 
        fontconfig     
        freetype  
      ];
    };
  };
}