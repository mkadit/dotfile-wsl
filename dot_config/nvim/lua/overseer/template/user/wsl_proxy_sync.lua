-- /home/stevearc/.config/nvim/lua/overseer/template/user/cpp_build.lua
return {
  name = "WSL proxy sync",
  builder = function()
    -- Full path to current file (see :help expand())
    return {
      cmd = { "source" },
      args = { "wsl-proxy-sync" },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  -- condition = {
  --   filetype = { "cpp" },
  -- },
}
