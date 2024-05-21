return {
  "levouh/tint.nvim",   -- Dims inactive windows
  config = function()
    require("tint").setup {
      tint = -50,
      tint_background_colors = false
    }
  end
}
