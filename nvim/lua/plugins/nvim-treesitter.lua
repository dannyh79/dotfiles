return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install {
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
    }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "lua",
        "markdown",
        "python",
        "regex",
        "typescript",
        "typescriptreact",
        "yaml",
      },
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
