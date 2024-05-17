return {
  "norcalli/nvim-colorizer.lua", -- color code highlighter
  config = function()
    require("colorizer").setup({
      '*',
    })
  end
}
