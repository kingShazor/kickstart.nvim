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

vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true
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
vim.o.cmdheight = 1
vim.o.laststatus = 3

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
vim.keymap.set('n', '<leader>!', ':quit!<CR>', { desc = 'force [!]quit nvim' })
vim.keymap.set('n', '<leader>R', ':update<CR> :source<CR>', { desc = 'Source files' })
vim.keymap.set('n', '<leader>i', function()
  vim.api.nvim_command('edit ' .. vim.fn.stdpath 'config' .. '/init.lua')
end, { desc = 'open init' })
vim.keymap.set('i', '<C-k>', '{  };<Esc>2hi', { desc = 'add safe C++ constructor { | } and start insert mode' })
vim.keymap.set('n', '<C-k>', '0f=xhr{f;i }<Esc>$<Esc>', { desc = 'convert unsafe constructor into sage C++ constructor' })
vim.keymap.set('n', '<v', '<c-v>', { desc = 'block mode' })
vim.keymap.set('i', '<C-h>', '{', { desc = 'add "{"' })
vim.keymap.set('i', '<C-n>', '}', { desc = 'add "}"' })
vim.keymap.set('n', 'öb', '2F,w', { desc = 'next parameter' })
vim.keymap.set('n', 'öw', 'f,w', { desc = 'prev parameter "}"' })

local function mark_desc(mark)
  local tuple = vim.api.nvim_get_mark(mark, {})
  if #tuple[4] == 0 then
    return ''
  end
  return string.format('Mark %s -→ %s:%d', mark, tuple[4], tuple[1])
end
local function register_marks()
  local wk = require 'which-key'
  wk.add {
    { '´q', desc = mark_desc 'Q' },
    { '´w', desc = mark_desc 'W' },
    { '´e', desc = mark_desc 'E' },
    { '´r', desc = mark_desc 'R' },
    { '´t', desc = mark_desc 'T' },

    { '´a', desc = mark_desc 'A' },
    { '´s', desc = mark_desc 'S' },
    { '´d', desc = mark_desc 'D' },
    { '´f', desc = mark_desc 'F' },
    { '´g', desc = mark_desc 'G' },

    { '´y', desc = mark_desc 'Y' },
    { '´x', desc = mark_desc 'X' },
    { '´c', desc = mark_desc 'C' },
    { '´v', desc = mark_desc 'V' },
    { '´b', desc = mark_desc 'B' },
  }
end
vim.keymap.set({ 'i', 'n', 'v' }, '´q', '`Q', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´w', '`W', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´e', '`E', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´r', '`R', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´t', '`T', {})

vim.keymap.set({ 'i', 'n', 'v' }, '´a', '`A', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´s', '`S', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´d', '`D', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´f', '`F', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´g', '`G', {})

vim.keymap.set({ 'i', 'n', 'v' }, '´y', '`Y', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´x', '`X', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´c', '`C', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´v', '`V', {})
vim.keymap.set({ 'i', 'n', 'v' }, '´b', '`B', {})

local function set_mark(mark)
  vim.cmd("normal! m" .. mark)

  require("which-key").add({
    { "´" .. mark:lower(), desc = mark_desc(mark) },
  })
end

vim.keymap.set("n", "mq", function() set_mark("Q") end)
vim.keymap.set("n", "mw", function() set_mark("W") end)
vim.keymap.set("n", "me", function() set_mark("E") end)
vim.keymap.set("n", "mr", function() set_mark("R") end)
vim.keymap.set("n", "mt", function() set_mark("T") end)

vim.keymap.set("n", "ma", function() set_mark("A") end)
vim.keymap.set("n", "ms", function() set_mark("S") end)
vim.keymap.set("n", "md", function() set_mark("d") end)
vim.keymap.set("n", "mf", function() set_mark("F") end)
vim.keymap.set("n", "mg", function() set_mark("G") end)

vim.keymap.set("n", "my", function() set_mark("Y") end)
vim.keymap.set("n", "mx", function() set_mark("x") end)
vim.keymap.set("n", "mc", function() set_mark("c") end)
vim.keymap.set("n", "mv", function() set_mark("v") end)
vim.keymap.set("n", "mb", function() set_mark("b") end)

vim.keymap.set('n', '<leader>o', 'o<Esc>k', { desc = '[ o] Insert line under curser' })
vim.keymap.set('n', '<leader>O', 'O<Esc>j', { desc = '[ o] Insert line above curser' })

vim.keymap.set('n', ':', function()
  require('utils').openPrompt()
end, { desc = 'mid prompt' })
vim.keymap.set('n', '<leader>f', function()
  require('utils').lspFormat()
end, { desc = '[F]ormat buffer' })

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*zig',
  callback = function()
    vim.lsp.buf.format { timeout_ms = 500 }
  end,
})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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
-- vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-n>', function()
  pNextFunc(nextFunc(true))
end, { desc = 'jump to next local list entry' })
vim.keymap.set('n', '<C-p>', function()
  pNextFunc(nextFunc(false))
end, { desc = 'jump to prev local list entry' })

vim.keymap.set('n', '<leader>b', function()
  local bufferName = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg('+', bufferName)
end, { desc = '[<leader>b] copy buffer name to clipboard' })
vim.keymap.set('n', '<C-g>', function()
  require('utils').gitLogForBuf()
end, { desc = '[<C-g] show git history for buffer' })

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

  -- { import = 'plugins' },
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
    dir = vim.fn.expand '~/my-projects/recipe-picker.nvim',
    name = 'recipe-picker.nvim',
    config = function()
      local picker = require 'recipe-picker'
      vim.keymap.set('n', '<leader>sf', function()
        picker.search { relative_height = 0.6, relative_width = 0.6 } -- position_color = '#aab86c' }
      end, { desc = '[S]earch [F]iles' })
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
    event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
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

      register_marks()
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
    dependencies = {
      'nvim-lua/plenary.nvim',
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
        extensions = {
          fuzzy_finder = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
        pickers = {
          find_files = { path_display = { 'absolute' }, hidden = true },
          keymaps = { layout_config = { prompt_position = 'top' } },
          grep_string = { path_display = { 'smart' } },
          oldfiles = { path_display = { 'smart' } },
          buffers = { path_display = { 'smart' } },
          lsp_references = { path_display = { 'tail' } },
        },
      }

      -- -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fuzzy_sorter')
      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      -- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
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
      vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>', { desc = 'Git Diffview open' })
      vim.keymap.set('n', '<leader>gD', ':DiffviewFileHistory<CR>', { desc = 'Git File History' })

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
    -- dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    cond = not vim.g.vscode,
  },
  {
    'nvim-mini/mini.nvim',
    version = '*',
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
      require('mini.notify').setup()
      require('mini.icons').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
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
}, {})

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

-- deferred loading and lazy loading
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  once = true,
  callback = function()
    require('ascii-intro').createIntro()
    vim.schedule(function()
      require('apt_packages_check').startTimer()
      require 'lsp'
    end)
  end,
})
