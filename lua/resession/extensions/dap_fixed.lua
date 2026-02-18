local M = {}

---Get the saved data for this extension
---@param opts resession.Extension.OnSaveOpts Information about the session being saved
---@return any
M.on_save = function(opts)
  if not package.loaded["dap"] then return nil end
  local breakpoints = require "dap.breakpoints"
  local all_breakpoints = {}
  for bufnr, bps in pairs(breakpoints.get()) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    for _, bp in ipairs(bps) do
      bp.filename = bufname
      table.insert(all_breakpoints, bp)
    end
  end
  return {
    breakpoints = all_breakpoints,
  }
end

---Restore the extension state
---@param data any The value returned from on_save
M.on_post_load = function(data)
  if data.breakpoints then
    local breakpoint = require "dap.breakpoints"
    for _, bp in ipairs(data.breakpoints) do
      local bufnr = vim.fn.bufadd(bp.filename)
      if not vim.api.nvim_buf_is_loaded(bufnr) then vim.fn.bufload(bufnr) end

      local opts = {
        condition = bp.condition,
        log_message = bp.logMessage,
        hit_condition = bp.hitCondition,
      }
      breakpoint.set(opts, bufnr, bp.line)
    end
  end
end

return M
