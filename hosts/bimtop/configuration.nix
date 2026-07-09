{ config, pkgs, homeuser, hostname, ... }:
{
	imports = [ 
		./hardware-configuration.nix
		../../modules/nixos/default.nix
	];

	# mount boot partition
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B8CD-EFFF";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

	# Configure bootloader
  boot = {
		loader = { 
			systemd-boot.enable = false;
			efi.canTouchEfiVariables = false;
			efi.efiSysMountPoint = "/boot";
			grub = {
				enable = true;
				device = "nodev";
				efiSupport = true;
				efiInstallAsRemovable = true;
				useOSProber = false;
				#forceInstall = false;
				configurationLimit = 10;
			};
		};
		# legion specific kernel module
		kernelModules = [ "lenovo-legion-module" ];
    extraModulePackages = with config.boot.kernelPackages; [
      lenovo-legion-module
    ];
	};
	
	programs.zsh.enable = true;
	users.users.${homeuser} = {
		isNormalUser = true;
		shell = pkgs.zsh;
		extraGroups = [ 
			"wheel" 
			"video" 
			"audio" 
			"networkmanager" 
			"network"
			"input" 
		]; 
		initialPassword = "changeme";
	};

	sys = {
    hardware = {
			nvidia = {
				enable = true;
				prime = {
					enable = true;
					intelBusId = "PCI:0:2:0";
					nvidiaBusId = "PCI:1:0:0";
				};
				dynamicBoost.enable = true;
			};
			intel.enable = true;
			bluetooth.enable = true;
			camera = {
				enable = true;
				devicePath = "/dev/v4l/by-id/usb-Azurewave_Integrated_Camera-video-index0";
			};
		};

		system = {
			bootloader.enable = true;
			networking.enable = true;

			stylix = {
				enable = true;
				polarity = "dark";
				cursor.enable = true;
				fonts.enable = true;
				base16.enable = true;
			};

			sound = {
				enable = true;
				production.enable = true;
			};

			autologin.enable = true;
		};

		desktop = {
			hyprland.enable = true;
			keyring.enable = true;
		};

		apps = {
			desktop = {
				wivrn.enable = true;
				steam.enable = true;
				localsend.enable = true;
			};
			cli = {
				bettery.enable = true;
				nix-ld.enable = true;
				nixvim.enable = true;
				oryx.enable = true;
				llama-cpp.enable = true;
			};
		};
	};
	
	# Nix Settings + Flakes
	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		secret-key-files = [ "/etc/nix/signing-key.sec" ];
	};

	nixpkgs.config.permittedInsecurePackages = [ "ventoy-1.1.12"	];
	environment.systemPackages = [ pkgs.ventoy ];
	services.openssh.enable = true;

	# State Version
	system.stateVersion = "26.05"; 
}

