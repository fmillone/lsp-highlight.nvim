local plugin = require 'lsp-highlight.plugin'
local default_config = require 'lsp-highlight.config'

local M = {}

function M.setup(opts)
  local keymaps = (opts or {}).keymaps or default_config.options.keymaps
  local highlight = keymaps.highlight or default_config.options.keymaps.highlight
  vim.keymap.set(highlight[1], highlight[2], plugin.highlight_variable, { desc = 'Highlight variable' })

  local clear_all = keymaps.clear_all or default_config.options.keymaps.clear_all
  vim.keymap.set(clear_all[1], clear_all[2], plugin.clear_all_references, { desc = 'Clear all highlights' })
end

return M
