local M = {}

M.config = {
  terminal_colors = true,
}

local ALLOWED = { terminal_colors = true }

function M.setup(opts)
  opts = opts or {}
  for key, value in pairs(opts) do
    if not ALLOWED[key] then
      error(("friedrich: unknown option %q (transparent is intentionally unsupported)"):format(key))
    end
    if type(value) ~= "boolean" then
      error(("friedrich: option %q must be a boolean"):format(key))
    end
    M.config[key] = value
  end
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "friedrich"

  require("friedrich.highlights").apply(M.config)
end

return M
