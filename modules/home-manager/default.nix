{ ... }:
{
  imports = [
    ./desktop/default.nix
    ./apps/default.nix
		./development/default.nix
    ./xdg.nix
  ];
}