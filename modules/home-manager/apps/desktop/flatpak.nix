{ config, lib, ... }:
with lib;
let 
  # find parent directory after /home-manager/
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  # split parent directory into list and add required options
  path = [ "hm" ] ++ splitString "/" suffix ++ ["flatpak"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Flatpak apps + remotes";
  };

  config = mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];
      packages = [
        { appId = "org.freedownloadmanager.Manager"; origin = "flathub"; }
        { appId = "io.github.cosmic_utils.camera"; origin = "flathub"; }
        { appId = "org.gnome.clocks"; origin = "flathub"; }
        { appId = "org.gnome.Weather"; origin = "flathub"; }
        { appId = "info.beyondallreason.bar"; origin = "flathub"; }
      ];
    }; 
  };
}