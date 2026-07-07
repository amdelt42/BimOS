{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["packages"];
  cfg = attrByPath path {} config;

  # name -> package. Add/remove apps by editing only this list.
  apps = with pkgs; {
    discord = discord;
    kicad = kicad;
    orca-slicer = orca-slicer;
    libreoffice = libreoffice;
    obs-studio = obs-studio;
    pinta = pinta;
    lutris = lutris;
    signal-desktop = signal-desktop;
    drawio = drawio;
    obsidian = obsidian;
    tradingview = tradingview;
  };

  # For each app: true = force on, false = force off, null = "no opinion,
  # just do whatever `all` says". This is what makes override possible.
  perAppOptions = mapAttrs (name: _: mkOption {
    type = types.nullOr types.bool;
    default = null;
    description = "Enable ${name} (overrides 'all' if set)";
  }) apps;

  # The blanket switch. Defaults to false so nothing changes unless you opt in.
  allOption = {
    all = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all desktop packages, unless overridden per-app";
    };
  };

  # Decide, per app, whether it's actually enabled
  # explicit true/false wins; null falls back to `all`.
  isEnabled = name: 
    let explicit = cfg.${name} or null; in
    if explicit != null then explicit else cfg.all;

  # Example:
  # everything on
  # hm.apps.desktop.packages.all = true;

  # # everything on, except lutris
  # hm.apps.desktop.packages = {
  #   all = true;
  #   lutris = false;
  # };

  # only two specific apps, "all" left at its default false
  # hm.apps.desktop.packages = {
  #   obsidian = true;
  #   discord = true;
  # };

in 
{
  options = setAttrByPath path (perAppOptions // allOption);

  config = {
    home.packages = attrValues (filterAttrs (name: _: isEnabled name) apps);
  };
}