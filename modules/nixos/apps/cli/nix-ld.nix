{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["nix-ld"];
  cfg = attrByPath path {} config;

  # Merge and compile GSettings schemas from any packages that ship them.
  # Add more packages here if other foreign/unwrapped binaries need their schemas too.
  mySchemas = pkgs.runCommand "merged-gsettings-schemas" {
    nativeBuildInputs = [ pkgs.glib ];
  } ''
    mkdir -p $out/glib-2.0/schemas
    find ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas -name "*.gschema.xml" -exec cp {} $out/glib-2.0/schemas/ \;
    find ${pkgs.gtk3}/share/gsettings-schemas -name "*.gschema.xml" -exec cp {} $out/glib-2.0/schemas/ \; 2>/dev/null || true
    find ${pkgs.glib}/share/glib-2.0/schemas -name "*.gschema.xml" -exec cp {} $out/glib-2.0/schemas/ \; 2>/dev/null || true
    glib-compile-schemas $out/glib-2.0/schemas
  '';
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Nix-LD";
  };
  
  config = mkIf cfg.enable {
    environment.variables.GSETTINGS_SCHEMA_DIR = "${mySchemas}/glib-2.0/schemas";

    environment.systemPackages = with pkgs; [
      glib
      gsettings-desktop-schemas
    ];

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
        vulkan-loader
        vulkan-tools

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