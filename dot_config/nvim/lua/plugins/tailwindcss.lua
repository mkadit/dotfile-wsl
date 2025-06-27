return {
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    event = "VeryLazy",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
      "neovim/nvim-lspconfig", -- optional
    },
    opts = {

      document_color = {
        enabled = true, -- can be toggled by commands
        kind = "inline", -- "inline" | "foreground" | "background"
        -- inline_symbol = "󰝤 ", -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        enabled = false, -- can be toggled by commands
        min_length = 60, -- only conceal classes exceeding the provided length
        -- symbol = "󱏿", -- only a single character is allowed
        -- highlight = { -- extmark highlight options, see :h 'highlight'
        --   fg = "#38BDF8",
        -- },
      },
    },
  },
}
