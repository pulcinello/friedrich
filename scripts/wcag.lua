-- WCAG 2.1 contrast audit for the friedrich colorscheme.
-- Contrast ratios use the standard relative-luminance formula:
--   (L_lighter + 0.05) / (L_darker + 0.05)
-- Tiers (WCAG AA):
--   body      >= 4.5 : readable code text
--   secondary >= 3.0 : secondary/incidental text (AA large-text level)
--   ui        >= 3.0 : non-text UI (WCAG 1.4.11)
-- The background anchor (#333344) is fixed by design; remedies are fg-side only.

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.runtimepath:prepend(root)
local p = require("friedrich.palette")

local M = {}

M.TIER_TARGET = { body = 4.5, secondary = 3.0, ui = 3.0, exempt = nil }

local function srgb_to_linear(c)
  c = c / 255
  if c <= 0.04045 then
    return c / 12.92
  end
  return ((c + 0.055) / 1.055) ^ 2.4
end

local function luminance(hex)
  local r = srgb_to_linear(tonumber(hex:sub(2, 3), 16))
  local g = srgb_to_linear(tonumber(hex:sub(4, 5), 16))
  local b = srgb_to_linear(tonumber(hex:sub(6, 7), 16))
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

function M.contrast(fg, bg)
  local l1, l2 = luminance(fg), luminance(bg)
  if l2 > l1 then
    l1, l2 = l2, l1
  end
  return (l1 + 0.05) / (l2 + 0.05)
end

-- Every fg/bg pair where themed text or UI is actually rendered.
-- Overlay highlights (Visual, Search, IncSearch, PmenuSel) replace fg, so the
-- pairs there are the overlay's own fg on its tint — syntax fg never mixes in.
function M.situations()
  return {
    -- Code text on the main background
    { "Normal text on bg", p.fg, p.bg, "body" },
    { "keyword (magenta) on bg", p.magenta, p.bg, "body" },
    { "function (blue) on bg", p.blue, p.bg, "body" },
    { "string (green) on bg", p.green, p.bg, "body" },
    { "constant (yellow) on bg", p.yellow, p.bg, "body" },
    { "type (cyan) on bg", p.cyan, p.bg, "body" },
    { "variable/punct (muted) on bg", p.muted, p.bg, "body" },
    { "comment on bg", p.comment, p.bg, "secondary" },

    -- Diagnostics and messages (red text uses bright_red)
    { "DiagnosticError on bg", p.bright_red, p.bg, "body" },
    { "DiagnosticWarn on bg", p.yellow, p.bg, "body" },
    { "DiagnosticInfo on bg", p.blue, p.bg, "body" },
    { "DiagnosticHint on bg", p.cyan, p.bg, "body" },
    { "ErrorMsg on bg", p.bright_red, p.bg, "body" },
    { "Error syntax on bg", p.bright_red, p.bg, "body" },

    -- Diagnostic virtual text: deliberately WCAG-exempt (supplementary),
    -- kept soft so it does not compete with code
    { "virtual text error (soft) on bg", p.soft.red, p.bg, "exempt" },
    { "virtual text warn (soft) on bg", p.soft.yellow, p.bg, "exempt" },
    { "virtual text info (soft) on bg", p.soft.blue, p.bg, "exempt" },
    { "virtual text hint (soft) on bg", p.soft.cyan, p.bg, "exempt" },

    -- Text over derived backgrounds (bg-only contexts: syntax fg shows through)
    { "Normal text on cursorline", p.fg, p.cursorline, "body" },
    { "comment on cursorline", p.comment, p.cursorline, "secondary" },
    { "keyword on cursorline", p.magenta, p.cursorline, "body" },

    -- Overlays that replace fg
    { "Visual text on selection", p.selection_fg, p.selection, "body" },
    { "Search fg on Search bg", p.fg, p.search, "body" },
    { "IncSearch fg on IncSearch bg", p.fg, p.incsearch, "body" },
    { "MatchParen fg on match bg", p.fg, p.match, "body" },
    { "Todo chip on blue", p.bg, p.blue, "body" },
    { "Pmenu text on Pmenu bg", p.fg, p.float, "body" },
    { "PmenuSel text on selection", p.fg, p.selection, "body" },
    { "StatusLine text on StatusLine bg", p.fg, p.statusline, "body" },

    -- Diff: syntax text rendered on diff-tinted backgrounds
    { "string on DiffAdd bg", p.green, p.diff_add, "body" },
    { "constant on DiffChange bg", p.yellow, p.diff_change, "body" },
    { "error on DiffDelete bg", p.bright_red, p.diff_delete, "body" },
    { "string on DiffText bg", p.green, p.diff_text, "body" },
    { "Normal text on DiffText bg", p.fg, p.diff_text, "body" },

    -- Secondary / incidental text
    { "Folded (comment) on Folded bg", p.comment, p.cursorline, "secondary" },
    { "StatusLineNC on bg", p.comment, p.bg, "secondary" },
    { "TabLine (comment) on bg", p.comment, p.bg, "secondary" },
    { "LineNr on bg", p.linenr, p.bg, "secondary" },
    { "CursorLineNr on cursorline", p.fg, p.cursorline, "body" },

    -- Non-text UI (WCAG 1.4.11)
    { "FloatBorder on float bg", p.border, p.float, "ui" },
    { "WinSeparator on bg", p.border, p.bg, "ui" },
    { "SpellBad undercurl sp vs bg", p.red, p.bg, "ui" },

    -- Purely decorative markers: exempt from WCAG, recorded for the record
    { "NonText on bg", p.nontext, p.bg, "exempt" },
  }
end

function M.results()
  local out = {}
  for _, s in ipairs(M.situations()) do
    local name, fg, bg, tier = s[1], s[2], s[3], s[4]
    local ratio = M.contrast(fg, bg)
    local target = M.TIER_TARGET[tier]
    out[#out + 1] = {
      name = name, fg = fg, bg = bg, tier = tier,
      ratio = ratio, target = target,
      pass = (target == nil) or ratio >= target,
    }
  end
  return out
end

function M.print_report()
  local n_fail = 0
  for _, r in ipairs(M.results()) do
    if not r.pass then
      n_fail = n_fail + 1
    end
    print(("%-42s %5.2f  (need %-4s for %-9s) %s  fg %s on %s"):format(
      r.name, r.ratio, tostring(r.target), r.tier,
      r.pass and (r.target == nil and "n/a " or "PASS") or "FAIL", r.fg, r.bg))
  end
  print(("---\n%d situations, %d fail their tier"):format(#M.results(), n_fail))
  return n_fail
end

if arg and arg[0] and arg[0]:match("wcag%.lua$") then
  M.print_report()
end

return M
