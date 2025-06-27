return {
  name = "run delve",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "debug_run" },
      args = { file },
      -- components = {
      --   { "on_output_quickfix", set_diagnostics = true },
      --   "on_result_diagnostics",
      --   "default",
      -- },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  -- condition = {
  --   filetype = { "cpp" },
  -- },
}
