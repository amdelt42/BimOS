{ config, lib, homeuser, ... }:
with lib;
let
  udiskieEnabled = config.home-manager.users.${homeuser}.hm.apps.desktop.udiskie.enable;
  flatpakEnabled = config.home-manager.users.${homeuser}.hm.apps.desktop.flatpak.enable;
in
{
  config = mkMerge [
    (mkIf udiskieEnabled {
      services.udisks2.enable = true;
    })
    (mkIf flatpakEnabled {
	    services.flatpak.enable = true;
    })
  ];
}