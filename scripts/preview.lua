-- Generates an HTML style preview using the exact palette values.
-- Run from the repo root:
--   nvim --clean --headless -l scripts/preview.lua
-- Output: /tmp/friedrich-preview/preview.html

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.runtimepath:prepend(root)
local p = require("friedrich.palette")

local out_dir = "/tmp/friedrich-preview"
vim.fn.mkdir(out_dir, "p")

local function esc(s)
  return (s:gsub("[<>&]", { ["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;" }))
end

local function span(cls, text)
  return ('<span class="%s">%s</span>'):format(cls, esc(text))
end

local function line(n, body, extra)
  return ('<div class="line%s"><span class="num">%d</span><span class="code">%s</span></div>')
    :format(extra and (" " .. extra) or "", n, body)
end

-- Token classes: kw keyword, fn function, str string, const constant,
-- type type, var variable/property, punct punctuation, com comment.
local lua_lines = {
  line(1, span("com", "-- Minimal surface: every hue earns its place.")),
  line(2, span("kw", "local") .. " " .. span("var", "M") .. " " .. span("punct", "=") .. " " .. span("punct", "{}")),
  line(3, ""),
  line(4, span("kw", "local") .. " " .. span("const", "DEFAULTS") .. " " .. span("punct", "=") .. " " .. span("punct", "{") .. span("var", "depth") .. " " .. span("punct", "=") .. " " .. span("const", "3") .. span("punct", ",") .. " " .. span("var", "verbose") .. " " .. span("punct", "=") .. " " .. span("const", "false") .. span("punct", "}")),
  line(5, ""),
  line(6, span("com", "--- Collect reachable nodes from the root.")),
  line(7, span("kw", "function") .. " " .. span("var", "M") .. span("punct", ".") .. span("fn", "collect") .. span("punct", "(") .. span("var", "root") .. span("punct", ",") .. " " .. span("var", "opts") .. span("punct", ")")),
  line(8, "  " .. span("var", "opts") .. " " .. span("punct", "=") .. " " .. span("var", "vim") .. span("punct", ".") .. span("fn", "tbl_extend") .. span("punct", "(") .. span("str", '"force"') .. span("punct", ",") .. " " .. span("const", "DEFAULTS") .. span("punct", ",") .. " " .. span("var", "opts") .. " " .. span("kw", "or") .. " " .. span("punct", "{}") .. span("punct", ")")),
  line(9, "  " .. span("kw", "if") .. " " .. span("var", "opts") .. span("punct", ".") .. span("var", "depth") .. " " .. span("punct", "<=") .. " " .. span("const", "0") .. " " .. span("kw", "then"), "cursorline"),
  line(10, "    " .. span("kw", "return") .. " " .. span("punct", "{}")),
  line(11, "  " .. span("kw", "end")),
  line(12, "  " .. span("kw", "local") .. " " .. span("var", "seen") .. span("punct", ",") .. " " .. span("var", "queue") .. " " .. span("punct", "=") .. " " .. span("punct", "{}") .. span("punct", ",") .. " " .. span("punct", "{") .. " " .. span("var", "root") .. " " .. span("punct", "}")),
  line(13, "  " .. span("kw", "while") .. " " .. span("punct", "#") .. span("var", "queue") .. " " .. span("punct", ">") .. " " .. span("const", "0") .. " " .. span("kw", "do")),
  line(14, "    " .. span("kw", "local") .. " " .. span("var", "node") .. " " .. span("punct", "=") .. " " .. span("var", "table") .. span("punct", ".") .. span("fn", "remove") .. span("punct", "(") .. span("var", "queue") .. span("punct", ",") .. " " .. span("const", "1") .. span("punct", ")")),
  line(15, "    " .. span("kw", "if") .. " " .. span("kw", "not") .. " " .. span("var", "seen") .. span("punct", "[") .. span("var", "node") .. span("punct", ".") .. span("var", "id") .. span("punct", "]") .. " " .. span("kw", "then")),
  line(16, "      " .. span("var", "seen") .. span("punct", "[") .. span("var", "node") .. span("punct", ".") .. span("var", "id") .. span("punct", "]") .. " " .. span("punct", "=") .. " " .. span("const", "true") ),
  line(17, "      " .. span("kw", "for") .. " " .. span("punct", "_") .. span("punct", ",") .. " " .. span("var", "edge") .. " " .. span("kw", "in") .. " " .. span("fn", "ipairs") .. span("punct", "(") .. span("var", "node") .. span("punct", ".") .. span("var", "edges") .. span("punct", ")") .. " " .. span("kw", "do")),
  line(18, "        " .. span("var", "queue") .. span("punct", "[") .. span("punct", "#") .. span("var", "queue") .. " " .. span("punct", "+") .. " " .. span("const", "1") .. span("punct", "]") .. " " .. span("punct", "=") .. " " .. span("var", "edge") .. span("punct", ".") .. span("var", "target") ),
  line(19, "      " .. span("kw", "end")),
  line(20, "    " .. span("kw", "end")),
  line(21, "  " .. span("kw", "end")),
  line(22, "  " .. span("kw", "return") .. " " .. span("var", "seen")),
  line(23, span("kw", "end")),
  line(24, ""),
  line(25, span("kw", "return") .. " " .. span("var", "M")),
}

local ts_lines = {
  line(1, span("com", "// Generics and annotations stay quiet; types are the cyan accent.")),
  line(2, span("kw", "export") .. " " .. span("kw", "interface") .. " " .. span("type", "Cache") .. span("punct", "<") .. span("type", "T") .. span("punct", ">") .. " " .. span("punct", "{")),
  line(3, "  " .. span("fn", "get") .. span("punct", "(") .. span("var", "key") .. span("punct", ":") .. " " .. span("type", "string") .. span("punct", "):") .. " " .. span("type", "T") .. " " .. span("punct", "|") .. " " .. span("type", "undefined")),
  line(4, "  " .. span("fn", "set") .. span("punct", "(") .. span("var", "key") .. span("punct", ":") .. " " .. span("type", "string") .. span("punct", ",") .. " " .. span("var", "value") .. span("punct", ":") .. " " .. span("type", "T") .. span("punct", "):") .. " " .. span("type", "void")),
  line(5, span("punct", "}")),
  line(6, ""),
  line(7, span("kw", "export") .. " " .. span("kw", "class") .. " " .. span("type", "BoundedCache") .. span("punct", "<") .. span("type", "T") .. span("punct", ">") .. " " .. span("kw", "implements") .. " " .. span("type", "Cache") .. span("punct", "<") .. span("type", "T") .. span("punct", ">") .. " " .. span("punct", "{")),
  line(8, "  " .. span("kw", "private") .. " " .. span("var", "entries") .. " " .. span("punct", "=") .. " " .. span("kw", "new") .. " " .. span("type", "Map") .. span("punct", "<") .. span("type", "string") .. span("punct", ",") .. " " .. span("type", "T") .. span("punct", ">()")),
  line(9, ""),
  line(10, "  " .. span("kw", "constructor") .. span("punct", "(") .. span("kw", "private") .. " " .. span("kw", "readonly") .. " " .. span("var", "limit") .. span("punct", ":") .. " " .. span("type", "number") .. " " .. span("punct", "=") .. " " .. span("const", "16") .. span("punct", ")") .. " " .. span("punct", "{}"), "cursorline"),
  line(11, ""),
  line(12, "  " .. span("fn", "get") .. span("punct", "(") .. span("var", "key") .. span("punct", ":") .. " " .. span("type", "string") .. span("punct", "):") .. " " .. span("type", "T") .. " " .. span("punct", "|") .. " " .. span("type", "undefined") .. " " .. span("punct", "{")),
  line(13, "    " .. span("kw", "return") .. " " .. span("var", "this") .. span("punct", ".") .. span("var", "entries") .. span("punct", ".") .. span("fn", "get") .. span("punct", "(") .. span("var", "key") .. span("punct", ")")),
  line(14, "  " .. span("punct", "}")),
  line(15, ""),
  line(16, "  " .. span("fn", "set") .. span("punct", "(") .. span("var", "key") .. span("punct", ":") .. " " .. span("type", "string") .. span("punct", ",") .. " " .. span("var", "value") .. span("punct", ":") .. " " .. span("type", "T") .. span("punct", "):") .. " " .. span("type", "void") .. " " .. span("punct", "{")),
  line(17, "    " .. span("kw", "if") .. " " .. span("var", "this") .. span("punct", ".") .. span("var", "entries") .. span("punct", ".") .. span("var", "size") .. " " .. span("punct", ">=") .. " " .. span("var", "this") .. span("punct", ".") .. span("var", "limit") .. " " .. span("punct", "{")),
  line(18, "      " .. span("kw", "const") .. " " .. span("var", "oldest") .. " " .. span("punct", "=") .. " " .. span("var", "this") .. span("punct", ".") .. span("var", "entries") .. span("punct", ".") .. span("fn", "keys") .. span("punct", "().") .. span("fn", "next") .. span("punct", "().") .. span("var", "value")),
  line(19, "      " .. span("var", "this") .. span("punct", ".") .. span("var", "entries") .. span("punct", ".") .. span("fn", "delete") .. span("punct", "(") .. span("var", "oldest") .. span("punct", ")")),
  line(20, "    " .. span("punct", "}")),
  line(21, "    " .. span("var", "this") .. span("punct", ".") .. span("var", "entries") .. span("punct", ".") .. span("fn", "set") .. span("punct", "(") .. span("var", "key") .. span("punct", ",") .. " " .. span("var", "value") .. span("punct", ")")),
  line(22, "  " .. span("punct", "}")),
  line(23, span("punct", "}")),
}

local tpl = [[<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>friedrich preview</title>
<style>
  body { margin: 0; background: %(bg)s; color: %(fg)s;
         font-family: ui-monospace, "JetBrains Mono", monospace;
         display: flex; gap: 32px; padding: 32px; }
  .pane { background: %(bg)s; border: 1px solid %(border)s; border-radius: 6px;
          padding: 16px 0; width: 720px; }
  .pane h2 { margin: 0 16px 12px; font-size: 12px; font-weight: normal;
             color: %(com)s; letter-spacing: 0.08em; text-transform: uppercase; }
  .line { display: flex; line-height: 1.55; font-size: 14px; white-space: pre; }
  .line.cursorline { background: %(cursorline)s; }
  .num { width: 48px; text-align: right; padding-right: 16px; color: %(linenr)s;
         user-select: none; }
  .kw { color: %(magenta)s; } .fn { color: %(blue)s; } .str { color: %(green)s; }
  .const { color: %(yellow)s; } .type { color: %(cyan)s; }
  .var { color: %(muted)s; } .punct { color: %(muted)s; } .com { color: %(com)s; }
</style>
</head>
<body>
  <div class="pane"><h2>Lua</h2>@@LUA@@</div>
  <div class="pane"><h2>TypeScript &mdash; generics &amp; annotations</h2>@@TS@@</div>
</body>
</html>]]

local vars = {
  bg = p.bg, fg = p.fg, border = p.border, com = p.comment, cursorline = p.cursorline,
  linenr = p.linenr, magenta = p.magenta, blue = p.blue, green = p.green,
  yellow = p.yellow, cyan = p.cyan, muted = p.muted,
}
local html = tpl:gsub("%%%((%w+)%)s", vars)
html = html:gsub("@@LUA@@", function() return table.concat(lua_lines, "\n") end)
html = html:gsub("@@TS@@", function() return table.concat(ts_lines, "\n") end)

local path = out_dir .. "/preview.html"
local f = assert(io.open(path, "w"))
f:write(html)
f:close()
print("wrote " .. path)
