return {
  {
    "mfussenegger/nvim-dap",

    -- stylua: ignore
    keys =  function()
      return {
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
        { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
        { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end, desc = "Down" },
        { "<leader>dk", function() require("dap").up() end, desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
        { "<leader>ds", function() require("dap").session() end, desc = "Session" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      }
    end,
  },

  {
    "andythigpen/nvim-coverage",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest",
    },
    config = function()
      require("coverage").setup({
        auto_reload = true,
      })
    end,
    keys = {
      {
        "<leader>tC",
        function()
          local cov = require("coverage")
          cov.load(true)
          cov.summary()
        end,
        desc = "Coverage Summary",
      },
      {
        "<leader>tc",
        function()
          local cov = require("coverage")
          cov.toggle()
        end,
        desc = "Coverage Toggle",
      },

      {
        "]v",
        function()
          local cov = require("coverage")
          cov.jump_next("uncovered")
        end,
        desc = "Next coverage uncovered",
      },
      {
        "[v",
        function()
          local cov = require("coverage")
          cov.jump_prev("uncovered")
        end,
        desc = "Previous coverage uncovered",
      },
    },
  },
}
