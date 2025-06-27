-----------------------------------------providerSelector-------------------------------------------

-- lsp->treesitter->indent
local ftMap = {
  vim = "indent",
  git = "",
}
local function customizeSelector(bufnr)
  local function handleFallbackException(err, providerName)
    if type(err) == "string" and err:match("UfoFallbackException") then
      return require("ufo").getFolds(bufnr, providerName)
    else
      return require("promise").reject(err)
    end
  end

  return require("ufo")
    .getFolds(bufnr, "lsp")
    :catch(function(err)
      return handleFallbackException(err, "treesitter")
    end)
    :catch(function(err)
      return handleFallbackException(err, "indent")
    end)
end

-----------------------------------------providerSelector-------------------------------------------

------------------------------------------enhanceAction---------------------------------------------
local function peekOrHover()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if winid then
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
    for _, k in ipairs(keys) do
      -- Add a prefix key to fire `trace` action,
      -- if Neovim is 0.8.0 before, remap yourself
      vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = bufnr })
    end
  else
    -- nvimlsp
    vim.lsp.buf.hover()
  end
end

local function goPreviousClosedAndPeek()
  require("ufo").goPreviousClosedFold()
  require("ufo").peekFoldedLinesUnderCursor()
end

local function goNextClosedAndPeek()
  require("ufo").goNextClosedFold()
  require("ufo").peekFoldedLinesUnderCursor()
end

local function applyFoldsAndThenCloseAllFolds(providerName)
  require("async")(function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- make sure buffer is attached
    require("ufo").attach(bufnr)
    -- getFolds return Promise if providerName == 'lsp'
    local ranges = await(require("ufo").getFolds(bufnr, providerName))
    if not vim.tbl_isempty(ranges) then
      local ok = require("ufo").applyFolds(bufnr, ranges)
      if ok then
        require("ufo").closeAllFolds()
      end
    end
  end)
end

return {

  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
    event = "BufReadPost",
    init = function()
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldcolumn = "1"
      vim.o.foldenable = true
    end,
    config = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return ftMap[filetype] or customizeSelector
        end,
      })
    end,
    keys = {
    -- stylua: ignore start
    { "[z", goPreviousClosedAndPeek, desc = "Goto Prev Fold" },
    { "]z", goNextClosedAndPeek, desc = "Goto Next Fold" },
    { "K", peekOrHover, desc = "Peek or Hover" },
    { "zK", applyFoldsAndThenCloseAllFolds, desc = "Apply and Close all folds" },
    { "zM", function() require('ufo').openAllFolds() end, desc = "Open all folds" },
    { "zR", function() require('ufo').closeAllFolds() end, desc = "Close all folds" },
      -- stylua: ignore end
    },
  },
}
