{ config, lib, ... }:
with lib;
let 
  suffix = elemAt (splitString "/nixos/" (toString ./.)) 1;
  path = [ "sys" ] ++ splitString "/" suffix ++ ["nixvim"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable NixVim/NeoVim";
  };
  
  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      # Terminal alias -> vi and vim point to nvim
      viAlias = true;
      vimAlias = true;

      # Leader key -> Spacebar
      globals.mapleader = " ";

      opts = {
        # Line numbers
        number = true;
        relativenumber = true;
        # Tab widths
        shiftwidth = 2;
        tabstop = 2;
        # Fix tab spaces
        expandtab = true;
        # Search case sensitivity
        ignorecase = true;
        smartcase = true;
        # full 24-bit RGB colors
        termguicolors = true;
        # Thin column on the left margin (for signs)
        signcolumn = "yes";
        # Lines always visible above/below cursor
        scrolloff = 8;
        # Undo history persist across sessions
        undofile = true;
      };

      colorschemes.dracula.enable = true;

      plugins = {
        # NF Icons
        web-devicons.enable = true;
        # customizable status line
        lualine.enable = true;
        # tab-like bars 
        bufferline.enable = true;

        # fuzzy finder and picker
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
          };
        };

        # file explorer 
        neo-tree = {
          enable = true;
        };

        # better syntax highlighting
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };

        # git markers
        gitsigns.enable = true;
        # comment/uncomment lines with keystroke
        comment.enable = true;
        # indent vertical lines
        indent-blankline.enable = true;
        # {} [] () pairs
        nvim-autopairs.enable = true;

        # language servers - one per language, gives error checking / go-to-definition / hover docs
        lsp = {
          enable = true;
          servers = {
            nil_ls.enable = true;     # nix
            bashls.enable = true;     # bash/shell
            pyright.enable = true;    # python
            clangd.enable = true;     # c/c++ 
            cssls.enable = true;      # css
            marksman.enable = true;   # markdown
          };
          keymaps = {
            # these only work inside files the LSP understands
            lspBuf = {
              "gd" = "definition";          # jump to where a thing is defined
              "gr" = "references";          # list everywhere a thing is used
              "K"  = "hover";               # show docs/type info for what's under cursor
              "<leader>rn" = "rename";      # rename a variable/function everywhere
              "<leader>ca" = "code_action"; # quick-fixes the LSP suggests
            };
          };
        };

        # autocomplete dropdown - pulls suggestions from the LSP as you type
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              { name = "nvim_lsp"; }  # suggestions from the language server
              { name = "path"; }      # suggestions for file paths
              { name = "buffer"; }    # suggestions from words already in the file
            ];
            mapping = {
              "<Tab>" = "cmp.mapping.select_next_item()";   # cycle down suggestions
              "<S-Tab>" = "cmp.mapping.select_prev_item()"; # cycle up suggestions
              "<CR>" = "cmp.mapping.confirm({ select = true })"; # accept suggestion
            };
          };
        };
      };

      keymaps = [
        { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<CR>"; options.desc = "Toggle file explorer"; }
      ];
    };
  };
}