{ config, pkgs, lib, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["sound"];
  cfg = attrByPath path {} config;

  # iLok License Manager yabridge wine wrapper
  ilok-license-manager = pkgs.writeShellApplication {
    name = "ilok-license-manager";
    text = ''
      export WINEPREFIX="$HOME/.wine"
      exec ${pkgs.wineWow64Packages.yabridge}/bin/wine "C:\\users\\Public\\Desktop\\iLok License Manager.lnk"
    '';
  };
  # Ardour PipeWire Jack wrapper
  ardour-pw = pkgs.writeShellApplication {
    name = "ardour-pw";
    text = ''
      exec pw-jack ${pkgs.ardour}/bin/ardour9 "$@"
    '';
  };
in
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable System Sound configuration";

    production = {
      enable = mkEnableOption "Enable music production tools (Ardour, iLok, wine bridging)";
    };
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wiremix
      qpwgraph
      pipewire.jack
    ] ++ optionals cfg.production.enable [
      yabridge
      yabridgectl
      wineWow64Packages.stable
      winetricks
      tuxguitar
      ardour-pw
      (makeDesktopItem {
        name = "ardour-pw";
        desktopName = "Ardour";
        comment = "Ardour Digital Audio Workstation";
        exec = "${ardour-pw}/bin/ardour-pw";
        icon = "${pkgs.ardour}/share/icons/hicolor/256x256/apps/ardour9.png";
        categories = [ "AudioVideo" "Audio" ];
      })
      ilok-license-manager
      (makeDesktopItem {
        name = "ilok-license-manager";
        desktopName = "iLok License Manager";
        comment = "iLok License Manager";
        exec = "${ilok-license-manager}/bin/ilok-license-manager";
        icon = "2089_iLok License Manager.0";
        categories = [ "AudioVideo" "Audio" ];
      })
    ];
  };
}