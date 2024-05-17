-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  --local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  --buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(_, bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup_format,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end,
  })
end

local setup_completion_item_kind = function()
  local protocol = require('vim.lsp.protocol')

  protocol.CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()

return {
  "neovim/nvim-lspconfig", -- Quickstart configs for Nvim LSP
  config = function()
    --vim.lsp.set_log_level("debug")

    local nvim_lsp = require("lspconfig")

    setup_completion_item_kind()

    nvim_lsp.flow.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    nvim_lsp.tsserver.setup {
      on_attach = on_attach,
      filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
      cmd = { "typescript-language-server", "--stdio" },
      capabilities = capabilities
    }

    nvim_lsp.sourcekit.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    nvim_lsp.lua_ls.setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        enable_format_on_save(client, bufnr)
      end,
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },

          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false
          },
        },
      },
    }

    nvim_lsp.tailwindcss.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    nvim_lsp.cssls.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    nvim_lsp.elixirls.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    nvim_lsp.gopls.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    nvim_lsp.htmx.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    nvim_lsp.purescriptls.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    -- nvim_lsp.astro.setup {
    --   on_attach = on_attach,
    --   capabilities = capabilities
    -- }

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        signs = true,
        virtual_text = { spacing = 0, prefix = "●" },
      }
    )

    -- 2024-01-01 23:08:15 +0800
    -- stop using this config as it seems to cause line content shifts
    -- Diagnostic symbols in the sign column (gutter)
    -- local signs = { Error = " ", Warn = " ", Hint = "💡", Info = " " }
    -- for type, icon in pairs(signs) do
    --   local hl = "DiagnosticSign" .. type
    --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    -- end

    vim.diagnostic.config({
      virtual_text = { spacing = 0, prefix = '●' },
      update_in_insert = true,
      float = {
        source = "always", -- Or "if_many"
      },
    })
  end
}
