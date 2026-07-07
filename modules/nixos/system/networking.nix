{ config, hostname, lib, pkgs, ... }: 
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["networking"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
		enable = mkEnableOption "Enable networking configuration";
	};
	
	config = mkIf cfg.enable {
		# set common timezone
    time.timeZone = "Europe/Amsterdam";

		# Configure network connections interactively with nmcli or nmtui.
		networking = {
			hostName = hostname; 
			networkmanager = {
				enable = true;
				wifi.backend = "iwd";
			};
			wireless = {
				iwd.enable = true;
			};
			firewall = {
				enable = true;
			};
		};

		environment.systemPackages = with pkgs; [
			impala
		];
	};
}