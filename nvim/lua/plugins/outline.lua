return {
  "hedyhli/outline.nvim",
  config = function()
    vim.keymap.set("n", ";o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

    require("outline").setup()
  end
}
