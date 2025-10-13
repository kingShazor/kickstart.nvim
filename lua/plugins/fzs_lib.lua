M = {
  dir = '~/.config/nvim/lua/plugins',
  name = 'telescope-fuzzySearcher-intro',
  lazy = false, -- direkt beim Start laden
}
return M

-- local ffi = require 'ffi'
-- local library_path = (function()
--   local dirname = string.sub(debug.getinfo(1).source, 2, #'/fzs_lib.lua' * -1)
--   if package.config:sub(1, 1) == '\\' then
--     return dirname .. '../build/libfzs.dll'
--   else
--     return dirname .. '../build/libfzs.so'
--   end
-- end)()
-- local native = ffi.load(library_path)
--
-- ffi.cdef [[
--   // typedef struct {
--   //   uint32_t *data;
--   //   size_t size;
--   //   size_t cap;
--   // } fzf_position_t;
--
--   // fzf_position_t *fzf_get_positions(const char *text, const char *pattern);
--   // void fzf_free_positions(fzf_position_t *pos);
--   int32_t fzs_get_score(const char *text, const char *pattern);
-- ]]
--
-- local fzs = {}
--
-- fzs.get_score = function(input, pattern_struct)
--   return native.fzs_get_score(input, pattern_struct)
-- end
--
-- -- fzs.get_pos = function(input, pattern_struct, slab)
-- --   local pos = native.fzf_get_positions(input, pattern_struct, slab)
-- --   if pos == nil then
-- --     return
-- --   end
-- --
-- --   local res = {}
-- --   for i = 1, tonumber(pos.size) do
-- --     res[i] = pos.data[i - 1] + 1
-- --   end
-- --   native.fzf_free_positions(pos)
-- --
-- --   return res
-- -- end
--
-- return fzs
