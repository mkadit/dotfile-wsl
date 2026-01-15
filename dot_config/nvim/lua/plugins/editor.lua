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
    "nvim-mini/mini.align",
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

  {
    "esmuellert/vscode-diff.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("vscode-diff").setup({
        -- Diff view behavior
        diff = {
          disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
          max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
        },
      })
    end,
  },

  --git portal
  {
    "trevorhauter/gitportal.nvim",
    event = "VeryLazy",
    config = function()
      require("gitportal").setup({})
    end,
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
      require("textcase").setup({
        -- default_keymappings_enabled = false,
        prefix = "gAr",
        enabled_methods = {
          "to_upper_case",
          "to_lower_case",
          "to_snake_case",
          "to_dash_case",
          "to_title_dash_case",
          "to_constant_case",
          "to_dot_case",
          "to_comma_case",
          "to_phrase_case",
          "to_camel_case",
          "to_pascal_case",
          "to_title_case",
          "to_path_case",
          "to_upper_phrase_case",
          "to_lower_phrase_case",
        },
      })
      require("telescope").load_extension("textcase")
    end,
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

  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        keyword = "wide", -- "wide" highlights the keyword + (scope) + colon. Looks like a badge.
        pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
      },
      search = {
        -- Ripgrep regex for Telescope
        -- \b       = Word boundary
        -- \s* = Optional space
        -- \(.*\)   = Literal parens with content
        -- ?        = Optional
        pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
      },
      keywords = {
        -- 1. URGENT / DANGER
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        -- 2. WARNINGS / SMELLS
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        HACK = { icon = " ", color = "hack", alt = { "SCARY" } },
        -- 3. TASKS
        TODO = { icon = " ", color = "info" }, -- Blue
        CHORE = { icon = " ", color = "chore", alt = { "MAINTAIN" } },
        -- 4. PERFORMANCE / TESTING
        PERF = { icon = " ", color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        -- 5. CONTEXT / INFO
        NOTE = { icon = " ", color = "note", alt = { "INFO", "THOUGHT" } },
        NIT = { icon = "✎ ", color = "nit", alt = { "NITPICK" } },
        -- 6. COLLABORATION (Conventional Comments)
        SUGGEST = { icon = " ", color = "suggestion", alt = { "SUGGESTION" } },
        PRAISE = { icon = " ", color = "praise", alt = { "NICE", "GOOD" } },
        QUESTION = { icon = " ", color = "question", alt = { "Q", "QUERY" } },
      },

      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        -- Standard Mappings
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" }, -- Red
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" }, -- Yellow
        info = { "DiagnosticInfo", "#2563EB" }, -- Strong Blue

        -- Distinct Overrides
        hack = { "#D97706" }, -- Burnt Orange
        chore = { "#4338ca" }, -- Indigo (Deep Blue/Purple)
        perf = { "#7C3AED" }, -- Violet
        test = { "Identifier", "#FF00FF" }, -- Magenta/Fuchsia
        note = { "DiagnosticHint", "#10B981" }, -- Emerald/Mint
        nit = { "Comment", "#9CA3AF" }, -- Grey

        -- Collaboration Colors
        suggestion = { "#06B6D4" }, -- Cyan/Electric Blue
        praise = { "DiagnosticOk", "#84CC16" }, -- Lime (Bright Green)
        question = { "#FF1D8D" }, -- Rose/Red-Pink
      },
    },
  },
}
