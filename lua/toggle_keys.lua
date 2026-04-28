M = { }

M.coding = true

M.toggle_keys = function()
  M.coding = not M.coding
end

M.initKeyMaps = function()
  vim.keymap.set('i', 'ö', function()
    return require('toggle_keys').coding and '[' or 'ö'
  end, { expr = true, desc = 'coding "["' })

  vim.keymap.set('i', 'Ö', function()
    return require('toggle_keys').coding and '{' or 'Ö'
  end, { expr = true, desc = 'coding "{"' })

  vim.keymap.set('i', 'ä', function()
    return require('toggle_keys').coding and ']' or 'ä'
  end, { expr = true, desc = 'coding "]"' })

  vim.keymap.set('i', 'Ä', function()
    return require('toggle_keys').coding and '}' or 'Ä'
  end, { expr = true, desc = 'coding "}"' })

  vim.keymap.set('n', 'ö', function()
    vim.api.nvim_feedkeys(']', 'i', false)
  end, { expr = true, desc = '"]"' })

  vim.keymap.set('n', 'ä', function()
    vim.api.nvim_feedkeys('[', 'i', false)
  end, { expr = true, desc = '"]"' })

  vim.keymap.set('n', '<leader>t', function()
    require('toggle_keys').toggle_keys()
  end, { desc = 'toggle between coding and german writing keys' })
end

return M
