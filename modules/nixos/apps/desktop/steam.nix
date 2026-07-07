{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["steam"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Steam";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    programs.gamemode.enable = true;

    # Gaming utilities and tools
    environment.systemPackages = with pkgs; [
      mangohud         # FPS overlay and performance monitoring
      protonup-ng      # Proton-GE installer
      protontricks     # Winetricks for Proton games
      gamemode         # Performance optimizer
      vulkan-tools     # vulkaninfo, vkcube for testing
      gamescope        # Run games in a microcompositor
    ];

    # ProtonUp Path
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}