local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local config_picker = function(opts)
  opts = opts or {}

  pickers
    .new(opts, {
      prompt_title = "Open Configuration for:",
      finder = finders.new_table({
        results = {
          { "alacritty", "~/.config/alacritty/alacritty.yml" },
          { "backup", "~/.local/bin/backup" },
          { "chezmoi", "~/.local/share/chezmoi/README.md", cd = true },
          { "install.sh", "~/.local/src/script/install.sh", cd = true },
          { "neovim plugins", "~/.local/share/nvim/harpoon.json", cd = true },
          { "neovim", "~/.config/nvim/init.lua", cd = true },
          { "obsidian", "~/Documents/records/vault/personal/index.md", cd = true },
          { "waybar", "~/.config/waybar/config.ctl", cd = true },
          { "hyprland", "~/.config/hypr/hyprland.conf", cd = true },
          { "tmux", "~/.config/tmux/tmux.conf" },
          { "vifm", "~/.config/vifm/vifmrc" },
          { "vscode", "~/.config/Code/User/settings.json", cd = true },
          { "youtube-src", "~/.local/src/script/youtube-source.txt" },
          { "cheatsheet", "~/.local/share/navi/cheats/main.cheat" },
          { "zsh", "~/.zshrc" },
        },
        entry_maker = function(entry)
          return {
            value = entry[1],
            display = entry[1],
            ordinal = entry[1],
            path = vim.fn.expand(entry[2]),
            cd = entry.cd or false,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = conf.file_previewer(opts),
      attach_mappings = function(prompt_bufnr) -- , map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection.cd then
            vim.cmd.cd(vim.fs.dirname(selection.path))
          end
          vim.cmd.edit(selection.path)
        end)
        return true
      end,
    })
    :find()
end

return require("telescope").register_extension({
  exports = { config_pick = config_picker },
})
