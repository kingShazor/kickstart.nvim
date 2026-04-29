local M = { coding = true }

M.toggle_keys = function()
  M.coding = not M.coding
  vim.print(M.coding)
end

M.initKeyMaps = function()
  vim.keymap.set({ 'i' }, 'ö', function()
    return vim.keycode(M.coding and '[' or 'ö')
  end, { expr = true, desc = 'coding "["' })

  vim.keymap.set({ 'n' }, 'ö', function()
    return M.coding and '[' or 'ö'
  end, { expr = true, remap = true, desc = 'coding "["' })

  vim.keymap.set({ 'n' }, 'öö', function()
    return M.coding and '[[' or 'öö'
  end, { expr = true, desc = 'coding "[["' })

  vim.keymap.set({ 'n' }, 'öä', function()
    return M.coding and '[]' or 'öä'
  end, { expr = true, desc = 'coding "[]"' })

  vim.keymap.set({ 'n' }, 'ää', function()
    return M.coding and ']]' or 'ää'
  end, { expr = true, desc = 'coding "]]"' })

  vim.keymap.set({ 'n' }, 'äö', function()
    return M.coding and '][' or 'äö'
  end, { expr = true, desc = 'coding "]["' })

  vim.keymap.set({ 'i', 'n', 'c' }, 'Ö', function()
    return M.coding and '{' or 'Ö'
  end, { expr = true, desc = 'coding "{"' })

  vim.keymap.set({ 'n' }, 'ä', function()
    return M.coding and ']' or 'ä'
  end, { expr = true, remap = true, desc = 'coding "]"' })

  vim.keymap.set({ 'i' }, 'ä', function()
    return vim.keycode(M.coding and ']' or 'ä')
  end, { expr = true, desc = 'coding "]"' })

  vim.keymap.set({ 'i', 'n', 'c' }, 'Ä', function()
    return vim.keycode(M.coding and '}' or 'Ä')
  end, { expr = true, desc = 'coding "}"' })

  vim.keymap.set('n', '<leader>t', M.toggle_keys, { desc = 'toggle between coding and german writing keys' })
end

return M
