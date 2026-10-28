-- Highlight definitions. Every hue here is a palette anchor (see
-- palette.lua); every non-anchor color is a derived shade. Style doctrine
-- (GLOSSARY.md "minimal"): restricted hue set, muted saturation, no text
-- decoration on syntax, UI chrome that recedes. Red is a reserved hue —
-- semantic scenes only, never syntax.

local M = {}

function M.apply(config)
  local p = require("friedrich.palette")

  local function set(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end
  local function link(name, target)
    vim.api.nvim_set_hl(0, name, { link = target })
  end

  ----------------------------------------------------------------
  -- Editor UI
  ----------------------------------------------------------------
  set("Normal", { fg = p.fg, bg = p.bg })
  link("NormalNC", "Normal")
  set("NormalFloat", { fg = p.fg, bg = p.float })
  set("FloatBorder", { fg = p.border, bg = p.float })
  set("FloatTitle", { fg = p.blue, bg = p.float })

  set("Cursor", { fg = p.cursor_text, bg = p.cursor })
  link("lCursor", "Cursor")
  link("CursorIM", "Cursor")
  link("TermCursor", "Cursor")

  set("CursorLine", { bg = p.cursorline })
  link("CursorColumn", "CursorLine")
  link("ColorColumn", "CursorLine")
  set("CursorLineNr", { fg = p.fg })
  set("LineNr", { fg = p.linenr })
  link("LineNrAbove", "LineNr")
  link("LineNrBelow", "LineNr")
  set("SignColumn", { bg = p.bg })
  set("FoldColumn", { fg = p.linenr, bg = p.bg })
  set("Folded", { fg = p.comment, bg = p.cursorline })

  set("Visual", { fg = p.selection_fg, bg = p.selection })
  link("VisualNOS", "Visual")

  set("Search", { bg = p.search })
  set("IncSearch", { bg = p.incsearch })
  link("CurSearch", "IncSearch")
  link("Substitute", "IncSearch")
  set("MatchParen", { fg = p.fg, bg = p.match })

  set("Conceal", { fg = p.comment })
  set("NonText", { fg = p.nontext })
  link("SpecialKey", "NonText")
  link("EndOfBuffer", "NonText")
  set("Whitespace", { fg = p.nontext })

  set("Directory", { fg = p.blue })
  set("Title", { fg = p.blue })
  set("Question", { fg = p.blue })
  set("MoreMsg", { fg = p.green })
  set("ModeMsg", { fg = p.fg })
  set("ErrorMsg", { fg = p.bright_red })
  set("WarningMsg", { fg = p.yellow })

  set("Pmenu", { fg = p.fg, bg = p.float })
  set("PmenuSel", { fg = p.fg, bg = p.selection })
  set("PmenuSbar", { bg = p.cursorline })
  set("PmenuThumb", { bg = p.selection })
  link("WildMenu", "PmenuSel")

  set("StatusLine", { fg = p.fg, bg = p.statusline })
  set("StatusLineNC", { fg = p.comment, bg = p.bg })
  set("TabLine", { fg = p.comment, bg = p.bg })
  set("TabLineFill", { bg = p.bg })
  set("TabLineSel", { fg = p.fg, bg = p.statusline })

  set("WinSeparator", { fg = p.border })
  link("VertSplit", "WinSeparator")

  set("QuickFixLine", { bg = p.cursorline })

  ----------------------------------------------------------------
  -- Syntax: hues assigned per syntax role (GLOSSARY.md "syntax role")
  ----------------------------------------------------------------
  set("Comment", { fg = p.comment })

  set("Constant", { fg = p.yellow })
  set("String", { fg = p.green })
  link("Character", "String")
  link("Number", "Constant")
  link("Boolean", "Constant")
  link("Float", "Constant")

  set("Identifier", { fg = p.muted })
  set("Function", { fg = p.blue })

  set("Statement", { fg = p.magenta })
  link("Conditional", "Statement")
  link("Repeat", "Statement")
  link("Label", "Statement")
  link("Keyword", "Statement")
  link("Exception", "Statement")
  set("Operator", { fg = p.muted })

  set("PreProc", { fg = p.cyan })
  link("Include", "PreProc")
  link("Define", "PreProc")
  link("Macro", "PreProc")
  link("PreCondit", "PreProc")

  set("Type", { fg = p.cyan })
  link("StorageClass", "Type")
  link("Structure", "Type")
  link("Typedef", "Type")

  set("Special", { fg = p.muted })
  set("SpecialChar", { fg = p.yellow })
  link("Tag", "Type")
  set("Delimiter", { fg = p.muted })
  link("SpecialComment", "Comment")
  set("Debug", { fg = p.yellow })

  -- No decoration anywhere: these groups lose their traditional attributes.
  set("Bold", {})
  set("Italic", {})
  set("Underlined", { fg = p.blue })
  set("Ignore", { fg = p.nontext })
  -- The red anchor is the lowest-luminance hue; its *text* uses take
  -- bright_red to clear WCAG AA (4.5:1). Non-text uses (undercurl sp, signs)
  -- keep the anchor.
  set("Error", { fg = p.bright_red })
  set("Todo", { fg = p.bg, bg = p.blue })

  ----------------------------------------------------------------
  -- Semantic scenes (diagnostics, diff, git, spelling)
  ----------------------------------------------------------------
  set("DiagnosticError", { fg = p.bright_red })
  set("DiagnosticWarn", { fg = p.yellow })
  set("DiagnosticInfo", { fg = p.blue })
  set("DiagnosticHint", { fg = p.cyan })
  set("DiagnosticOk", { fg = p.green })

  -- Undercurl is the single functional exemption from the decoration ban.
  set("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
  set("DiagnosticUnderlineWarn", { undercurl = true, sp = p.yellow })
  set("DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue })
  set("DiagnosticUnderlineHint", { undercurl = true, sp = p.cyan })
  set("DiagnosticUnderlineOk", { undercurl = true, sp = p.green })

  -- Virtual text is supplementary and deliberately WCAG-exempt: soft hues that
  -- don't compete with code.
  set("DiagnosticVirtualTextError", { fg = p.soft.red })
  set("DiagnosticVirtualTextWarn", { fg = p.soft.yellow })
  set("DiagnosticVirtualTextInfo", { fg = p.soft.blue })
  set("DiagnosticVirtualTextHint", { fg = p.soft.cyan })
  set("DiagnosticVirtualTextOk", { fg = p.soft.green })

  set("DiagnosticDeprecated", { fg = p.comment })
  set("DiagnosticUnnecessary", { fg = p.comment })

  set("DiffAdd", { bg = p.diff_add })
  set("DiffChange", { bg = p.diff_change })
  set("DiffDelete", { bg = p.diff_delete })
  set("DiffText", { bg = p.diff_text })

  set("SpellBad", { undercurl = true, sp = p.red })
  set("SpellCap", { undercurl = true, sp = p.blue })
  set("SpellRare", { undercurl = true, sp = p.magenta })
  set("SpellLocal", { undercurl = true, sp = p.cyan })

  ----------------------------------------------------------------
  -- Treesitter
  ----------------------------------------------------------------
  link("@comment", "Comment")
  link("@comment.documentation", "Comment")
  set("@comment.error", { fg = p.bright_red })
  set("@comment.warning", { fg = p.yellow })
  set("@comment.note", { fg = p.blue })
  link("@comment.todo", "Todo")

  link("@constant", "Constant")
  link("@constant.builtin", "Constant")
  link("@constant.macro", "PreProc")
  link("@string", "String")
  link("@string.escape", "SpecialChar")
  set("@string.regexp", { fg = p.yellow })
  link("@string.special", "Special")
  link("@character", "String")
  link("@number", "Number")
  link("@boolean", "Boolean")

  set("@variable", { fg = p.muted })
  set("@variable.builtin", { fg = p.muted })
  set("@variable.parameter", { fg = p.muted })
  set("@variable.parameter.builtin", { fg = p.muted })
  set("@variable.member", { fg = p.muted })

  link("@function", "Function")
  link("@function.builtin", "Function")
  link("@function.call", "Function")
  link("@function.method", "Function")
  link("@function.method.call", "Function")
  link("@function.macro", "PreProc")
  link("@constructor", "Type")

  link("@type", "Type")
  link("@type.builtin", "Type")
  link("@type.definition", "Type")
  link("@type.qualifier", "Type")
  link("@attribute", "PreProc")
  link("@attribute.builtin", "PreProc")
  set("@property", { fg = p.muted })

  set("@label", { fg = p.magenta })
  set("@punctuation.delimiter", { fg = p.muted })
  set("@punctuation.bracket", { fg = p.muted })
  set("@punctuation.special", { fg = p.muted })
  link("@operator", "Operator")

  link("@keyword", "Statement")
  link("@keyword.function", "Statement")
  link("@keyword.operator", "Statement")
  link("@keyword.import", "Statement")
  link("@keyword.export", "Statement")
  link("@keyword.coroutine", "Statement")
  link("@keyword.type", "Statement")
  link("@keyword.modifier", "Statement")
  link("@keyword.repeat", "Conditional")
  link("@keyword.return", "Statement")
  link("@keyword.exception", "Statement")
  link("@keyword.conditional", "Conditional")
  link("@keyword.debug", "Statement")
  link("@exception", "Statement")
  link("@conditional", "Conditional")
  link("@repeat", "Conditional")

  link("@module", "Identifier")
  link("@namespace", "Identifier")
  link("@symbol", "Identifier")
  link("@include", "Statement")

  link("@tag", "Type")
  link("@tag.attribute", "PreProc")
  set("@tag.delimiter", { fg = p.muted })

  ----------------------------------------------------------------
  -- Markup (markdown etc.): decoration ban applies to rendered text too
  ----------------------------------------------------------------
  link("@markup.heading", "Title")
  link("@markup.link", "Title")
  set("@markup.link.label", { fg = p.blue })
  set("@markup.link.url", { fg = p.comment })
  link("@markup.quote", "Comment")
  link("@markup.raw", "String")
  set("@markup.list", { fg = p.muted })
  set("@markup.strong", { fg = p.fg })
  set("@markup.italic", { fg = p.fg })
  set("@markup.strikethrough", { fg = p.fg })
  set("@markup.underline", { fg = p.fg })

  ----------------------------------------------------------------
  -- Diff captures
  ----------------------------------------------------------------
  set("@diff.plus", { fg = p.green })
  set("@diff.minus", { fg = p.bright_red })
  set("@diff.delta", { fg = p.yellow })

  ----------------------------------------------------------------
  -- LSP semantic tokens: routed back to the same syntax roles
  ----------------------------------------------------------------
  link("@lsp.type.class", "Type")
  link("@lsp.type.comment", "Comment")
  link("@lsp.type.decorator", "PreProc")
  link("@lsp.type.enum", "Type")
  link("@lsp.type.enumMember", "Constant")
  link("@lsp.type.function", "Function")
  link("@lsp.type.interface", "Type")
  link("@lsp.type.keyword", "Statement")
  link("@lsp.type.macro", "PreProc")
  link("@lsp.type.method", "Function")
  link("@lsp.type.namespace", "Identifier")
  link("@lsp.type.number", "Number")
  link("@lsp.type.operator", "Operator")
  link("@lsp.type.parameter", "Identifier")
  link("@lsp.type.property", "Identifier")
  link("@lsp.type.string", "String")
  link("@lsp.type.struct", "Type")
  link("@lsp.type.type", "Type")
  link("@lsp.type.typeParameter", "Type")
  link("@lsp.type.variable", "Identifier")
  link("@lsp.type.builtinType", "Type")
  link("@lsp.type.selfKeyword", "Identifier")

  set("@lsp.mod.deprecated", { fg = p.comment })
  set("@lsp.mod.unnecessary", { fg = p.comment })
  link("@lsp.typemod.variable.readonly", "Constant")

  -- LSP reference highlighting and lens: chrome, recede
  set("LspReferenceText", { bg = p.cursorline })
  set("LspReferenceRead", { bg = p.cursorline })
  set("LspReferenceWrite", { bg = p.cursorline })
  set("LspCodeLens", { fg = p.comment })
  set("LspSignatureActiveParameter", { bg = p.match })
  link("LspInfoBorder", "FloatBorder")

  ----------------------------------------------------------------
  -- Terminal palette: exact asset values (anchors), never derived
  ----------------------------------------------------------------
  if config.terminal_colors then
    local slots = {
      p.black, p.red, p.green, p.yellow, p.blue, p.magenta, p.cyan, p.white,
      p.bright_black, p.bright_red, p.bright_green, p.bright_yellow,
      p.bright_blue, p.bright_magenta, p.bright_cyan, p.bright_white,
    }
    for i, color in ipairs(slots) do
      vim.g["terminal_color_" .. (i - 1)] = color
    end
    vim.g.terminal_color_foreground = p.fg
    vim.g.terminal_color_background = p.bg
    vim.g.terminal_color_cursor = p.cursor
  end

  ----------------------------------------------------------------
  -- Global decoration ban: neutralize any decoration still carried by
  -- default groups. Functional undercurl is the only exemption.
  ----------------------------------------------------------------
  local functional_undercurl = {
    SpellBad = true, SpellCap = true, SpellRare = true, SpellLocal = true,
    DiagnosticUnderlineError = true, DiagnosticUnderlineWarn = true,
    DiagnosticUnderlineInfo = true, DiagnosticUnderlineHint = true,
    DiagnosticUnderlineOk = true,
  }
  for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    if not hl.link then
      local changed = false
      for _, attr in ipairs({ "bold", "italic", "underline", "strikethrough" }) do
        if hl[attr] then
          hl[attr] = nil
          changed = true
        end
      end
      if hl.undercurl and not functional_undercurl[name] then
        hl.undercurl = nil
        changed = true
      end
      if changed then
        vim.api.nvim_set_hl(0, name, hl)
      end
    end
  end
end

return M
