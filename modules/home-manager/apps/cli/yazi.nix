{ config, pkgs, lib, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["yazi"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path { 
    enable = mkEnableOption "Enable Yazi";
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      desktopEntries.yazi = {
        name = mkDefault "Yazi";
        exec = mkDefault "kitty yazi %u";
        terminal = mkDefault false;
        mimeType = mkDefault [ "inode/directory" ];
      };
      mimeApps.defaultApplications."inode/directory" = mkDefault "yazi.desktop";
    };

    programs.yazi = {
      enable = true;
      plugins = {
        wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = [ "y" ];
            run = "plugin wl-clipboard --args=copy";
            desc = "Copy to clipboard";
          }
          {
            on = [ "p" ];
            run = "paste";
            desc = "Paste";
          }
          {
            on = [ "P" ];
            run = "paste --force";
            desc = "Paste (overwrite)";
          }
        ];
      };
    };
  };
}