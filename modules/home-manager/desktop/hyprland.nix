{ config, lib, pkgs, flakePath, osConfig, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["hyprland"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {  
    useConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom config";
    };
  };

  config = mkIf osConfig.sys.desktop.hyprland.enable (mkMerge [
    {
      home.packages = with pkgs; [
        (writeShellScriptBin "polkit-agent" ''
          exec ${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        '')

        # Utilities
        hyprpicker
        wl-clipboard
        brightnessctl

        # screenshot
        grim
        slurp
        hyprshot
        jq
      ];
      # wl-clipboard clipboard management
      services.clipse.enable = true;

      programs.kitty = {
        enable = true;
        font = {
          size = mkForce 10;
        };
        settings = {
          line_height = "1.3";
          window_padding_width = 20;
        };
      };

      programs.zsh = {
        profileExtra = ''
          if [ "$(tty)" = "/dev/tty1" ]; then
            clear
              tput civis
            exec uwsm start hyprland-uwsm.desktop >/dev/null 2>&1
          fi
        '';
      };

      # Hyprland
      wayland.windowManager.hyprland = {
				enable = true;
				systemd.enable = false;

				# Use system package
				package = null;
				portalPackage = null;
			};
    }
    (mkIf cfg.useConfig {
      xdg.configFile."hypr/hyprland.lua" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/hypr/hyprland.lua";
      };
      xdg.configFile."hypr/modules" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/hypr/modules";
      };
    })
  ]);
}

