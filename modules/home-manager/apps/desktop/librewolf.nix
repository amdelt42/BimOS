{ config, stylix, lib,... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["librewolf"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Librewolf";
  };

  config = mkIf cfg.enable {
    stylix.targets.firefox.colors.enable = false;
    stylix.targets.librewolf.profileNames = [ "default" ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
      };
    };

    programs.librewolf = {
      enable = true;
      profiles.default = { 
        settings = {
          "font.name.serif.x-western" = mkForce "CaskaydiaCove Nerd Font";
          "font.name.sans-serif.x-western" = mkForce "CaskaydiaCove Nerd Font";
          "font.name.monospace.x-western" = mkForce "CaskaydiaMono Nerd Font";

          "font.size.variable.x-western" = mkForce 16;
          "font.size.monospace.x-western" = mkForce 16;

          # Marks fonts as user-configured.
          "font.internaluseonly.changed" = mkForce true;
          "layout.css.devPixelsPerPx" = "-1.0";
        };

        userChrome = ''
          #main-window, 
          #toolbox, 
          #TabsToolbar, 
          #nav-bar, 
          #PersonalToolbar {
            background: transparent !important;
            background-color: transparent !important;
          }

          :root {
            --toolbar-bgcolor: transparent !important;
            --tabs-border-color: transparent !important;
          }
        '';
      };
    };
  };
}

