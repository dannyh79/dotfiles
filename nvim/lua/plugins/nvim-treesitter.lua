return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup {
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
      auto_install = true,
    }
  end,
}
