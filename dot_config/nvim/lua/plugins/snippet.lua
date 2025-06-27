return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        local snippets_folder = vim.fn.stdpath("config") .. "/snippets"
        require("luasnip.loaders.from_vscode").lazy_load()
        -- require("luasnip.loaders.from_vscode").lazy_load({ paths = snippets_folder .. "/vscode_snippets/" })
        require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        require("luasnip.loaders.from_lua").lazy_load({ paths = snippets_folder .. "/luasnip/" })
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    },
    -- stylua: ignore
    keys = function()
    return 
      {
        {
          "<tab>",
          function()
            return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
          end,
          expr = true, silent = true, mode = "i",
        },
        { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
        { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        { "<c-s>", 
          function() 
            local ls = require("luasnip")
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end, mode = { "i", "s" } },
      }
    end,
  },
}
