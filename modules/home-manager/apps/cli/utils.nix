{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["utils"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path { 
    enable = mkEnableOption "Enable CLI Utils";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # CLI Utils
      htop
      unzip
      zip
      ripgrep
      fd
      bat
      fzf
      lazygit
      wget
      tree
      dua
      progress
      brightnessctl
      pciutils
      os-prober
      efibootmgr
      trash-cli
    ];

    programs.btop.enable = true;
    programs.git.enable = true;
  };
}