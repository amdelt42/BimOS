{ config, lib, pkgs, homeuser, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["camera"];
  cfg = attrByPath path {} config;

  swaycEnabled = config.home-manager.users.${homeuser}.hm.desktop.swaync.enable or false;

  v4l-tui = pkgs.rustPlatform.buildRustPackage {
    pname = "v4l-tui";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "sermuns";
      repo = "v4l-tui";
      rev = "main";
      sha256 = "sha256-f2AFDPCRZjkVqFf4jm06ErqSfkvwqSXHkxipT6TSV2s=";
    };
    cargoHash = "sha256-fnPcgqLgCVSanIrRtimV0p1ifbk7nZ01y+uym2q4Vcw=";
    nativeBuildInputs = [ pkgs.llvmPackages.libclang pkgs.linuxHeaders ];
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    BINDGEN_EXTRA_CLANG_ARGS = "-I${pkgs.linuxHeaders}/include -I${pkgs.glibc.dev}/include";
  };

  cameraStatus = pkgs.writeShellScriptBin "camera-status" ''
    DEV="${cfg.devicePath}"
    if [ -e "$DEV" ]; then
      echo '{"text":"󰄀","class":"active","tooltip":"Camera active"}'
    else
      echo '{"text":"󰄀","class":"inactive","tooltip":"Camera inactive"}'
    fi
    exit 0
  '';
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "System includes a camera";
    devicePath = mkOption {
      type = types.str;
      description = "Stable /dev/v4l/by-id path for the primary webcam";
      example = "/dev/v4l/by-id/usb-Azurewave_Integrated_Camera-video-index0";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.devicePath != "";
          message = "sys.hardware.camera.enable is true requires sys.hardware.camera.devicePath, but sys.hardware.camera.devicePath is unset. Set it to the camera's /dev/v4l/by-id/... path (run `ls -la /dev/v4l/by-id/` to find it).";
        }
        {
          assertion = hasPrefix "/dev/v4l/by-id/" cfg.devicePath;
          message = "sys.hardware.camera.devicePath should point into /dev/v4l/by-id/ (stable across reboots). Got: ${cfg.devicePath}";
        }
      ];
      environment.systemPackages = [ v4l-tui cameraStatus ];
    })

    (mkIf (cfg.enable && swaycEnabled) {
      systemd.user.services.camera-notify = {
        description = "Camera on/off notifications";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Restart = "always";
          ExecStart = pkgs.writeShellScript "camera-notify" ''
            WAS_IN_USE=0
            while true; do
              sleep 1
              if ${cameraStatus}/bin/camera-status >/dev/null; then
                IN_USE=1
              else
                IN_USE=0
              fi
              if [ "$IN_USE" -eq 1 ] && [ "$WAS_IN_USE" -eq 0 ]; then
                ${pkgs.libnotify}/bin/notify-send --urgency=normal --icon=camera "Camera" "Camera switched on"
              elif [ "$IN_USE" -eq 0 ] && [ "$WAS_IN_USE" -eq 1 ]; then
                ${pkgs.libnotify}/bin/notify-send --urgency=low --icon=camera "Camera" "Camera switched off"
              fi
              WAS_IN_USE=$IN_USE
            done
          '';
        };
      };
    })
  ];
}