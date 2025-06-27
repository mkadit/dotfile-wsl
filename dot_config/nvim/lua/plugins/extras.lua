local leet_arg = "leet.nvim"
return {
  -- devdocs
  -- {
  --   "maskudo/devdocs.nvim",
  --   lazy = false,
  --   dependencies = {
  --     "folke/snacks.nvim",
  --   },
  --   cmd = { "DevDocs" },
  --   keys = {
  --     {
  --       "<leader>sv",
  --       mode = "n",
  --       ":DevDocs get ",
  --       desc = "Get Devdocs",
  --     },
  --     {
  --       "<leader>sv",
  --       mode = "n",
  --       function()
  --         local devdocs = require("devdocs")
  --         local installedDocs = devdocs.GetInstalledDocs()
  --         vim.ui.select(installedDocs, {}, function(selected)
  --           if not selected then
  --             return
  --           end
  --           local docDir = devdocs.GetDocDir(selected)
  --           -- prettify the filename as you wish
  --           Snacks.picker.files({ cwd = docDir })
  --         end)
  --       end,
  --       desc = "Get Devdocs",
  --     },
  --   },
  --   opts = {
  --     ensure_installed = {
  --       "go",
  --       -- "html",
  --       -- "dom",
  --       -- "http",
  --       -- "css",
  --       -- "javascript",
  --       -- "rust",
  --       -- some docs such as lua require version number along with the language name
  --       -- check `DevDocs install` to view the actual names of the docs
  --       -- "lua~5.1",
  --       -- "openjdk~21"
  --     },
  --   },
  -- },

  -- leetcode
  {

    "kawre/leetcode.nvim",
    lazy = leet_arg ~= vim.fn.argv()[1],
    build = ":TSUpdate html",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- recommended
      "rcarriga/nvim-notify",
    },
    opts = {
      -- configuration goes here
      arg = leet_arg,
      lang = "golang",
    },
  },

  {
    "biozz/whop.nvim",
    event = "LazyFile",
    config = function()
      require("whop").setup({
        commands = {
          { name = "Decode JWT", cmd = [[%! jc --jwt]] },
          { name = "YAML to JSON", cmd = [[%! jc --yaml]] },
          { name = "XML to JSON", cmd = [[%! jc --xml]] },
        },
      })
      require("telescope").load_extension("whop")
    end,
  },
}
