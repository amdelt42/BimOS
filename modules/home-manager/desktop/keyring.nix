{ config, lib, osConfig, ... }:
with lib;
let
  cfg = osConfig.sys.desktop.keyring;
in
{
	config = mkIf cfg.enable {
		services.gnome-keyring = {
			enable = true;
			components = [ "pkcs11" "secrets" "ssh" ];
		};
	};
}