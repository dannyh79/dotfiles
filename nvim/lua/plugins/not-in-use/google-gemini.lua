-- https://github.com/kiddos/gemini.nvim
-- Requires GEMINI_API_KEY to be set in env
return {
  "kiddos/gemini.nvim",

  -- Uses gemini-2.5-flash by default
  opts = {
    hints = {
      hints_delay = 500,
      insert_result_key = "<Tab>",
    },
    completion = {
      completion_delay = 200,
      insert_result_key = "<Tab>"
    }
  }
}
