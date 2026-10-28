-- Headless regression for the friedrich colorscheme.
-- Run from the repo root:
--   nvim --clean --headless -l scripts/check.lua
-- Verifies: palette anchor fidelity, the syntax-role hue mapping, the
-- no-decoration doctrine (with the undercurl exemption), and the reserved
-- red never appearing in syntax roles.

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.runtimepath:prepend(root)
vim.cmd("colorscheme friedrich")

local p = require("friedrich.palette")

local failures = {}
local function check(label, ok, detail)
  if not ok then
    table.insert(failures, label .. (detail and (" — " .. detail) or ""))
  end
end

local function fg_of(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  if hl.fg then return string.format("#%06x", hl.fg) end
  return nil
end

-- 1. Syntax-role hue mapping (consensus table)
check("Normal fg", fg_of("Normal") == p.fg)
check("Normal bg", vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg == tonumber(p.bg:sub(2), 16))
check("Comment fg is the derived fog gray", fg_of("Comment") == p.comment)
check("Statement (keyword) is magenta", fg_of("Statement") == p.magenta)
check("Function is blue", fg_of("Function") == p.blue)
check("String is green", fg_of("String") == p.green)
check("Constant is yellow", fg_of("Constant") == p.yellow)
check("Type is cyan", fg_of("Type") == p.cyan)
check("Identifier is muted fg", fg_of("Identifier") == p.muted)

-- 2. Reserved red never appears in syntax roles
local syntax_roles = {
  "Comment", "Constant", "String", "Character", "Number", "Boolean", "Float",
  "Identifier", "Function", "Statement", "Conditional", "Repeat", "Label",
  "Keyword", "Exception", "Operator", "PreProc", "Include", "Define", "Macro",
  "PreCondit", "Type", "StorageClass", "Structure", "Typedef", "Special",
  "SpecialChar", "Tag", "Delimiter", "SpecialComment", "Debug", "Underlined",
}
for _, group in ipairs(syntax_roles) do
  check("red reserved: " .. group, fg_of(group) ~= p.red)
end

-- 3. Decoration ban: no bold/italic/underline/strikethrough anywhere;
--    undercurl only on functional indicators.
local functional_undercurl = {
  SpellBad = true, SpellCap = true, SpellRare = true, SpellLocal = true,
  DiagnosticUnderlineError = true, DiagnosticUnderlineWarn = true,
  DiagnosticUnderlineInfo = true, DiagnosticUnderlineHint = true,
  DiagnosticUnderlineOk = true,
}
for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
  if hl.bold then check("no bold: " .. name, false) end
  if hl.italic then check("no italic: " .. name, false) end
  if hl.underline then check("no underline: " .. name, false) end
  if hl.strikethrough then check("no strikethrough: " .. name, false) end
  if hl.undercurl and not functional_undercurl[name] then
    check("undercurl only functional: " .. name, false)
  end
end

-- 4. Terminal palette: exact anchors, slot order preserved
local slots = {
  p.black, p.red, p.green, p.yellow, p.blue, p.magenta, p.cyan, p.white,
  p.bright_black, p.bright_red, p.bright_green, p.bright_yellow,
  p.bright_blue, p.bright_magenta, p.bright_cyan, p.bright_white,
}
for i, color in ipairs(slots) do
  check("terminal slot " .. (i - 1), vim.g["terminal_color_" .. (i - 1)] == color)
end
check("terminal fg", vim.g.terminal_color_foreground == p.fg)
check("terminal bg", vim.g.terminal_color_background == p.bg)

-- 5. Diagnostics follow the semantic hue assignment
check("DiagnosticError uses bright_red (WCAG text)", fg_of("DiagnosticError") == p.bright_red)
check("DiagnosticWarn yellow", fg_of("DiagnosticWarn") == p.yellow)
check("DiagnosticInfo blue", fg_of("DiagnosticInfo") == p.blue)
check("DiagnosticHint cyan", fg_of("DiagnosticHint") == p.cyan)
check("virtual text error is soft (WCAG-exempt design)", fg_of("DiagnosticVirtualTextError") == p.soft.red)

-- 6. WCAG contrast metrics (see scripts/wcag.lua for the full report)
local wcag = dofile(root .. "/scripts/wcag.lua")
for _, r in ipairs(wcag.results()) do
  if not r.pass then
    check(("WCAG %s %.2f < %s: %s"):format(r.tier, r.ratio, tostring(r.target), r.name), false)
  end
end
local mins = {}
for _, r in ipairs(wcag.results()) do
  if r.target then
    local m = mins[r.tier]
    if not m or r.ratio < m.ratio then
      mins[r.tier] = r
    end
  end
end
for _, tier in ipairs({ "body", "secondary", "ui" }) do
  local m = mins[tier]
  if m then
    print(("wcag %-9s min %.2f (target %.1f) — %s"):format(tier, m.ratio, m.target, m.name))
  end
end

if #failures == 0 then
  print("PASS")
  os.exit(0)
else
  print("FAIL (" .. #failures .. ")")
  for _, f in ipairs(failures) do
    print("  - " .. f)
  end
  os.exit(1)
end
