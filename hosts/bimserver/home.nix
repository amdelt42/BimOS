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

  # Github over ssh runs deploy key per specified repo
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
			"github-bimos" = {
				HostName = "github.com"; 
				IdentityFile = "/run/agenix/bimserver-deploy-key"; 
				IdentitiesOnly = "yes"; 
			};
    };
  };

  hm = {
    apps = {
      cli = {
        utils.enable = true;
      };
    };
  };
}