return {
  "nvimtools/none-ls.nvim", -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  config = function()
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    local lsp_formatting = function(bufnr)
      vim.lsp.buf.format({
        filter = function(client)
          return client.name == "null-ls"
        end,
        bufnr = bufnr,
      })
    end

    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.diagnostics.eslint.with({
        --   diagnostics_format = '[eslint] #{m}\n(#{c})',
        --   condition = function(utils)
        --     return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs" })
        --   end,
        -- }),
        -- null_ls.builtins.diagnostics.bash,
        null_ls.builtins.diagnostics.credo,
        null_ls.builtins.formatting.mix,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.checkmake,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              lsp_formatting(bufnr)
            end,
          })
        end
      end
    }

    vim.api.nvim_create_user_command(
      'DisableLspFormatting',
      function()
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
      end,
      { nargs = 0 }
    )
  end
}
