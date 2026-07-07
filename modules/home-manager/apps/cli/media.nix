{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["media"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path { 
    enable = mkEnableOption "Enable Media Utils";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # PDF, Image, Video
      zathura
      imv
      mpv
      imagemagick
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf"        = mkDefault "org.pwmt.zathura.desktop";
        "image/png"              = mkDefault "imv.desktop";
        "image/jpeg"             = mkDefault "imv.desktop";
        "image/*"                = mkDefault "imv.desktop";
        "video/mp4"              = mkDefault "mpv.desktop";
        "video/webm"             = mkDefault "mpv.desktop";
        "video/x-matroska"       = mkDefault "mpv.desktop";
        "video/*"                = mkDefault "mpv.desktop";
      };
    };
  };
}