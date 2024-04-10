local vim_lsp_utils = require 'lsp-highlight.lsp-utils'
local utils = require 'lsp-highlight.utils'

local M = {}

local handle_document_highlight = function(_, result, ctx)
  if not ctx.bufnr then
    vim.notify('document highlight error ' .. vim.inspect(result) .. ' -- ' .. vim.inspect(ctx))
    return
  end
  -- TODO: make a namespace per variable?
  local reference_ns = vim.api.nvim_create_namespace 'fmillone_highlight_lsp_references'
  -- vim.notify(vim.inspect(result) .. ' -- ' .. vim.inspect(ctx))
  if type(result) ~= 'table' or vim.fn.empty(result) == 1 then
    M.buf_clear_references(ctx.bufnr, reference_ns)
    return
  end

  -- TODO: pass highlight group from config
  M.buf_highlight_references(ctx.bufnr, result, utils.encoding(ctx.client_id), reference_ns, 'Search')
end

function M.highlight_variable()
  local bufnr = vim.api.nvim_get_current_buf()

  local ref_params = vim.lsp.util.make_position_params()
  local clients = vim.lsp.get_active_clients { bufnr = bufnr }
  for _, client in pairs(clients) do
    if client.server_capabilities.documentHighlightProvider == true then
      -- vim.notify('sending doc highlight ' .. client.name .. ' ' .. bufnr)
      client.request('textDocument/documentHighlight', ref_params, handle_document_highlight, bufnr)
    end
  end
end

function M.clear_all_references()
  local bufnr = vim.api.nvim_get_current_buf()

  -- TODO: make a namespace per variable?
  local reference_ns = vim.api.nvim_create_namespace 'fmillone_highlight_lsp_references'

  M.buf_clear_references(bufnr, reference_ns)
end

--- Removes document highlights from a buffer.
---
---@param bufnr integer Buffer id
---@param reference_ns number from `vim.api.nvim_create_namespace`
function M.buf_clear_references(bufnr, reference_ns)
  vim.validate { bufnr = { bufnr, 'n', true } }
  vim.api.nvim_buf_clear_namespace(bufnr or 0, reference_ns, 0, -1)
end

--- Shows a list of document highlights for a certain buffer.
---
---@param bufnr integer Buffer id
---@param references table List of `DocumentHighlight` objects to highlight
---@param offset_encoding string One of "utf-8", "utf-16", "utf-32".
---@param reference_ns number from `vim.api.nvim_create_namespace`
---@param highlight_group string The highlight group to use
---@see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocumentContentChangeEvent
function M.buf_highlight_references(bufnr, references, offset_encoding, reference_ns, highlight_group)
  vim.validate {
    bufnr = { bufnr, 'n', true },
    offset_encoding = { offset_encoding, 'string', false },
  }
  for _, reference in ipairs(references) do
    local start_line, start_char = reference['range']['start']['line'], reference['range']['start']['character']
    local end_line, end_char = reference['range']['end']['line'], reference['range']['end']['character']

    local start_idx = vim_lsp_utils.get_line_byte_from_position(bufnr, { line = start_line, character = start_char }, offset_encoding)
    local end_idx = vim_lsp_utils.get_line_byte_from_position(bufnr, { line = start_line, character = end_char }, offset_encoding)

      -- stylua: ignore start
      vim.highlight.range(
        bufnr,
        reference_ns,
        highlight_group,
        { start_line, start_idx },
        { end_line, end_idx },
        { priority = vim.highlight.priorities.user }
      )
  end
end

return M
