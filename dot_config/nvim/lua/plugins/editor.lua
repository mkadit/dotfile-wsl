return {

  -- sudo
  { "lambdalisue/suda.vim", event = "VeryLazy" },

  -- root directory
  {
    "airblade/vim-rooter",
    event = "VeryLazy",
    keys = {
      {
        "<Leader>aj",
        "<CMD>Rooter | cd .<CR>",
        desc = "To currend directory root",
      },
    },
  },

  -- align
  {
    "echasnovski/mini.align",
    event = "VeryLazy",
    config = function()
      require("mini.align").setup()
    end,
  },

  -- git
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-telescope/telescope.nvim", -- optional
    },
    event = "VeryLazy",
    config = function()
      require("neogit").setup()
    end,

    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "Neogit", remap = true },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, "Next Diff")

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, "Prev Diff")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  -- diff
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",

    --stylua: ignore
    keys = {
      { "<leader>gdo", ":DiffviewOpen ", desc = "Diff Against Branch" },
      { "<leader>gdr", "<cmd>DiffviewFileHistory<cr>", desc = "Diff Repo History" },
      { "<leader>gdF", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "Diff File Git History" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory --follow<cr>", desc = "Diff Line Git History", mode = { "v" } },
      { "<leader>gdc", "<cmd>DiffviewClose", desc = "Close Diff" },
    },
  },

  --git gist
  {
    "mattn/vim-gist",
    event = "VeryLazy",
    keys = {
      {
        "<leader>gSd",
        "<CMD>Gist -d<CR>",
        desc = "Delete gist",
      },
      {
        "<leader>gSl",
        "<CMD>Gist -l<CR>",
        desc = "Gist list",
      },
      {
        "<leader>gSm",
        "<CMD>Gist -a<CR>",
        desc = "Create gist with all buffers",
      },
      {
        "<leader>gSg",
        "<CMD>Gist<CR>",
        desc = "Create a gist",
      },
    },
  },
  { "mattn/webapi-vim", event = "VeryLazy" },

  -- text case change
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "gA", -- Default invocation prefix
      { "gA.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    -- cmd = {
    --   -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
    --   "Subs",
    --   "TextCaseOpenTelescope",
    --   "TextCaseOpenTelescopeQuickChange",
    --   "TextCaseOpenTelescopeLSPChange",
    --   "TextCaseStartReplacingCommand",
    -- },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    event = "VeryLazy",
  },

  -- file manager
  {
    "stevearc/oil.nvim",
    -- event = "VeryLazy",
    opts = {},
  },
  {
    "vifm/vifm.vim",
    event = "VeryLazy",
    keys = {
      {
        "<Leader>av",
        "<CMD>Vifm<CR>",
        desc = "File manager",
      },
    },
  },
}
