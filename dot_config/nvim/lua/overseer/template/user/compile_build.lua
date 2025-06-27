-- /home/stevearc/.config/nvim/lua/overseer/template/user/cpp_build.lua
return {
  name = "compile file",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "compiler" },
      args = { file },
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  -- condition = {
  --   filetype = { "cpp" },
  -- },
}
