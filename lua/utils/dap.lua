local M = {}
local breakpoints = require "dap.breakpoints"

-- sources:
-- https://github.com/mfussenegger/nvim-dap/issues/198#issuecomment-2764679167
-- https://github.com/Weissle/persistent-breakpoints.nvim

local function get_path()
  local path_sep = "/"
  return vim.uv.cwd():gsub(path_sep, "_")
end

--- Store all breakpoints in a global variable to be persisted in the session
M.store_breakpoints = function()
  local filename = vim.api.nvim_buf_get_name(0)
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_breakpoints = breakpoints.get()[buf_id]

  if #filename == 0 then return end

  vim.g.DAP_BREAKPOINTS = { [filename] = buf_breakpoints }
end

--- Load existing breakpoints for all open buffers in the session
M.load_breakpoints = function()
  local current_bps = breakpoints.get()
  local saved_bps = vim.g.DAP_BREAKPOINTS or {}
  local bufs_to_restore = {}

  -- Find the new loaded buffer.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local file_name = vim.api.nvim_buf_get_name(buf)

    local breakpoints_not_loaded = current_bps[buf] == nil
    local has_saved_breakpoints =
      not vim.tbl_isempty(saved_bps[file_name] or {})

    if breakpoints_not_loaded and has_saved_breakpoints then
      bufs_to_restore[file_name] = buf
    end
  end

  for filename, buf_id in pairs(bufs_to_restore) do
    for _, bp in pairs(saved_bps[filename]) do
      local line = bp.line
      local opts = {
        condition = bp.condition,
        log_message = bp.logMessage,
        hit_condition = bp.hitCondition,
      }
      breakpoints.set(opts, buf_id, line)
    end
  end
end

M.clear_data = function() vim.g.DAP_BREAKPOINTS = {} end

return M
