return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require('telescope.actions')
    local builtin = require("telescope.builtin")

    local function telescope_buffer_dir()
      return vim.fn.expand('%:p:h')
    end

    -- local fb_actions = require "telescope".extensions.file_browser.actions

    telescope.setup {
      defaults = {
        mappings = {
          n = {
            ["q"] = actions.close
          },
        },
      },
      extensions = {
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
          -- mappings = {
          --   -- your custom insert mode mappings
          --   ["i"] = {
          --     ["<C-w>"] = function() vim.cmd('normal vbd') end,
          --   },
          --   ["n"] = {
          --     -- your custom normal mode mappings
          --     -- ["N"] = fb_actions.create,
          --     -- ["h"] = fb_actions.goto_parent_dir,
          --     ["/"] = function()
          --       vim.cmd('startinsert')
          --     end
          --   },
          -- },
        },
      },
    }


    vim.keymap.set('n', ';f',
      function()
        builtin.find_files({
          no_ignore = false,
          hidden = true
        })
      end)
    vim.keymap.set('n', ';r', function()
      builtin.live_grep()
    end)
    vim.keymap.set('n', ';s', function()
      builtin.grep_string()
    end)
    vim.keymap.set('n', ';b', function()
      builtin.buffers()
    end)
    vim.keymap.set('n', ';t', function()
      builtin.help_tags()
    end)
    vim.keymap.set('n', ';;', function()
      builtin.resume()
    end)
    vim.keymap.set('n', ';e', function()
      builtin.diagnostics()
    end)

    -- Load telescope-file-browser
    telescope.load_extension("file_browser")
    vim.keymap.set("n", ";af", function()
      telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = telescope_buffer_dir(),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        -- previewer = false,
        initial_mode = "normal",
        layout_config = { height = 40, width = 40 }
      })
    end)
  end
}
