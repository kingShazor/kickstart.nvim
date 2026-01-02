M = {}

M.isDebian = function()
  local f = io.open("/etc/os-release", "r")
  if not f then return false end

  local content = f:read("*a")
  f:close()

  return content:match('ID_LIKE=.*debian')
      or content:match('^ID=debian')
end

M.startTimer = function()
  local isDebian = M.isDebian();
  if not isDebian then
    -- vim.notify("Is no debian like distro", vim.log.levels.INFO)
    return
  end

  local timer = nil
  local reportTimer = nil
  local checkInterval = 3600000
  local reportTime = 1200000
  local reportMode = false
  local updateFound = 0

  local function checkUpdates()
  local handle = io.popen 'apt list --upgradable 2>/dev/null | grep jammy | wc -l'
    if handle then
      local result = handle:read '*a'
      handle:close()
      updateFound = tonumber(result) or 0
    end
  end

  local function notifyTimes()
    vim.notify(('%d security updates found'):format(updateFound))
  end

  local function checkTimes()
    checkUpdates()
    if updateFound > 0 and not reportMode then
      reportMode = true
      if timer and timer.stop then
        timer:stop()
      end
      if timer and timer.close then
        timer:close()
      end
      reportTimer = vim.uv.new_timer()
      reportTimer:start(100, reportTime, vim.schedule_wrap(notifyTimes))
    end
  end

  timer = vim.uv.new_timer()
  timer:start(5000, checkInterval, vim.schedule_wrap(checkTimes))
end

return M
