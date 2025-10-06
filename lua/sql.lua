M = {
  outpath = vim.fn.expand '~/db/out.txt',

  databases = {
    [vim.fn.expand '~/db/oracle.sql'] = 'oracle://kbase:kbase@localhost:1621/BUSTER',
    [vim.fn.expand '~/db/postgres.sql'] = 'usql postgres://kbase:kbase@localhost:2345/postgres',
    [vim.fn.expand '~/db/postgres_test.sql'] = 'postgres://postgres@localhost:5432/dvdrental',
    [vim.fn.expand '~/db/oracle-docker.sql'] = 'oracle://kbase:kbase@172.23.34.4:1521/BUSTER',
    [vim.fn.expand '~/db/postgres-2346.sql'] = 'postgres://kbase:kbase@localhost:2346/postgres',
    [vim.fn.expand '~/db/postgres-docker-172.sql'] = 'postgres://kbase:kbase@172.23.17.4:5432/postgres',
  },

  exec_sql = function()
    -- local start = vim.uv.hrtime()
    local cmd = ''
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    local linepos = vim.api.nvim_win_get_cursor(0)[1]

    -- take hole prev lines without ';'
    for i = linepos - 1, 1, -1 do
      local pos = string.find(lines[i], ';')
      if pos ~= nil then
        break
      end
      cmd = lines[i] .. cmd
    end

    -- take hole lines  - last is with ';'
    for i = linepos, #lines do
      local pos = string.find(lines[i], ';')
      cmd = cmd .. lines[i]
      if pos ~= nil then
        break
      end
    end

    local bufName = vim.api.nvim_buf_get_name(0)
    local uri = M.databases[bufName]
    if not uri then
      vim.notify(string.format('No database uri for file %s found!', bufName), vim.log.levels.ERROR)
      return
    end

    local res = vim.system({ 'usql', uri, '-o', M.outpath, '-c', cmd }):wait()

    if not res then
      vim.notify('vim.system returned no result', vim.log.levels.ERROR)
      return
    end
    if res.code ~= 0 or (res.stderr and res.stderr ~= '') then
      vim.notify(string.format('cmd "%s" failed with %d %s', cmd, res.code, res.stderr or ''), vim.log.levels.ERROR)
      return
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_name(buf) == M.outpath then
        vim.api.nvim_win_close(win, true)
      end
    end
    vim.cmd('split ' .. M.outpath)
    vim.wo.wrap = false
    --vim.notify(string.format('sql function time: %.1f ms', (vim.uv.hrtime() - start) / 1e6), vim.log.levels.info)
  end,
}
return M
