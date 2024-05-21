return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      highlight = {
        enable = true,
        disable = {},
      },
      indent = {
        enable = true,
        disable = {},
      },
      ensure_installed = {
        "tsx",
        "json",
        "yaml",
        "css",
        "html",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "typescript",
        "javascript",
      },
      --- Automatically install missing parsers when entering buffer
      auto_install = true,

      autotag = {
        enable = true,
      },
    }

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
  end
}
