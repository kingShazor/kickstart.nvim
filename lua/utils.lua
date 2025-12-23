local startJumpPos = nil

M = {}
M.call_hierarchy = function(method, param)
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local encoding = clients[1].offset_encoding or 'utf-8'

  --  local param = {
  --    textDocument = vim.lsp.util.make_text_document_params(),
  --    position = { line = vim.api.nvim_win_get_cursor(0)[1] - 1, character = vim.api.nvim_win_get_cursor(0)[2] },
  --  }
  vim.lsp.buf_request(0, 'textDocument/prepareCallHierarchy', param, function(err, result, ctx, _)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify('call_hierarchy: No call hierarchy found', vim.log.levels.info)
      return
    end

    local item = result[1]

    --vim.notify(string.format('call %s', method), vim.log.levels.info)
    vim.lsp.buf_request(ctx.bufnr, method, { item = item }, function(errStack, resultStack, _, _)
      if errStack or not resultStack then
        return
      end
      --vim.notify(vim.inspect(resultStack))
      for _, call in ipairs(resultStack) do
        local loc = call.from and call.from.range
        if loc then
          local nextItem = {
            uri = call.from.uri,
            range = call.fromRanges and call.fromRanges[1] or call.from.range,
            --            lnum = loc.start.line + 1,
            --            col = loc.start.character + 1,
            --            text = call.from.name,
          }
          --vim.notify(string.format('call_hierarchy: got item: %s', nextItem.uri), vim.log.levels.info)
          vim.lsp.util.show_document(nextItem, encoding, { focus = true })
          return
        end
      end
    end)
  end)
end

M.jump_to_function_name = function(savePos, jumpCall)
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local encoding = clients[1].offset_encoding or 'utf-8'

  local param = {
    textDocument = vim.lsp.util.make_text_document_params(),
    position = { line = vim.api.nvim_win_get_cursor(0)[1] - 1, character = vim.api.nvim_win_get_cursor(0)[2] },
  }

  vim.lsp.buf_request(0, 'textDocument/documentSymbol', param, function(err, result, _, _)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify('jump_to_function_name: No Symbols found', vim.log.levels.info)
      return
    end

    if savePos and not startJumpPos then
      local pos = vim.api.nvim_win_get_cursor(0)
      local point = { line = pos[1] - 1, character = pos[2] }
      local range = { start = point, ['end'] = point }
      startJumpPos = { uri = vim.uri_from_bufnr(0), range = range }
      --vim.notify(string.format('jump_to_function_name: set startJumpPos item: %s', startJumpPos.uri), vim.log.levels.info)
    end

    local function find_function(symbols)
      --vim.notify(string.format('symbols %d', #symbols), vim.log.levels.info)
      for _, symbol in ipairs(symbols) do
        if symbol.range then
          local range = symbol.range
          if param.position.line >= range.start.line and param.position.line <= range['end'].line then
            -- vim.notify(string.format('symbol in range: %s, type %d', symbol.name, symbol.kind), vim.log.levels.info)
            if symbol.kind == 12 or symbol.kind == 6 then
              return symbol
            end
            if symbol.children then
              local child = find_function(symbol.children)
              if child then
                return child
              end
            end
          end
          --vim.notify(string.format('symbol %s, type %d', symbol.name, symbol.kind), vim.log.levels.info)
        end
      end
    end

    local symbol = find_function(result)
    if symbol then
      --vim.notify(string.format('symbol found: %s, type %d', symbol.name, symbol.kind), vim.log.levels.info)
      local nextItem = {
        uri = param.textDocument.uri,
        range = symbol.selectionRange or symbol.range,
      }
      --vim.notify(string.format('jump_to_function_name got function: %s', nextItem.uri), vim.log.levels.info)
      vim.lsp.util.show_document(nextItem, encoding, { focus = true })
      if jumpCall then
        local incomingCallsParam = { textDocument = param.textDocument, position = nextItem.range.start }
        M.call_hierarchy('callHierarchy/incomingCalls', incomingCallsParam)
      end
    else
      vim.notify('jump_to_function_name: No function header found', vim.log.levels.info)
    end
  end)
end

M.jump_back = function()
  if not startJumpPos then
    vim.notify "Start Pos not set - you need to first jump backwards via 'gk'"
    return
  end
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local encoding = clients[1].offset_encoding or 'utf-8'
  vim.lsp.util.show_document(startJumpPos, encoding, { focus = true })
  startJumpPos = nil
  --vim.notify 'reset startJumpPos'
end

M.ClangdSwitchSourceHeader = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local method = 'textDocument/switchSourceHeader'
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
  if not client then
    return vim.notify(('Method %s not supported by active LSP client.'):format(method), vim.log.levels.ERROR)
  end

  local params = vim.lsp.util.make_text_document_params(bufnr)
  client.request(method, params, function(err, result)
    if err then
      vim.notify('Error switching source/header: ' .. err.message, vim.log.levels.ERROR)
      return
    end
    if not result then
      vim.notify 'No corresponding file found (source/header switch failed).'
      return
    end
    vim.cmd('edit ' .. vim.uri_to_fname(result))
  end, bufnr)
end

-- create a prompt field in the middle of the screen
M.openPrompt = function()
  local width = math.floor(vim.o.columns * 0.3)
  local rows = math.floor(vim.o.lines / 2.5)
  local columns = math.floor((vim.o.columns - width) / 2)

  local opt = {
    relative = 'editor',
    width = width,
    height = 1,
    title = ' Prompt ',
    title_pos = 'center',
    row = rows,
    col = columns,
    border = 'rounded',
    style = 'minimal',
  }

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opt)
  local hl = 'NormalFloat:Normal,FloatBorder:Function' --FloatBorder:BorderPicker'
  vim.wo[win].winhl = hl
  vim.bo[buf].buftype = 'prompt'
  vim.bo[buf].modifiable = true
  vim.fn.prompt_setprompt(buf, '> ')
  vim.api.nvim_set_current_win(win)
  vim.cmd.startinsert()
  vim.fn.prompt_setcallback(buf, function(_)
    local str = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
    local cmd = string.sub(str, 3)
    -- vim.notify(string.format('prompt "%s"', cmd), vim.log.levels.WARN)

    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end

    if cmd ~= '' then
      vim.fn.histadd("cmd", cmd)
      pcall(vim.cmd, cmd)
    end
  end)

  local index = 0
  local setField = function(text)
    vim.api.nvim_buf_set_lines(buf, -2, -1, false, { '> ' .. text })
    vim.api.nvim_win_set_cursor(0, { 1, #text +3 } )
  end

  vim.keymap.set({ 'i' }, '<Up>', function()
    local nextIndex = index -1
    local cmd = vim.fn.histget("cmd", nextIndex)
    if cmd and #cmd > 0 then
      setField(cmd)
      index = nextIndex
    end
  end, { buffer = buf, desc = 'go back in history' })

  vim.keymap.set({ 'i' }, '<Down>', function()
    local nextIndex = index +1
    if nextIndex == 0 then
      setField('')
      return
    end

    local cmd = vim.fn.histget("cmd", nextIndex)
    if cmd and #cmd > 0 then
      setField(cmd)
      index = nextIndex
    end
  end, { buffer = buf, desc = 'go back in history' })

  vim.keymap.set({ 'i' }, '<Tab>', function()
    local str = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
    local cmd = string.sub(str, 3)
    local items = vim.fn.getcompletion(cmd, 'cmdline')
    if #items > 0 then
      setField(items[1])
    end
  end, { buffer = buf, desc = 'Autocomplete [<Tab>]' })
end

return M
