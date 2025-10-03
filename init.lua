-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- vim-sleuth Ersatz
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- buildin completion
vim.o.completeopt = 'menu,menuone,noinsert,popup'
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = '[w]rite buffer' })
vim.keymap.set('n', '<leader>q', ':quit<CR>', { desc = '[q]uit nvim' })
vim.keymap.set('n', '<leader>R', ':update<CR> :source<CR>', { desc = 'Source files' })

-- Shift+C für Visual Block Mode
vim.keymap.set('n', '<v', '<c-v>', { desc = 'block mode' })
-- vim.key_map('v', '<S-c>', '<C-c>', { norema })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- method - string

vim.keymap.set('n', 'gj', function()
  require('utils').jump_back()
end, { desc = 'go back to jump start' })

vim.keymap.set('n', 'gk', function()
  require('utils').jump_to_function_name(true, true)
end, { desc = 'pick to first caller' })

vim.keymap.set('n', 'gö', function()
  require('utils').jump_to_function_name()
end, { desc = 'jump to function name' })

vim.keymap.set('n', 'gl', function()
  vim.lsp.buf.incoming_calls()
end, { desc = 'pick to first caller' })

-- next = boolean
local nextFunc = function(next)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local info = vim.fn.getwininfo(win)[1]
    if info.quickfix == 1 then
      if info.loclist == 1 then
        return next and 'lnext' or 'lprev'
      else
        return next and 'cnext' or 'cprev'
      end
    end
  end
  -- gibt eine Fehlermeldung
  --return vim.notify('Either a quickfix nor a locallist open!', vim.log.levels.ERROR)
  return 'echo "Neither a quickfix nor a locallist open!"'
end

local pNextFunc = function(cmd)
  local ok = pcall(function()
    vim.cmd(cmd)
  end)

  if not ok then
    vim.notify('Ende der List erreicht!', vim.log.levels.info)
  end
end

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<M-j>', function()
  pNextFunc(nextFunc(true))
end, { desc = 'jump to next local list entry' })
vim.keymap.set('n', '<M-k>', function()
  pNextFunc(nextFunc(false))
end, { desc = 'jump to prev local list entry' })

if not vim.g.vscode then
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
end
vim.diagnostic.config { virtual_text = true }

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
vim.api.nvim_create_autocmd('CmdlineEnter', {
  callback = function()
    require('notify').dismiss { silent = true, pending = true }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sql',
  callback = function()
    vim.keymap.set('n', '<CR>', function()
      require('sql').exec_sql()
    end, { desc = 'Exec SQL Command' })
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local compile_commands_dir = os.getenv 'CLANGD_COMPILE_COMMANDS_DIR' or os.getenv 'PWD'
local clangd_bin = vim.fn.executable 'clangd' == 1 and 'clangd' or 'clangd-15'
vim.lsp.config.clangd = {
  cmd = { clangd_bin, '--background-index', '--compile-commands-dir=' .. compile_commands_dir },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp', 'ixx' },
}

vim.lsp.config.luals = {
  -- Command and arguments to start the server.
  cmd = { 'lua-language-server' },
  -- Filetypes to automatically attach to.
  filetypes = { 'lua' },
  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".luarc.json" or a
  -- ".luarc.jsonc" file. Files that share a root directory will reuse
  -- the connection to the same LSP server.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Erlaubt globale `vim` Variable
        globals = { 'vim' },
      },
    },
  },
  workspace = {
    library = vim.api.nvim_get_runtime_file('', true),
  },
}
vim.lsp.enable { 'clangd', 'luals' }

vim.keymap.set({ 'n', 'i' }, '<c-space>', function()
  vim.lsp.completion.get()
end)
-- der linter des Grauens
-- vim.lsp.config.sqlls = {
--   cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
--   filetypes = { 'sql', 'psql', 'oraclesql' },
--   settings = {
--     sqlLanguageServer = {
--       diagnostics = {
--         enabled = false, -- Deaktiviert Diagnosemeldungen
--       },
--     },
--   },
-- }
--
-- vim.lsp.enable { 'sqlls' }
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method 'textDocument/completion' then
      vim.lsp.completion.enable(true, client.id, args.buf, { autorigger = true })
    end
    if client and client:supports_method 'textDocument/documentHighlight' then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = args.buf,
        callback = function()
          vim.schedule(function()
            vim.lsp.buf.document_highlight()
          end)
        end,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = args.buf,
        callback = function()
          vim.schedule(function()
            vim.lsp.buf.clear_references()
          end)
        end,
      })
    end
  end,
})
-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  { import = 'plugins' },
  {
    'FabijanZulj/blame.nvim',
    config = function()
      require('blame').setup()
    end,
  },
  {
    'mason-org/mason.nvim',
    opts = {
      ensure_installed = { 'lua-language-server' },
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      command_palette = true,
    },
  },
  {
    'zk-org/zk-nvim',
    config = function()
      require('zk').setup {
        -- See Setup section below
      }
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'VimEnter',
    cond = function()
      local filename = vim.fn.expand '~/.config/github-copilot/apps.json'
      return vim.fn.filereadable(filename) == 1
    end,
    init = function()
      -- Keymap immer setzen, auch wenn Plugin noch nicht geladen ist
      vim.keymap.set({ 'n', 'i' }, '<M-a>', function()
        require('copilot.suggestion').toggle_auto_trigger()
      end, { desc = 'Toggle Copilot Auto-Trigger' })
      vim.keymap.set({ 'v' }, '<M-+>', function()
        require('copilot.panel').open()
      end, { desc = 'Open Copilot Panel' })
    end,
    config = function()
      require('copilot').setup {
        panel = {
          keymap = {
            open = '<M-+>',
            jump_prev = 'ÖÖ',
            jump_next = 'öö',
          },
        },

        suggestion = {
          auto_trigger = false,
          keymap = {
            accept = '<C-l>',
            next = '<M-ö>',
            prev = '<M-ü>',
            dismiss = '<M-ä>',
          },
        },
      }
    end,
  },
  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      local wk = require 'which-key'
      wk.setup()

      -- Document existing key chains
      wk.add {
        { '<leader>c', desc = '[C]ode', hidden = true },
        { '<leader>d', desc = '[D]ocument', hidden = true },
        { '<leader>r', desc = '[R]ename', hidden = true },
        { '<leader>s', desc = '[S]earch', hidden = true },
        { '<leader>w', desc = '[W]orkspace', hidden = true },
        { '<leader>t', desc = '[T]oggle', hidden = true },
        { '<leader>h', desc = 'Git [H]unk', hidden = true },
      }
      -- visual mode
      wk.add {
        { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    -- branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      -- { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        defaults = {
          layout_config = {
            width = 0.99,
          },
        },
        pickers = {
          find_files = { path_display = { 'smart' }, hidden = true },
          file_browser = { { cwd_to_path = true, path = '%:p:h' } },
          keymaps = { layout_config = { prompt_position = 'top' } },
          grep_string = { path_display = { 'smart' } },
          oldfiles = { path_display = { 'smart' } },
          buffers = { path_display = { 'smart' } },
          lsp_references = { path_display = { 'tail' } },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'file_browser')
      local harpoon = require 'harpoon'
      harpoon:setup {}

      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<leader>h', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<leader>j', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<leader>k', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<leader>l', function()
        harpoon:list():select(4)
      end)
      vim.keymap.set('n', '<leader>e', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sl', function()
        builtin.find_files { cwd = vim.fn.expand '~/db', search_file = '*.sql' }
      end, { desc = 'Find [S]q[L] files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>o', 'o<Esc>k', { desc = '[ o] Insert line under curser' })
      vim.keymap.set('n', '<leader>O', 'O<Esc>j', { desc = '[ o] Insert line above curser' })
      vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>', { desc = 'Git Diffview open' })
      vim.keymap.set('n', '<leader>gD', ':DiffviewFileHistory<CR>', { desc = 'Git File History' })
      vim.keymap.set('n', '<leader>b', function()
        local bufferName = vim.api.nvim_buf_get_name(0)
        vim.fn.setreg('+', bufferName)
      end, { desc = '[<leader>b] copy buffer name to clipboard' })
      vim.keymap.set('n', '<C-g>', function()
        local filepath = vim.api.nvim_buf_get_name(0)
        local cmd = { 'git', 'log', '--pretty=format:%h %ad %an %s', '--date=short', '--follow', '--', filepath }

        vim.fn.jobstart(cmd, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if not data then
              return
            end
            local lines = vim.tbl_filter(function(line)
              return line ~= ''
            end, data)

            -- Floating Window erstellen
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<CR>', {
              nowait = true,
              noremap = true,
              silent = true,
            })

            local width = math.floor(vim.o.columns * 0.8)
            local height = math.floor(vim.o.lines * 0.6)
            local row = math.floor((vim.o.lines - height) / 2)
            local col = math.floor((vim.o.columns - width) / 2)

            vim.api.nvim_open_win(buf, true, {
              relative = 'editor',
              width = width,
              height = height,
              row = row,
              col = col,
              style = 'minimal',
              border = 'rounded',
            })
          end,
        })
      end, { desc = '[<C-g] show git history for buffer' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- You can add other tools here that you want Mason to install
  -- for you, so that they are available from within Neovim.

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { cpp = true, c = true, h = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofumpt' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFileHistory' },
    config = function()
      require('diffview').setup()
    end,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type table oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.nvim', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    cond = not vim.g.vscode,
  },
  --  {
  --    'folke/flash.nvim',
  --    event = 'VeryLazy',
  --    ---@type Flash.Config
  --    opts = {},
  --  -- stylua: ignore
  --  keys = {
  --    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --  },
  --  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }
      require('mini.icons').setup()
      -- require('mini.cursorword').setup()
      --    require('mini.animate').setup {
      --      cursor = {
      --        enable = true,
      --        timing = require('mini.animate').gen_timing.linear { duration = 100, unit = 'total' },
      --      },
      --      scroll = {
      --        enable = true,
      --        timing = require('mini.animate').gen_timing.linear { duration = 50, unit = 'total' },
      --      },
      --      resize = {
      --        enable = true,
      --        timing = require('mini.animate').gen_timing.linear { duration = 100, unit = 'total' },
      --      },
      --      open = {
      --        enable = true,
      --        timing = require('mini.animate').gen_timing.linear { duration = 100, unit = 'total' },
      --      },
      --      close = {
      --        enable = true,
      --        timing = require('mini.animate').gen_timing.linear { duration = 100, unit = 'total' },
      --      },
      --    }
      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- require('mini.files').setup()
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
    },
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'gitcommit' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby', 'python', 'c', 'cpp' },
      },
      indent = { enable = true, disable = { 'ruby', 'python', 'c', 'cpp' } },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ['öw'] = '@parameter.inner',
          },
          goto_previous_start = {
            ['ör'] = '@parameter.inner',
          },
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
local map = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = 'LSP: ' .. desc })
end

-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-t>.
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })

-- Find references for the word under your cursor.
map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

-- Jump to the implementation of the word under your cursor.
--  Useful when your language has ways of declaring types without an actual implementation.
map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

-- Jump to the type of the word under your cursor.
--  Useful when you're not sure what type a variable is and you want to see
--  the definition of its *type*, not where it was *defined*.
map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

-- Fuzzy find all the symbols in your current document.
--  Symbols are things like variables, functions, types, etc.
map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

-- Fuzzy find all the symbols in your current workspace.
--  Similar to document symbols, except searches over your entire project.
map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

-- Rename the variable under your cursor.
--  Most Language Servers support renaming across files, etc.
map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

-- Execute a code action, usually your cursor needs to be on top of an error
-- or a suggestion from your LSP for this to activate.
map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

--        -- Opens a popup that displays documentation about the word under your cursor
--        --  See `:help K` for why this keymap.
--        map('K', vim.lsp.buf.hover, 'Hover Documentation')

-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
-- Global nutzbar machen

map('<leader><Tab>', function()
  require('utils').ClangdSwitchSourceHeader()
end, 'switch between source and header')
vim.api.nvim_set_hl(0, 'MiniCursorword', { bg = '#5a4a2f', underline = false })
vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', { bg = '#5f875f', bold = true })

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
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
