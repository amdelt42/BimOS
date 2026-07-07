{ config, pkgs, homeuser, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/default.nix
  ];

  # mount boot partition
  fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/70FD-8F25";
		fsType = "vfat";
		options = [ "fmask=0077" "dmask=0077" ];
	};

  # Configure bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };
  
  programs.zsh.enable = true;
  users.users.${homeuser} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ 
      "wheel" 
      "networkmanager" 
    ]; 
    packages = with pkgs; [
        tree
    ];
		initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJdXVkwzlYYwB2k3bmCl5JDLG4N5tbNYuP3vkyIxZ5P amdelt42@bimtop"
    ];
  };

  sys = {
    hardware = {
      intel = {
        enable = true;
        legacy = true;
      };
    };

    system = {
      bootloader.enable = true;
		  networking.enable = true;

      stylix = {
        enable = true;
        polarity = "dark";
        fonts.enable = true;
        base16.enable = true;
      };
    };

    apps = {
      cli = {
        nixvim.enable = true;
        oryx.enable = true;
      };
    };
	};

  # Nix Settings + Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" homeuser ];
    trusted-public-keys = [ "bimtop:UQEBS2IcWfmtT3Ey38DRbNLX73oYCDd96ZCUiRwQieQ=" ];
  };

  # Enable D-Bus session
  programs.dconf.enable = true;

  # TerminalInfo (for ssh)
  environment = {
    enableAllTerminfo = true;
  };

  services.openssh.enable = true;
  # Enable Agenix symlink and user permission to BimOS repo deploy key
	age.secrets.bimserver-deploy-key = {
    file = ../../secrets/bimserver-deploy-key.age;
    mode = "0400";
    owner = homeuser;
    group = "users";
  };

  system.stateVersion = "26.05";
}