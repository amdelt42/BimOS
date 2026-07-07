{ ... }: 
{
  imports = [
    ./networking.nix
    ./sound.nix
    ./bootloader.nix
    ./stylix.nix
    ./autologin.nix
    ./services.nix
    ./agenix.nix
  ];
}