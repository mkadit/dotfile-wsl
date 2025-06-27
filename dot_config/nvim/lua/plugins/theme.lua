return {
  {
    "EdenEast/nightfox.nvim",
    event = "VeryLazy",
    name = "nightfox",
  },
  {
    "neanias/everforest-nvim",
    name = "everforest",
    version = false,
    event = "VeryLazy",
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        -- Your config here
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },
}
