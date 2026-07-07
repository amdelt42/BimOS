{ homeuser, ... }:
{
  imports = [
    ../../modules/home-manager/default.nix
  ];

	home = {
		username = homeuser;
		homeDirectory = "/home/${homeuser}";
		stateVersion = "26.05";
	};

	# Handy (offline) packages indexer
  programs.nix-index-database.comma.enable = true;

	programs.git.settings = {
		user = {
			name = "amdelt42";
    	email = "187971469+amdelt42@users.noreply.github.com";
		};
	};

	hm = {
		desktop = {
			hyprlock.enable = true;
			waybar.enable = true;
			waypaper.enable = true;
			swaync.enable = true;
			wofi.enable = true;
		};
		apps = {
			desktop = {
				packages = {
					# lutris = false;
					all = true;
				};
				flatpak.enable = true;
				librewolf.enable = true;
				vscode.enable = true;
				udiskie.enable = true;
			};
			cli = {
				zsh = {
					shellAliases = {
						btw = "echo I use NixOS, btw";
						rebuild-bimtop = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#bimtop";
						rebuild-bimserver = "nixos-rebuild switch --target-host amdelt42@bimserver --sudo --ask-sudo-password --flake ~/nixos-dotfiles#bimserver";
						cat = "bat";
						cd = "z";
					};
				};
				yazi.enable = true;
				utils.enable = true;
				rice.enable = true;
				media.enable = true;
			};
			
		};

		development = {
			rust = {
				enable = true;
			};
		};
	};
}
