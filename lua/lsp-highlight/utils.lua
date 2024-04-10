local M = {}

function M.encoding(client)
  if client == nil then
    client = 1
  end

  if type(client) == 'number' then
    client = vim.lsp.get_client_by_id(client) or {}
  end
  local oe = client.offset_encoding
  if oe == nil then
    return 'utf-8'
  end
  if type(oe) == 'table' then
    return oe[1]
  end
  return oe
end

return M
