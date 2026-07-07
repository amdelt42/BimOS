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

  programs.git.settings = {
		user = {
			name = "amdelt42";
    	email = "187971469+amdelt42@users.noreply.github.com";
		};
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
		# "github-another-repo" = {
    #   HostName = "github.com";
    #   IdentityFile = "/run/agenix/another-deploy-key";
    #   IdentitiesOnly = true;
    # };
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