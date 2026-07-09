{ config, lib, pkgs, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["opencode"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable Opencode open source agent";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      settings = {
        provider = {
          llama-cpp = {
            npm = "@ai-sdk/openai-compatible";
            name = "llama.cpp (local)";
            options = {
              baseURL = "http://localhost:8080/v1";
              includeUsage = true;
            };
            models = {
              "Jackrong/Qwen3.5-9B-DeepSeek-V4-Flash-GGUF:Q4_K_M" = {
                name = "Qwen3.5-9B-DeepSeek-V4-Flash-GGUF (local)";
                tool_call = true;
                reasoning = true;
              };
            };
          };
        };
        
        permission = {
          "*" = "ask";

          edit = {
            "*" = "ask";
            "~/.ssh/**" = "deny";
            "/etc/**" = "deny";
            "~/.gnupg/**" = "deny";
            "~/.config/git/**" = "deny";
          };

          read = {
            "*" = "allow";       
            "~/.ssh/**" = "deny";
            "/etc/**" = "deny";
            "~/.gnupg/**" = "deny";
            "~/.config/git/**" = "deny";
            "*.env" = "deny";
            "*.env.*" = "deny";
          };

          bash = {
            "*" = "ask";
            "rm -rf ~" = "deny";
            "rm -rf *" = "deny";
            "rm -rf /" = "deny";
            "sudo *" = "ask";
            "cat ~/.ssh/*" = "deny";
            "cat /etc/ssh/*" = "deny";
          };

          # hard-block anything outside the project cwd
          external_directory = "deny";  
          webfetch = "ask";
          websearch = "ask";
        };
      };
    };
  };
}