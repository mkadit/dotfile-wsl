return {
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "user.compile_build", "user.dlv_run", "user.wsl_proxy_sync" },
    },

    keys = {
      { "<leader>aor", "<cmd>OverseerRun<cr>" },
      { "<leader>aot", "<cmd>OverseerToggle<cr>" },
      { "<leader>aol", "<cmd>OverseerQuickAction<cr>" },
      { "<leader>aoa", "<cmd>OverseerTaskAction<cr>" },
    },
  },
}
