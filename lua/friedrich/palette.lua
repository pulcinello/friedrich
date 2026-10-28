-- Palette anchors are the exact values from assets/friedrich. Never tune them
-- in place. Everything outside the `anchors` table is a derived shade computed
-- from anchors — see GLOSSARY.md ("palette anchor", "derived shade").

local anchors = {
  bg = "#333344",
  fg = "#ffeeee",

  black = "#2a2a38",
  red = "#c97a7e",
  green = "#8fb08a",
  yellow = "#d0b483",
  blue = "#aabbdd",
  magenta = "#b493b8",
  cyan = "#8fb3b3",
  white = "#c9c9d1",

  bright_black = "#55556a",
  bright_red = "#d98f92",
  bright_green = "#a3c49d",
  bright_yellow = "#e0c79a",
  bright_blue = "#c3cee6",
  bright_magenta = "#c9a9cd",
  bright_cyan = "#a3c7c7",
  bright_white = "#ffeeee",

  cursor = "#aabbdd",
  cursor_text = "#333344",
  selection = "#4a4a60",
  selection_fg = "#ffeeee",
}

local function to_rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function to_hex(r, g, b)
  return string.format("#%02x%02x%02x", math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
end

--- Mix `fg` over `bg`: alpha 0 gives bg, 1 gives fg.
local function blend(fg, bg, alpha)
  local fr, fgn, fb = to_rgb(fg)
  local br, bg_, bb = to_rgb(bg)
  return to_hex(fr * alpha + br * (1 - alpha), fgn * alpha + bg_ * (1 - alpha), fb * alpha + bb * (1 - alpha))
end

local M = anchors

-- Foreground grays
M.comment = blend(anchors.fg, anchors.bg, 0.40) -- fog gray for comments (secondary tier)
M.muted = blend(anchors.fg, anchors.bg, 0.78) -- slightly dimmed fg: variables, punctuation
M.nontext = blend(anchors.fg, anchors.bg, 0.16) -- decorative markers (WCAG-exempt)
M.linenr = blend(anchors.fg, anchors.bg, 0.40) -- informational chrome: 3:1 floor

-- UI chrome. Derived backgrounds stay *darker* than bg so mid-luminance
-- syntax colors keep their contrast wherever they are rendered (WCAG).
-- Chrome grays hold the 3:1 non-text floor and not much more.
M.cursorline = blend(anchors.black, anchors.bg, 0.55)
M.statusline = blend(anchors.fg, anchors.bg, 0.09)
M.float = blend(anchors.black, anchors.bg, 0.45)
M.border = blend(anchors.fg, anchors.bg, 0.40)

-- Transient highlights: overlays that replace fg (their text pairs are
-- fg-on-tint in the WCAG audit)
M.search = blend(anchors.yellow, anchors.bg, 0.30)
M.incsearch = blend(anchors.blue, anchors.bg, 0.35)
M.match = blend(anchors.blue, anchors.bg, 0.22)

-- Diff backgrounds: hue tints mixed toward black (darker than bg), so the
-- syntax colors rendered on them stay >= 4.5:1
M.diff_add = blend(anchors.green, anchors.black, 0.08)
M.diff_change = blend(anchors.yellow, anchors.black, 0.08)
M.diff_delete = blend(anchors.red, anchors.black, 0.08)
M.diff_text = blend(anchors.yellow, anchors.black, 0.12)

-- Muted semantic hues for diagnostic virtual text: deliberately WCAG-exempt,
-- kept soft so they don't compete with code
M.soft = {
  red = blend(anchors.red, anchors.bg, 0.62),
  green = blend(anchors.green, anchors.bg, 0.62),
  yellow = blend(anchors.yellow, anchors.bg, 0.62),
  blue = blend(anchors.blue, anchors.bg, 0.62),
  cyan = blend(anchors.cyan, anchors.bg, 0.62),
}

M.blend = blend

return M
