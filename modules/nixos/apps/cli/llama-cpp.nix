{ config, lib, pkgs, inputs, ... }:
with lib;
let
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ [ "llama-cpp" ];
  cfg = attrByPath path {} config;

  system = pkgs.stdenv.hostPlatform.system;

  llama-cpp = (inputs.llama-cpp.packages.${system}.cuda).overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or []) ++ [
      "-DGGML_CUDA=ON"
      "-DGGML_CUDA_FA_ALL_QUANTS=ON"
      "-DCMAKE_CUDA_ARCHITECTURES=86"
    ];
  });
in
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable llama.cpp";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
      llama-cpp
    ];
  };
}