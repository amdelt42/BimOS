{ lib, config, homeuser, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["autologin"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable autologin on tty1";
  };

  config = mkIf cfg.enable {
    services.getty = {
      autologinUser = homeuser;
      greetingLine = "";
      helpLine = "";
    };
  };
}