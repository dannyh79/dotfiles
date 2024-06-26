return {
  "glepnir/lspsaga.nvim", -- LSP UIs
  config = function()
    local saga = require("lspsaga")

    saga.setup({
      ui = {
        winblend = 10,
        border = 'rounded',
        colors = {
          normal_bg = '#002b36'
        }
      }
    })

    -- local diagnostic = require("lspsaga.diagnostic")
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
    vim.keymap.set('n', 'gL', '<Cmd>Lspsaga show_cursor_diagnostics<CR>', opts)
    vim.keymap.set('n', 'gB', '<Cmd>Lspsaga show_buf_diagnostics<CR>', opts)
    vim.keymap.set('n', 'gK', '<Cmd>Lspsaga hover_doc<CR>', opts)
    vim.keymap.set('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
    -- vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', opts)
    -- vim.keymap.set('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opts)
    vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)

    -- code action
    local codeaction = require("lspsaga.codeaction")
    vim.opt.signcolumn = "yes:1"
    vim.keymap.set("n", "<leader>ca", function() codeaction:code_action() end, { silent = true })
    vim.keymap.set("v", "<leader>ca", function()
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
      codeaction:range_code_action()
    end, { silent = true })
  end
}
