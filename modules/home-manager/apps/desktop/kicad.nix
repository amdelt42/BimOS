{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["kicad"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Kicad";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kicad
      ];

      file = {
        ".config/kicad/10.0/scripting/plugins/viastitching" = {
          source = pkgs.fetchFromGitHub {
            owner = "weirdgyn";
            repo = "viastitching";
            rev = "master"; 
            sha256 = "sha256-GVRVa5IVzWlbr736eY9lnWREI+6fgAK+0VoBoE42RWw=";
          };
          recursive = true;
        };
      };
    };
  };
}