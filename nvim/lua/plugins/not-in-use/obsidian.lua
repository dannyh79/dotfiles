-- Plugin to write/navigate in Obsidian vault
return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "gdrive",
        path = "~//Google Drive/My Drive/Obsidian",
      },
    },
  },
}
