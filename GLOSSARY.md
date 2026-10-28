# Friedrich

A dark Neovim colorscheme built from a fixed 16-color terminal palette. This glossary pins the vocabulary used when discussing its colors, layers, and style.

## Palette

**Palette anchor**: One of the fixed hex values in `assets/friedrich` — 16 ANSI slots plus background, foreground, cursor, and selection. The single source of truth; anchors are never tuned in place.
_Avoid_: base palette, brand color

**Derived shade**: A lighter or darker variant computed from a palette anchor, used where the anchors alone don't provide enough steps (UI chrome, deep backgrounds).

## Highlighting

**Syntax role**: The semantic class a token belongs to — keyword, function, string, constant, type. Hues are assigned per syntax role, not per individual highlight group.
_Avoid_: token type, scope

**Reserved hue**: A palette anchor excluded from syntax roles, usable only in semantic scenes.

**Semantic scene**: A highlighting context outside syntax where hue carries fixed meaning — diagnostics, diff, git.

**Highlight surface**: A consumer of highlight groups: core UI + syntax, Treesitter, LSP/diagnostics, plugins, or the embedded terminal.

**UI chrome**: Non-code editor furniture — statusline, line numbers, separators, float borders — styled to recede rather than pop.
_Avoid_: interface elements

## Style

**Minimal**: The project's style doctrine: a restricted hue set, muted saturation, no text decoration on syntax (no bold, italic, or underline), and UI chrome that recedes. Functional indicators (diagnostic and spelling undercurl) are exempt from the decoration ban.
_Avoid_: clean, simple, flat

## Accessibility

**WCAG tiers (body / secondary / ui / exempt)**: The conformance grade applied to each rendered color pair — body text ≥ 4.5:1, secondary text ≥ 3:1 (comments, line numbers), non-text UI ≥ 3:1, and exempt for purely decorative markers and diagnostic virtual text.
