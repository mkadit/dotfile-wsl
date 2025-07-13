return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  --stylua: ignore start
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    "BufReadPre ".. vim.fn.expand("~").."/Documents/Notes/notes/**.md",
    "BufNewFile ".. vim.fn.expand("~").."/Documents/Notes/notes/**.md",

    "BufReadPre ".. vim.fn.expand("~").."/WDocuments/Notes/notes/**.md",
    "BufNewFile ".. vim.fn.expand("~").."/WDocuments/Notes/notes/**.md",


  },
    --stylua: ignore end
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/WDocuments/Notes/notes",
        },
      },
      --
      templates = {
        subdir = "009-Extras/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- You may have as many periods in the note ID as you'd like—the ".md" will be added automatically
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      -- Optional, customize how wiki links are formatted. You can set this to one of:
      -- _ "use_alias_only", e.g. '[[Foo Bar]]'
      -- _ "prepend*note_id", e.g. '[[foo-bar|Foo Bar]]'
      -- * "prepend*note_path", e.g. '[[foo-bar.md|Foo Bar]]'
      -- * "use_path_only", e.g. '[[foo-bar.md]]'
      -- Or you can set it to a function that takes a table of options and returns a string, like this:
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_alias_only(opts)
      end,

      -- Optional, customize how markdown links are formatted.
      -- markdown_link_func = function(opts)
      --   return require("obsidian.util").markdown_link(opts)
      -- end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "wiki",

      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      attachments = {
        img_folder = "009-Extras/Assets",
        img_name_func = function()
          return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
        end,
        confirm_img_paste = true,
      },

      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 2,
        create_new = true,
      },

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
        name = "snacks.pick",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>abc"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<leader>aba"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
    },

    keys = {
      {
        "<CR>",
        "<CMD>Obsidian follow_link<CR>",
        desc = "Follow Link",
      },
      {
        "<Backspace>",
        "<CMD>Obsidian backlinks<CR>",
        desc = "Backlinks",
      },
      {
        "<leader>abT",
        "<CMD>Obsidian tags<CR>",
        desc = "Tags",
      },
      {
        "<leader>abt",
        "<CMD>Obsidian templates<CR>",
        desc = "Templates",
      },
      {
        "<leader>abN",
        "<CMD>Obsidian new_from_template<CR>",
        desc = "New From Template",
      },
      {
        "<leader>abp",
        "<CMD>Obsidian paste_img<CR>",
        desc = "Paste Image",
      },

      {
        "<leader>abs",
        "<CMD>Obsidian search<CR>",
        desc = "Search in Obsidian",
      },
      {
        "<leader>abf",
        "<CMD>Obsidian quick_switch<CR>",
        desc = "Switch Files",
      },
      {
        "<leader>abe",
        "<CMD>Obsidian extract_note<CR>",
        desc = "Extract and create new file",
        mode = "v",
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.image = opts.image or {}
      local obsidian_ok, obsidian_api = pcall(require, "obsidian.api")
      if obsidian_ok then
        opts.image.resolve = function(path, src)
          if obsidian_api.path_is_note(path) then
            -- return obsidian_api.resolve_image_path(src .. "/009-Extras/Assets")
            return obsidian_api.resolve_image_path(src)
          end
        end
      end
    end,
  },
}
