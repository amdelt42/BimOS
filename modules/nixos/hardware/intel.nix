{ config, pkgs, lib, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["intel"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Intel GPU support";

    legacy = mkOption {
      type = types.bool;
      default = false;
      description = "Use legacy Intel GPU drivers (3rd–5th gen Intel GPUs).";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    services.xserver.videoDrivers = mkIf (!config.sys.hardware.nvidia.enable) [ "modesetting" ];

    boot.initrd.kernelModules = [ "i915" ];

    boot.kernelParams =
      optional (!cfg.legacy) "i915.enable_guc=3";

    hardware = {
      cpu.intel.updateMicrocode = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      
        extraPackages = with pkgs; if cfg.legacy then [
            intel-vaapi-driver
          ] else [
            intel-media-driver
            intel-compute-runtime
            vpl-gpu-rt
        ];
      };
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = mkDefault (if cfg.legacy then "i965" else "iHD");
    };
  };
}