{ config, lib, pkgs, homeuser, ... }:
with lib;
let
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["oryx"];
  cfg = attrByPath path {} config;

  oryx = pkgs.stdenvNoCC.mkDerivation {
    pname = "oryx";
    version = "0.8.0";
    src = pkgs.fetchurl {
      url = "https://github.com/pythops/oryx/releases/download/v0.8.0/oryx-x86_64-unknown-linux-musl";
      sha256 = "sha256-+CghsbqmOlZFo4suPpmD84/6ca5ZJbhucge7PIK9Dqo=";
    };
    dontUnpack = true;
    installPhase = ''
      install -Dm755 $src $out/bin/oryx
    '';
  };
  oryxWrapper = pkgs.writeShellScriptBin "oryx" ''
    exec sudo ${oryx}/bin/oryx "$@"
  '';
in
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Oryx Traffic Sniffer";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ oryxWrapper ];
    security.sudo.extraRules = [{
      users = [ homeuser ];
      commands = [
        {
          command = "${oryx}/bin/oryx";
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };
}