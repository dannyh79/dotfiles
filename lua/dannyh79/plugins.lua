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
  "windwp/nvim-autopairs",
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
  "folke/tokyonight.nvim",
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
  }
})
