{ config, pkgs, lib,... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["stylix"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = lib.mkEnableOption "Enable Stylix configuration";
    
    cursor = {
      enable = mkEnableOption "Enable Stylix-managed cursor theme";
      package = mkOption {
        type = types.package;
        default = pkgs.bibata-cursors;
        description = "Cursor theme package";
      };
      name = mkOption {
        type = types.str;
        default = "Bibata-Modern-Classic";
        description = "Cursor theme name";
      };
      size = mkOption {
        type = types.int;
        default = 20;
        description = "Cursor size";
      };
    };

    base16 = {
      enable = mkEnableOption "Enable Stylix base16 color scheme";
    };

    polarity = mkOption {
      type = types.enum [ "dark" "light" ];
      default = "dark";
      description = "Overall light/dark polarity for the theme";
    };

    fonts = {
      enable = mkEnableOption "Enable Stylix-managed fonts";
      monospace = {
        package = mkOption {
          type = types.package;
          default = pkgs.nerd-fonts.caskaydia-mono;
          description = "Monospace font package";
        };
        name = mkOption {
          type = types.str;
          default = "CaskaydiaMono Nerd Font";
          description = "Monospace font name";
        };
      };
      sansSerif = {
        package = mkOption {
          type = types.package;
          default = pkgs.nerd-fonts.caskaydia-cove;
          description = "Sans-serif font package";
        };
        name = mkOption {
          type = types.str;
          default = "CaskaydiaCove Nerd Font";
          description = "Sans-serif font name";
        };
      };
      emoji = {
        package = mkOption {
          type = types.package;
          default = pkgs.nerd-fonts.symbols-only;
          description = "Emoji font package";
        };
        name = mkOption {
          type = types.str;
          default = "Symbols Nerd Font";
          description = "Emoji font name";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      polarity = cfg.polarity;

      cursor = mkIf cfg.cursor.enable {
        package = cfg.cursor.package;
        name = cfg.cursor.name;
        size = cfg.cursor.size;
      };

      base16Scheme = {
        # Backgroundsdelvindyami2004
        base00 = "#282a36"; # main background
        base01 = "#343947"; # panels/statusbars
        base02 = "#44475a"; # selection
        base03 = "#6272a4"; # comments

        # Foregrounds
        base04 = "#9ea8c7"; # muted tlext
        base05 = "#f8f8f2"; # normal text
        base06 = "#f0f1f4"; # bright text
        base07 = "#ffffff"; # brightest text

        # Syntax colors
        base08 = "#ff5555"; # variables
        base09 = "#ffb86c"; # numbers
        base0A = "#f1fa8c"; # types/classes
        base0B = "#50fa7b"; # strings
        base0C = "#8be9fd"; # regex/support
        base0D = "#80bfff"; # functions / focus border
        base0E = "#ff79c6"; # keywords
        base0F = "#bd93f9"; # special/deprecated
      };

      fonts = mkIf cfg.fonts.enable {
        monospace = {
          package = cfg.fonts.monospace.package;
          name = cfg.fonts.monospace.name;
        };
        sansSerif = {
          package = cfg.fonts.sansSerif.package;
          name = cfg.fonts.sansSerif.name;
        };
        emoji = {
          package = cfg.fonts.emoji.package;
          name = cfg.fonts.emoji.name;
        };
      };
    };
  };
}