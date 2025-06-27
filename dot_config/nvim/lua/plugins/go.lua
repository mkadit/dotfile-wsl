-- Define a local table to hold utility functions.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = false,
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          LazyVim.lsp.on_attach(function(client, _)
            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end, "gopls")
          -- end workaround
        end,
      },
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      -- go.nvim recommends guihua.lua for better UI/widgets
      "ray-x/guihua.lua",
    },
    ft = { "go", "gomod", "gosum", "gowork" }, -- Load only for Go-related filetypes
    build = ':lua require("go.install").update_all_sync()', -- Ensure Go binaries are installed
    config = function()
      -- Get LazyVim's LSP setup reference
      local lsp = require("lazyvim.plugins.lsp")
      local util = require("lazyvim.util")

      require("go").setup({
        -- LSP Configuration:
        -- We primarily rely on LazyVim's nvim-lspconfig setup for gopls.
        -- go.nvim will *integrate* with the existing LSP client.
        -- The `lsp_attach_enabled` option controls if go.nvim adds its own
        -- on_attach logic. Set to true to allow go.nvim to add its features.
        lsp_attach_enabled = true,
        -- If you want go.nvim to handle LSP client setup (e.g., if you disable LazyVim's lang.go extra)
        -- you would set `lsp_cfg = true`. But for best practice with LazyVim, keep it managed by LazyVim.
        -- lsp_cfg = false, -- This is the implicit default if lsp_attach_enabled is true and you rely on external LSP setup.

        -- DAP (Debugger) Configuration:
        -- We'll use nvim-dap and nvim-dap-go, which LazyVim configures.
        -- go.nvim provides convenience functions for DAP.
        dap_debug = true, -- Enable go.nvim's DAP integration (uses nvim-dap)
        dap_test = true, -- Enable go.nvim's DAP for tests
        dap_timeout = 15000, -- Timeout for DAP operations

        -- Code Actions & Formatting:
        goimport = "gopls", -- Use gopls for goimport (organize imports)
        goimport_autosave = true, -- Auto-run goimport on save
        gofmt = "gopls", -- Use gopls for formatting
        -- gotest_format = "go test -v -json", -- Default test command format

        -- Linting and Diagnostics:
        -- diag = {
        --   enabled = true,
        --   underline = true,
        --   -- You might want to adjust signs or virtual_text if they conflict with LazyVim's defaults
        --   signs = {
        --     error = "", -- You can customize signs
        --     warn = "",
        --     hint = "",
        --     info = "",
        --   },
        --   virtual_text = {
        --     enabled = true,
        --     -- Customize virtual text prefix if needed
        --     -- prefix = "",
        --   },
        -- },
        tags = "go", -- Use `go` for tag generation

        -- UI Options:
        luasnip = true, -- Use luasnip for snippets if you have it (LazyVim does)

        -- Custom Commands & Keymaps:
        -- This is crucial for conflict avoidance.
        -- LazyVim already defines many LSP keymaps (gd, gr, K, etc.).
        -- We'll avoid overriding them with go.nvim's defaults directly.
        -- Instead, define specific go.nvim features with unique keymaps or rely on commands.
        -- commands = { -- You can add custom commands here
        --   go_debug_last = "<cmd>GoDebugLast<CR>",
        -- },
        keys = {
          -- Example: If you want a specific go.nvim feature with a keymap:
          -- "<leader>gc" -- go.nvim's 'GoCoverage' (check if it conflicts)
          -- "<leader>gt" -- go.nvim's 'GoTest' (consider if Neotest integration is better)
          --
          -- Instead of directly mapping over LazyVim's defaults, use new ones or call commands explicitly.
          -- For example, go.nvim's "GoAddTag" is useful:
          { "gt", "<cmd>GoAddTag<CR>", mode = "x", desc = "Go: Add struct tags" },
          { "gT", "<cmd>GoRmTag<CR>", mode = "x", desc = "Go: Remove struct tags" },
          -- Debugging shortcuts provided by go.nvim that integrate with nvim-dap
          -- { "<leader>gdb", "<cmd>GoDebugBreakpoint<CR>", desc = "Go: Toggle Breakpoint" },
          -- { "<leader>gds", "<cmd>GoDebugStop<CR>", desc = "Go: Stop Debugging" },
          -- { "<leader>gdc", "<cmd>GoDebugCont<CR>", desc = "Go: Continue Debugging" },
          -- { "<leader>gdn", "<cmd>GoDebugNext<CR>", desc = "Go: Next Line" },
          -- { "<leader>gdi", "<cmd>GoDebugStepInto<CR>", desc = "Go: Step Into" },
          -- { "<leader>gdo", "<cmd>GoDebugStepOut<CR>", desc = "Go: Step Out" },
          -- { "<leader>gdr", "<cmd>GoDebugRestart<CR>", desc = "Go: Restart Debugging" },
          -- { "<leader>gdl", "<cmd>GoDebugLast<CR>", desc = "Go: Debug Last Run" },

          -- Test run/debug using go.nvim's commands that integrate with Neotest/DAP
          { "<leader>aat", "<cmd>GoTest<CR>", desc = "Go: Run current test" },
          { "<leader>aaf", "<cmd>GoTestFunc<CR>", desc = "Go: Run current function test" },
          { "<leader>aadt", "<cmd>GoDebugTest<CR>", desc = "Go: Debug current test" },
          { "<leader>aadf", "<cmd>GoDebugTestFuncg<CR>", desc = "Go: Debug current function test" },
          -- Other go.nvim features
          { "<leader>aaC", "<cmd>GoCoverageToggle<CR>", desc = "Go: Toggle Test Coverage" },
          { "<leader>aav", "<cmd>GoVet<CR>", desc = "Go: Run GoVet" },
          { "<leader>aal", "<cmd>GoLint<CR>", desc = "Go: Run GoLint" },
          { "<leader>aaa", "<cmd>GoAlternate<CR>", desc = "Go: Go to Alternate File" },
          { "<leader>aag", "<cmd>GoGenerate<CR>", desc = "Go: Run Go Generate" },
          { "<leader>aai", "<cmd>GoIfErr<CR>", desc = "Go: If error snippet" },
          { "<leader>aaF", "<cmd>GoFillStruct<CR>", desc = "Go: Fill struct" },
          { "<leader>aas", "<cmd>GoStack<CR>", desc = "Go: View Stack" },
          { "<leader>aae", "<cmd>GoExport<CR>", desc = "Go: Export Symbol" },
        },

        gotests_template = "testify",
      })
    end,
  },

  -- {
  --   "leoluz/nvim-dap-go",
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     opts.dap_configurations = opts.dap_configurations or {} -- ensure it's a table
  --     table.insert(opts.dap_configurations, {
  --       type = "go",
  --       name = "Debug main package",
  --       request = "launch",
  --       cwd = "${workspaceFolder}",
  --       program = function()
  --         local cwd = vim.fn.getcwd()
  --         local foldername = vim.fn.fnamemodify(cwd, ":t")
  --         local file = cwd .. "/cmd/" .. string.lower(foldername) .. "/main.go"
  --         vim.notify(file)
  --         return file
  --       end,
  --     })
  --
  --     table.insert(opts.dap_configurations, {
  --       type = "go",
  --       name = "Debug Current",
  --       request = "launch",
  --       program = "${workspaceFolder}/cmd/fds-suisei",
  --       cwd = "${workspaceFolder}",
  --     })
  --   end,
  -- },
}
