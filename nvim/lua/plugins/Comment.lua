return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  opts = {
    -- add any options here
  },
  lazy = false,
  config = function()
    local ts_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    require("Comment").setup {
      pre_hook = function(ctx)
        return ts_hook(ctx) or vim.bo.commentstring
      end,
    }
  end
}
