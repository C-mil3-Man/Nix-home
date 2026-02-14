{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  # Use Stylix palette if present; otherwise fall back to Catppuccin Mocha background
  notifyBg = lib.attrByPath ["lib" "stylix" "colors" "base01"] "1e1e2e" config;
in {
  # Bring in Nixvim's Home Manager module so programs.nixvim options exist
  imports = [inputs.nixvim.homeModules.nixvim];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Core editor options
    opts = {
      number = true;
      relativenumber = true; # Relative numbers are more useful for motions
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true; # Persistent undo
      termguicolors = true;
      signcolumn = "yes";
      updatetime = 200;
      timeoutlen = 300;
      cursorline = true;
      scrolloff = 8; # Keep 8 lines visible above/below cursor
      sidescrolloff = 8;
      spell = true;
      spelllang = ["en"];
      clipboard = "unnamedplus";
      conceallevel = 0; # Show everything in markdown/json
      pumheight = 10; # Completion menu height
      completeopt = ["menu" "menuone" "noselect"];
      splitbelow = true; # Horizontal splits go below
      splitright = true; # Vertical splits go right
      ignorecase = true; # Case insensitive search
      smartcase = true; # Unless capital letters used
      hlsearch = true;
      incsearch = true;
    };

    # Theme: Catppuccin (mocha)
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        show_end_of_buffer = false;
        term_colors = true;
        dim_inactive = {
          enabled = true;
          shade = "dark";
          percentage = 0.15;
        };
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          notify = true;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
          telescope = {
            enabled = true;
          };
          which_key = true;
          indent_blankline = {
            enabled = true;
            scope_color = "lavender";
            colored_indent_levels = false;
          };
        };
      };
    };

    plugins = {
      # UI and visuals
      web-devicons.enable = true;

      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
            component_separators = {
              left = "|";
              right = "|";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
          sections = {
            lualine_a = ["mode"];
            lualine_b = ["branch" "diff" "diagnostics"];
            lualine_c = ["filename"];
            lualine_x = ["encoding" "fileformat" "filetype"];
            lualine_y = ["progress"];
            lualine_z = ["location"];
          };
        };
      };

      bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            themable = true;
            separator_style = "slant";
            show_buffer_close_icons = true;
            show_close_icon = true;
            diagnostics = "nvim_lsp";
          };
        };
      };

      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
          };
          scope = {
            enabled = true;
            show_start = true;
            show_end = false;
          };
        };
      };

      colorizer = {
        enable = true;
        settings = {
          user_default_options = {
            names = false; # Don't color "Blue"
            rgb_fn = true; # Enable rgb() syntax
            hsl_fn = true; # Enable hsl() syntax
            mode = "background"; # Options: foreground, background, virtualtext
          };
        };
      };

      illuminate = {
        enable = true;
        settings = {
          under_cursor = true;
          filetypes_denylist = ["alpha" "neo-tree"];
        };
      };

      # File tree
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 30;
            mappings = {
              "<space>" = "none";
            };
          };
          filesystem = {
            follow_current_file = {
              enabled = true;
            };
            filtered_items = {
              visible = true;
              hide_dotfiles = false;
              hide_gitignored = false;
            };
          };
        };
      };

      # Fuzzy finder with better defaults
      telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
        settings = {
          defaults = {
            prompt_prefix = " ";
            selection_caret = " ";
            path_display = ["truncate"];
            file_ignore_patterns = [
              "^.git/"
              "^node_modules/"
              "^%.cache/"
            ];
          };
          pickers = {
            find_files = {
              hidden = true;
            };
          };
        };
      };

      # Treesitter for syntax
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<C-space>";
              node_incremental = "<C-space>";
              scope_incremental = false;
              node_decremental = "<bs>";
            };
          };
        };
      };

      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3;
        };
      };

      # Project management
      project-nvim = {
        enable = true;
        enableTelescope = true;
      };

      # Notifications and UI polish
      notify = {
        enable = true;
        settings = {
          fps = 60;
          render = "compact";
          timeout = 3000;
          top_down = true;
        };
      };

      noice = {
        enable = true;
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = false;
        };
      };

      # Startup dashboard
      alpha = {
        enable = true;
        theme = "dashboard";
      };
      # Git integrations
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
          };
          signs = {
            add = {
              text = " ";
            };
            change = {
              text = " ";
            };
            delete = {
              text = " ";
            };
            untracked = {
              text = "";
            };
            topdelete = {
              text = "󱂥 ";
            };
            changedelete = {
              text = "󱂧 ";
            };
          };
        };
      };

      diffview.enable = true;
      lazygit = {
        enable = true;
      };

      # Motions and editing helpers
      hop.enable = true;
      leap.enable = true;
      vim-surround.enable = true;

      comment = {
        enable = true;
        settings = {
          toggler = {
            line = "gcc";
            block = "gbc";
          };
          opleader = {
            line = "gc";
            block = "gb";
          };
        };
      };

      which-key = {
        enable = true;
        settings = {
          delay = 300;
          icons = {
            mappings = true;
          };
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
            }
            {
              __unkeyed-1 = "<leader>d";
              group = "Diagnostics";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "Git";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
            }
            {
              __unkeyed-1 = "<leader>l";
              group = "LSP";
            }
          ];
        };
      };

      # Autopairs for (), {}, [], '', "", etc.
      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
          enable_check_bracket_line = false;
          fast_wrap = {
            map = "<M-e>";
            chars = [
              "{"
              "["
              "("
              "\""
              "'"
              "`"
            ];
          };
        };
      };

      # Terminal
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          float_opts = {
            border = "curved";
            width = 130;
            height = 30;
          };
          highlights = {
            border = "Normal";
            background = "Normal";
          };
        };
      };

      # Diagnostics UI
      trouble = {
        enable = true;
        settings = {
          auto_close = false;
          auto_open = false;
        };
      };

      # Markdown preview
      markdown-preview = {
        enable = true;
        settings = {
          auto_start = 0;
          theme = "dark";
        };
      };

      # Completion and snippets
      cmp = {
        enable = true;
        settings = {
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "buffer";}
            {name = "path";}
          ];
          window = {
            completion = {
              border = "rounded";
            };
            documentation = {
              border = "rounded";
            };
          };
        };
      };

      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      luasnip.enable = true;
      friendly-snippets.enable = true;

      # Signature help
      lsp-signature = {
        enable = true;
        settings = {
          hint_enable = true;
          hint_prefix = " ";
        };
      };

      # LSP configuration
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          lua_ls.enable = true;
          pyright.enable = true;
          clangd.enable = true;
          marksman.enable = true;
          # Ansible language server was removed from nixpkgs
          # Using yamlls with Ansible schemas instead
          yamlls = {
            enable = true;
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "/*.k8s.yaml";
                  "https://json.schemastore.org/ansible-stable-2.9" = "playbooks/**/*.yml";
                  "https://json.schemastore.org/ansible-playbook" = "*play*.yml";
                };
              };
            };
          };
        };
        keymaps = {
          diagnostic = {
            "<leader>dl" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
        };
      };

      # Formatter: conform.nvim
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = ["alejandra"];
            lua = ["stylua"];
            javascriptreact = ["prettierd"];
            html = ["prettierd"];
            json = ["prettierd"];
            markdown = ["prettierd"];
            yaml = ["prettier"]; # For Ansible
            sh = ["shfmt"];
            python = ["black" "isort"];
          };
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };
        };
      };

      # Ansible-specific plugins
      ansible-vim = {
        enable = true;
      };
    };

    # Keymaps
    keymaps = [
      # Insert-mode escape
      {
        key = "jk";
        mode = "i";
        action = "<ESC>";
        options.desc = "Exit insert mode";
      }

      # Clear search highlighting
      {
        key = "<Esc>";
        mode = "n";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlight";
      }

      # Better window navigation
      {
        key = "<C-h>";
        mode = "n";
        action = "<C-w>h";
        options.desc = "Navigate left";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<C-w>j";
        options.desc = "Navigate down";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<C-w>k";
        options.desc = "Navigate up";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<C-w>l";
        options.desc = "Navigate right";
      }

      # Resize windows
      {
        key = "<C-Up>";
        mode = "n";
        action = "<cmd>resize +2<CR>";
        options.desc = "Increase height";
      }
      {
        key = "<C-Down>";
        mode = "n";
        action = "<cmd>resize -2<CR>";
        options.desc = "Decrease height";
      }
      {
        key = "<C-Left>";
        mode = "n";
        action = "<cmd>vertical resize -2<CR>";
        options.desc = "Decrease width";
      }
      {
        key = "<C-Right>";
        mode = "n";
        action = "<cmd>vertical resize +2<CR>";
        options.desc = "Increase width";
      }

      # Buffer navigation
      {
        key = "<S-h>";
        mode = "n";
        action = "<cmd>bprevious<CR>";
        options.desc = "Previous buffer";
      }
      {
        key = "<S-l>";
        mode = "n";
        action = "<cmd>bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        key = "<leader>bd";
        mode = "n";
        action = "<cmd>bdelete<CR>";
        options.desc = "Delete buffer";
      }

      # Move lines up/down
      {
        key = "<A-j>";
        mode = "n";
        action = "<cmd>m .+1<CR>==";
        options.desc = "Move line down";
      }
      {
        key = "<A-k>";
        mode = "n";
        action = "<cmd>m .-2<CR>==";
        options.desc = "Move line up";
      }
      {
        key = "<A-j>";
        mode = "v";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move selection down";
      }
      {
        key = "<A-k>";
        mode = "v";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move selection up";
      }

      # Better indenting
      {
        key = "<";
        mode = "v";
        action = "<gv";
        options.desc = "Indent left";
      }
      {
        key = ">";
        mode = "v";
        action = ">gv";
        options.desc = "Indent right";
      }

      # Telescope
      {
        key = "<leader>ff";
        mode = "n";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        key = "<leader>fg";
        mode = "n";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live grep";
      }
      {
        key = "<leader>fb";
        mode = "n";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Find buffers";
      }
      {
        key = "<leader>fh";
        mode = "n";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Help tags";
      }
      {
        key = "<leader>fr";
        mode = "n";
        action = "<cmd>Telescope oldfiles<cr>";
        options.desc = "Recent files";
      }
      {
        key = "<leader>fp";
        mode = "n";
        action = "<cmd>Telescope projects<cr>";
        options.desc = "Projects";
      }

      # File tree
      {
        key = "<leader>e";
        mode = "n";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle file tree";
      }

      # Terminal
      {
        key = "<leader>t";
        mode = "n";
        action = "<cmd>ToggleTerm<CR>";
        options.desc = "Toggle terminal";
      }

      # Git
      {
        key = "<leader>gg";
        mode = "n";
        action = "<cmd>LazyGit<CR>";
        options.desc = "LazyGit";
      }
      {
        key = "<leader>gd";
        mode = "n";
        action = "<cmd>DiffviewOpen<CR>";
        options.desc = "Diff view";
      }
      {
        key = "<leader>gb";
        mode = "n";
        action = "<cmd>Gitsigns blame_line<CR>";
        options.desc = "Blame line";
      }

      # Comment
      {
        key = "<leader>/";
        mode = ["n" "v"];
        action = "<cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options.desc = "Toggle comment";
      }

      # Code formatting
      {
        key = "<leader>cf";
        mode = ["n" "v"];
        action = "<cmd>lua require('conform').format()<CR>";
        options.desc = "Format buffer";
      }

      # Diagnostics
      {
        key = "<leader>dj";
        mode = "n";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }
      {
        key = "<leader>dk";
        mode = "n";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Previous diagnostic";
      }
      {
        key = "<leader>dl";
        mode = "n";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show diagnostic";
      }
      {
        key = "<leader>dt";
        mode = "n";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Toggle diagnostics";
      }

      # Disable F1
      {
        key = "<F1>";
        mode = ["n" "i" "v" "x" "s" "o" "t" "c"];
        action = "<Nop>";
        options.desc = "Disable F1";
      }

      # Help
      {
        key = "<leader>h";
        mode = "n";
        action = ":help<Space>";
        options = {
          desc = "Open help";
          nowait = true;
        };
      }
      {
        key = "<leader>H";
        mode = "n";
        action = ":help <C-r><C-w><CR>";
        options.desc = "Help for word";
      }
    ];

    # Runtime tools and language servers
    extraPackages = [
      # Core utilities
      pkgs.ripgrep
      pkgs.fd
      pkgs.bat
      pkgs.wl-clipboard

      # Git
      pkgs.lazygit

      # Language servers
      pkgs.nixd
      pkgs.hyprls
      pkgs.pyright
      pkgs.lua-language-server
      pkgs.marksman
      pkgs.clang-tools
      # ansible-language-server # Removed from nixpkgs - unmaintained
      pkgs.yaml-language-server

      # Formatters
      pkgs.prettierd
      pkgs.stylua
      pkgs.shfmt
      pkgs.alejandra
      pkgs.black
      pkgs.isort
      pkgs.nodePackages.prettier

      # Ansible tools
      pkgs.ansible
      pkgs.ansible-lint

      # ASCII art
      pkgs.figlet
      pkgs.toilet
    ];

    # Enhanced Lua configuration
    extraConfigLua = ''
      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 2,
        },
        update_in_insert = true,
        severity_sort = true,
        underline = true,
        signs = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- LSP keymaps on attach
      local function lsp_on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        map('n', 'K', vim.lsp.buf.hover, 'Hover docs')
        map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'Goto implementation')
        map('n', 'gr', vim.lsp.buf.references, 'References')
        map('n', '<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
        map('n', '<leader>ls', vim.lsp.buf.signature_help, 'Signature help')
        map('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, 'Format')
      end

      if vim.g.__nixvim_lsp_attached ~= true then
        vim.g.__nixvim_lsp_attached = true
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            lsp_on_attach(nil, args.buf)
          end,
        })
      end

      -- Notify background
      local ok, notify = pcall(require, 'notify')
      if ok then
        notify.setup({ background_colour = "#${notifyBg}" })
        vim.notify = notify
      end

      -- nvim-cmp integration with nvim-autopairs
      do
        local ok_cmp, cmp = pcall(require, "cmp")
        local ok_ap, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
        if ok_cmp and ok_ap then
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
      end

      -- Ansible filetype detection
      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"*/playbooks/*.yml", "*/playbooks/*.yaml", "*/roles/*/tasks/*.yml"},
        callback = function()
          vim.bo.filetype = "yaml.ansible"
        end,
      })

      -- Alpha dashboard
      do
        local ok_alpha, alpha = pcall(require, "alpha")
        if ok_alpha then
          local dashboard = require("alpha.themes.dashboard")

          local header_lines = nil
          local function gen_banner(cmd)
            local h = io.popen(cmd)
            if not h then return nil end
            local out = h:read("*a") or ""
            h:close()
            if #out == 0 then return nil end
            local lines = {}
            for line in out:gmatch("([^\n]*)\n?") do
              if line ~= "" then table.insert(lines, line) end
            end
            return #lines > 0 and lines or nil
          end

          header_lines = gen_banner('toilet -f ansi-shadow NIXVIM 2>/dev/null')
            or gen_banner('figlet -f "ANSI Shadow" NIXVIM 2>/dev/null')
            or gen_banner('figlet NIXVIM 2>/dev/null')

          if not header_lines then
            header_lines = {
              "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗",
              "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║",
              "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║",
              "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║",
              "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║",
              "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
            }
          end
          dashboard.section.header.val = header_lines

          dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "󰺮  Live grep", ":Telescope live_grep<CR>"),
            dashboard.button("n", "  New file", ":enew<CR>"),
            dashboard.button("e", "  File browser", ":Neotree toggle<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
          }

          local v = vim.version()
          dashboard.section.footer.val = string.format("⚡ NixVim • Neovim %d.%d.%d", v.major, v.minor, v.patch)

          dashboard.opts.opts.noautocmd = true
          alpha.setup(dashboard.config)

          vim.api.nvim_create_autocmd("FileType", {
            pattern = "alpha",
            callback = function()
              vim.opt_local.foldenable = false
            end,
          })
        end
      end

      -- Highlight on yank
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
        end,
      })

      -- Auto-close terminal on process exit
      vim.api.nvim_create_autocmd("TermClose", {
        callback = function()
          vim.cmd("bdelete!")
        end,
      })
    '';
  };
}
