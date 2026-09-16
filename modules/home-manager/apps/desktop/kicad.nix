{ config, lib, pkgs, ... }:
with lib;
let 
  # find parent directory after /home-manager/
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  # split parent directory into list and add required options
  path = [ "hm" ] ++ splitString "/" suffix ++ ["kicad"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Kicad";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kicad
    ];

    home.file = {
      ".config/kicad/10.0/sym-lib-table".source = 
        "${pkgs.kicad}/share/kicad/template/sym-lib-table";
        
      ".config/kicad/10.0/fp-lib-table".source = 
        "${pkgs.kicad}/share/kicad/template/fp-lib-table";
    };
  };
}
