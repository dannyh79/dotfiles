local status, lazy = pcall(require, "lazy")
if (not status) then
  print("Lazy (plugin manager) is not installed")
  return
end

lazy.setup({
  "wbthomason/packer.nvim",
  "nvim-lualine/lualine.nvim", -- Statusline
  "nvim-lua/plenary.nvim",     -- Common utilities
  "onsails/lspkind-nvim",      -- vscode-like pictograms
  "hrsh7th/cmp-buffer",        -- nvim-cmp source for buffer words
  "hrsh7th/cmp-nvim-lsp",      -- nvim-cmp source for neovim"s built-in LSP
  "hrsh7th/nvim-cmp",          -- Completion
  "neovim/nvim-lspconfig",     -- LSP
  "nvimtools/none-ls.nvim",    -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  "glepnir/lspsaga.nvim", -- LSP UIs
  "L3MON4D3/LuaSnip",
  { "nvim-treesitter/nvim-treesitter",     build = ":TSUpdate" },
  "kyazdani42/nvim-web-devicons", -- File icons
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
      })
    end
  },
  "windwp/nvim-ts-autotag",
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  "norcalli/nvim-colorizer.lua",
  "folke/zen-mode.nvim",
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  "akinsho/nvim-bufferline.lua",

  "lewis6991/gitsigns.nvim",
  "dinhhuy258/git.nvim", -- For git blame & browse
  { "lukas-reineke/indent-blankline.nvim", main = "ibl",       opts = {} },
  "tpope/vim-surround",
  "levouh/tint.nvim",

  -- themes
  { "catppuccin/nvim",                  as = "catppuccin" },
  {
    "nomnivore/ollama.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    -- All the user commands added by the plugin
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

    keys = {
      -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oo",
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = "ollama prompt",
        mode = { "n", "v" },
      },

      -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oG",
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = "ollama Generate Code",
        mode = { "n", "v" },
      },
    },

    ---@type Ollama.Config
    opts = {
      -- model = "codellama:7b-code-q4_K_M",
      -- model = "codellama:13b-code-q4_K_M",

      serve = {
        on_start = true,
        command = "ollama",
        args = { "serve" },
        stop_command = "pkill",
        stop_args = { "-SIGTERM", "ollama" },
      },
    }
  },

  -- purescript 2024-03-07 13:36:46 +0800
  -- Syntax highlighting
  { "purescript-contrib/purescript-vim" },
  -- { "jeetsukumaran/vim-pursuit" },

  -- LspConfig
  -- {
  --   "neovim/nvim-lspconfig",
  --
  --   ---@class PluginLspOpts
  --   opts = {
  --
  --     ---@type lspconfig.options
  --     servers = {
  --       -- purescriptls will be automatically installed with mason and loaded with lspconfig
  --       purescriptls = {
  --         settings = {
  --           purescript = {
  --             formatter = "purs-tidy",
  --           },
  --         },
  --       },
  --       setup = {
  --         purescriptls = function(_, opts)
  --           opts.root_dir = function(path)
  --             local util = require("lspconfig.util")
  --             if path:match("/.spago/") then
  --               return nil
  --             end
  --             return util.root_pattern("bower.json", "psc-package.json", "spago.dhall", "flake.nix", "shell.nix")(path)
  --           end
  --         end,
  --       },
  --     },
  --   },
  -- },
  {
    "vim-test/vim-test",
    dependencies = {
      "preservim/vimux"
    },
    config = function()
      vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
      vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
      vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
      vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
      vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
      vim.cmd("let test#strategy = 'vimux'")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "night",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = "day",    -- The theme is used when the background is set to light
        transparent = false,    -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark",              -- style for sidebars, see below
          floats = "dark",                -- style for floating windows
        },
        sidebars = { "qf", "help" },      -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = true,              -- dims inactive windows
        lualine_bold = true,              -- When `true`, section headers in the lualine theme will be bold
        --- You can override specific color groups to use other groups or a hex color
        --- function will be called with a ColorScheme table
        ---@param colors ColorScheme
        on_colors = function(colors)
        end,
        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        ---@param highlights Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors)
        end,
      })

      vim.opt.background = "dark"
      vim.cmd.colorscheme "tokyonight-night"
    end
  }
})
