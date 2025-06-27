local ls = require("luasnip") --{{{
local s = ls.s --> snippet
local i = ls.i --> insert mode
local t = ls.t --> text mode

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"

local function cs(trigger, nodes, opts) --{{{
  local snippet = s(trigger, nodes)
  local target_table = snippets

  local pattern = file_pattern
  local keymaps = {}

  if opts ~= nil then
    -- check for custom pattern
    if opts.pattern then
      pattern = opts.pattern
    end

    -- if opts is a string
    if type(opts) == "string" then
      if opts == "auto" then
        target_table = autosnippets
      else
        table.insert(keymaps, { "i", opts })
      end
    end

    -- if opts is a table
    if opts ~= nil and type(opts) == "table" then
      for _, keymap in ipairs(opts) do
        if type(keymap) == "string" then
          table.insert(keymaps, { "i", keymap })
        else
          table.insert(keymaps, keymap)
        end
      end
    end

    -- set autocmd for each keymap
    if opts ~= "auto" then
      for _, keymap in ipairs(keymaps) do
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = pattern,
          group = group,
          callback = function()
            vim.keymap.set(keymap[1], keymap[2], function()
              ls.snip_expand(snippet)
            end, { noremap = true, silent = true, buffer = true })
          end,
        })
      end
    end
  end

  table.insert(target_table, snippet) -- insert snippet into appropriate table
end --}}}

local snips = require("util.snips")
local in_test_fn = {
  show_condition = snips.in_test_function,
  condition = snips.in_test_function,
}

local in_test_file = {
  show_condition = snips.in_test_file_fn,
  condition = snips.in_test_file_fn,
}

local in_fn = {
  show_condition = snips.in_function,
  condition = snips.in_function,
}

local not_in_fn = {
  show_condition = snips.in_func,
  condition = snips.in_func,
}

-- Start Refactoring --
local okr = s(
  { trig = "okr", name = "check err and ok", dscr = "Call a function and check the error or if value is  ok" },
  {
    c(1, {
      fmt(
        [[
        {val}, {err1} := {func}({args})
        if {err2} != nil {{
          return {err3}
        }}
        {finally}
      ]],
        {
          val = ls.i(1, { "val" }),
          err1 = ls.i(2, { "err" }),
          func = ls.i(3, { "func" }),
          args = ls.i(4),
          err2 = rep(2),
          err3 = ls.d(5, snips.make_return_nodes, { 2 }),
          finally = ls.i(0),
        }
      ),
      fmt(
        [[
        if {err1} := {func}({args}); {err2} != nil {{
          return {err3}
        }}
        {finally}
        ]],
        {
          err1 = ls.i(1, { "err" }),
          func = ls.i(2, { "func" }),
          args = ls.i(3, { "args" }),
          err2 = rep(1),
          err3 = ls.d(4, snips.make_return_nodes, { 1 }),
          finally = ls.i(0),
        }
      ),
      fmt(
        [[
        {val}, {err1} := {func}({args})
        if !{err2} {{
          return {err3}
        }}
        {finally}
      ]],
        {
          val = ls.i(1, { "val" }),
          err1 = ls.i(2, { "ok" }),
          func = ls.i(3, { "func" }),
          args = ls.i(4),
          err2 = rep(2),
          err3 = ls.d(5, snips.make_return_nodes, { 2 }),
          finally = ls.i(0),
        }
      ),
    }),
  }
)

table.insert(snippets, okr)

local ifc = s(
  { trig = "fn", name = "Function", dscr = "Create a function or a method" },
  fmt(
    [[
        // {name1} {desc}
        func {rec}{name2}({args}) {ret} {{
          {finally}
        }}
      ]],
    {
      name1 = rep(2),
      desc = ls.i(5, "description"),
      rec = ls.c(1, {
        ls.t(""),
        ls.sn(
          nil,
          fmt("({} {}) ", {
            ls.i(1, "r"),
            ls.i(2, "receiver"),
          })
        ),
      }),
      name2 = ls.i(2, "Name"),
      args = ls.i(3),
      ret = ls.c(4, {
        ls.i(1, "error"),
        ls.sn(
          nil,
          fmt("({}, {}) ", {
            ls.i(1, "ret"),
            ls.i(2, "error"),
          })
        ),
      }),
      finally = ls.i(0),
    }
  ),
  not_in_fn
)
table.insert(snippets, ifc)

local fsel = s(
  { trig = "fsel", dscr = "for select" },
  fmt(
    [[
for {{
	  select {{
        case {} <- {}:
			      {}
        default:
            {}
	  }}
}}
]],
    {
      ls.c(1, { ls.i(1, "ch"), ls.i(2, "ch := ") }),
      ls.i(2, "ch"),
      ls.i(3, "break"),
      ls.i(0, ""),
    }
  )
)
table.insert(snippets, fsel)

local tysw =
  s(
    { trig = "tysw", dscr = "type switch" },
    fmt(
      [[
switch {} := {}.(type) {{
    case {}:
        {}
    default:
        {}
}}
]],
      {
        ls.i(1, "v"),
        ls.i(2, "i"),
        ls.i(3, "int"),
        ls.i(4, 'fmt.Println("int")'),
        ls.i(0, ""),
      }
    )
  ),
  -- fmt.Sprintf
  ls.s(
    { trig = "spn", dscr = "fmt.Sprintf" },
    fmt([[fmt.Sprintf("{}%{}", {})]], {
      ls.i(1, "msg "),
      ls.i(2, "+v"),
      ls.i(2, "arg"),
    })
  )
table.insert(snippets, tysw)

local mk = s(
  { trig = "mk", name = "Make", dscr = "Allocate map or slice" },
  fmt("{} {}= make({})\n{}", {
    ls.i(1, "name"),
    ls.i(2),
    ls.c(3, {
      fmt("[]{}, {}", { ls.r(1, "type"), ls.i(2, "len") }),
      fmt("[]{}, 0, {}", { ls.r(1, "type"), ls.i(2, "len") }),
      fmt("map[{}]{}, {}", { ls.r(1, "type"), ls.i(2, "values"), ls.i(3, "len") }),
    }, {
      stored = {
        type = ls.i(1, "type"),
      },
    }),
    ls.i(0),
  }),
  in_fn
)

table.insert(snippets, mk)
-- End Refactoring --

return snippets, autosnippets
