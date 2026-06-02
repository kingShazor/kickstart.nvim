M = {}

M.check_cpp = function()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  local lines = {}
  vim.system({ 'opencode', 'run', '"/code-review-cpp-vim mach ein code review"', '-m', 'siemens/qwen-3.6-27b' }, {
    text = true,

    stdout = function(_, data)
      if data then
        table.insert(lines, data)

        -- Buffer sicher aktualisieren
        vim.schedule(function()
          local split = vim.split(table.concat(lines), '\n', { plain = true })
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, split)
        end)
      end
    end,

    stderr = function(_, data)
      if data then
        vim.schedule(function()
          local split = vim.split(data, '\n', { plain = true })
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, split)
        end)
      end
    end,
  })

  local send_to_quickfix = function()
    local dict = {}
    local currentLines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i = #currentLines, 1, -1 do
      local line = currentLines[i]
      if line:match '(nvim)' then
        break
      end
      local file, lineStr, columnStr, desc = line:match '([^:]+):(%d+):(%d+):([^:]+)'
      if file then
        table.insert(dict, {
          filename = file,
          lnum = tonumber(lineStr),
          col = tonumber(columnStr),
          text = desc,
        })
      end
    end
    vim.fn.setqflist(dict)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, false)
    end
    local old_win = vim.api.nvim_get_current_win()
    vim.cmd('vsplit')
    local new_win = vim.api.nvim_get_current_win()
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_win_set_buf(new_win,buf)
    end
    if #vim.fn.getqflist() > 0 then
      vim.cmd 'copen'
    end
    if vim.api.nvim_win_is_valid(old_win) then
      vim.api.nvim_set_current_win(old_win)
    end
  end

  vim.keymap.set({ 'n', 'i' }, '<C-q>', send_to_quickfix, { buffer = buf, desc = 'fill quick fix list with found file name' })
end

return M
