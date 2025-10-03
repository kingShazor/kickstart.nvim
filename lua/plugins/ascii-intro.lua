M = {
  dir = '~/.config/nvim/lua/plugins',
  name = 'ascii-intro',
  lazy = false, -- direkt beim Start laden
  priority = 1000, -- früh laden
  createIntro = function()
    if #vim.api.nvim_list_bufs() ~= 1 or vim.api.nvim_buf_get_name(0) ~= '' then
      return
    end
    vim.opt.shortmess:append 'I'
    local version = vim.version()
    local nvim_version = string.format('NVIM v%d.%d.%d', version.major, version.minor, version.patch)
    local intro = {
      [[  ██████   █████                                  ███                  ]],
      [[ ░░██████ ░░███                                  ░░░                   ]],
      [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
      [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
      [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
      [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
      [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
      [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
      '',
      nvim_version,
      'Type  :help nvim<Enter>         to get started',
      'Type  :checkhealth<Enter>       to optimize your setup',
      'Type  :quit<Enter>              to exit',
      'Type  :help<Enter>              for help',
      'Type  :help news<Enter>         to see changes in this version',
      '',
    }
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, intro)

    vim.api.nvim_set_hl(0, 'IntroHighlight', { fg = '#ab8ae7', bold = true })
    vim.api.nvim_set_hl(0, 'IntroTextHighlight', { fg = '#bb9af7', bold = true })
    for i = 1, 8 do
      vim.api.nvim_buf_add_highlight(buf, -1, 'IntroHighlight', i - 1, 0, -1)
    end

    for i = 10, #intro - 1 do
      vim.api.nvim_buf_add_highlight(buf, -1, 'IntroTextHighlight', i - 1, 0, -1)
    end
    local width = math.floor(vim.o.columns * 0.4)
    local height = #intro
    local row = math.floor(vim.o.lines / 2 - height / 2)
    local col = math.floor(vim.o.columns / 2 - width / 2)

    local win = vim.api.nvim_open_win(buf, false, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
    })
    vim.wo[win].winhl = 'NormalFloat:Normal,FloatBorder:IntroHighlight'
    vim.api.nvim_create_autocmd({ 'InsertEnter', 'BufHidden' }, {
      once = true,
      callback = function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end,
    })
  end,
  config = function()
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = M.createIntro,
    })
  end,
}

return M
