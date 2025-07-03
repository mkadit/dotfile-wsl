return {
  {
    "EdenEast/nightfox.nvim",
    event = "VeryLazy",
    name = "nightfox",
  },
  { "rose-pine/neovim", event = "VeryLazy", name = "rose-pine" },
  { "sainnhe/gruvbox-material", event = "VeryLazy", name = "gruvbox-material" },
  { "Mofiqul/dracula.nvim", event = "VeryLazy", name = "dracula" },
  {
    "neanias/everforest-nvim",
    name = "everforest",
    version = false,
    event = "VeryLazy",
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },
}
