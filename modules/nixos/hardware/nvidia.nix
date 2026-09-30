{ config, pkgs, lib, ... }: 
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["nvidia"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
		enable = mkEnableOption "Enable Nvidia Drivers";
		vaapi.enable = mkOption {
			type = types.bool;
			default = !cfg.prime.enable;
			description = "Whether Nvidia should own LIBVA_DRIVER_NAME. Defaults to false when PRIME offload is enabled (Intel handles VAAPI), true otherwise (Nvidia-primary setups).";
		};
		package = mkOption {
			type = types.package;
			default = config.boot.kernelPackages.nvidiaPackages.stable;
			defaultText = literalExpression "config.boot.kernelPackages.nvidiaPackages.stable";
			description = "The Nvidia driver package to use. Override per-host when the stable channel package doesn't build against your kernel.";
		};
		prime = {
			enable = mkEnableOption "Enable PRIME Hybrid Offload";
			intelBusId = mkOption {
				type = types.str;
				default = "";
			};
			nvidiaBusId = mkOption {
				type = types.str;
				default = "";
			};
		};
		dynamicBoost.enable = mkEnableOption "Enable Dynamic Boost";
	};

	config = mkIf cfg.enable {
		assertions = [
			{
				assertion = !cfg.prime.enable || (cfg.prime.intelBusId != "" && cfg.prime.nvidiaBusId != "");
     		message = "sys.hardware.nvidia.prime.enable requires both intelBusId and nvidiaBusId to be set.";
			}
		];

		nixpkgs.config.allowUnfree = true;
		# Load for Xorg/Wayland
		services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
		
		boot.kernelParams = [ 
			"nvidia-drm.modeset=1"   
			"nvidia-drm.fbdev=1"     
		];

		boot.initrd.kernelModules = [ 
			"nvidia" 
			"nvidia_modeset" 
			"nvidia_uvm" 
			"nvidia_drm" 
		];

		# Graphics Drivers
		hardware = {
			graphics = {
				enable = true;
				enable32Bit = true;
			};
			# Nvidia
			nvidia = {
				modesetting.enable = true;
				powerManagement.enable = false;
				powerManagement.finegrained = false;
				open = true;  
				nvidiaSettings = true;
				package = cfg.package;

				# prime 
				prime = mkIf cfg.prime.enable {
					offload = {
						enable = true;
						enableOffloadCmd = true;
					};
					intelBusId = cfg.prime.intelBusId;
        	nvidiaBusId = cfg.prime.nvidiaBusId;
				};
				# Dynamic boost support for performance profiles (Fn + Q)
				dynamicBoost.enable = cfg.dynamicBoost.enable;
			};
		};

		environment = {
			systemPackages = with pkgs; [
				vulkan-tools
			];
			sessionVariables = mkIf cfg.vaapi.enable {
				LIBVA_DRIVER_NAME = "nvidia";
			};
		};
	};
}
