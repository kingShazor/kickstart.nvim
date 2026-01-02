local lsp_encoding = 'utf-8'

local compile_commands_dir = os.getenv 'CLANGD_COMPILE_COMMANDS_DIR' or os.getenv 'PWD'
local clangd_bin = vim.fn.executable 'clangd' == 1 and 'clangd' or 'clangd-20'
vim.lsp.config.clangd = {
  cmd = { clangd_bin, '--background-index', '--compile-commands-dir=' .. compile_commands_dir },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp', 'ixx' },
  general = { positionEncodings = { lsp_encoding } },
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
  general = { positionEncodings = { lsp_encoding } },
}

vim.lsp.config.zls = {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  general = { positionEncodings = { lsp_encoding } },
}

vim.lsp.enable { 'clangd', 'luals', 'zls' }

vim.keymap.set({ 'n', 'i' }, '<c-space>', function()
  vim.lsp.completion.get()
end)

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
