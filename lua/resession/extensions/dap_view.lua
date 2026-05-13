local M = {}

---Get the saved data for this extension
---@param opts resession.Extension.OnSaveOpts Information about the session being saved
---@return any
M.on_save = function(opts)
  if not package.loaded["dap-view"] then return nil end
  local state = require "dap-view.state"

  return {
    section = state.current_section,
    expr_count = state.expr_count,
    watches = state.watched_expressions,
    exceptions_options = state.exceptions_options,
  }
end

---Restore the extension state
---@param data any The value returned from on_save
M.on_post_load = function(data)
  if data then
    local state = require "dap-view.state"
    state.current_section = data.section or ""
    state.expr_count = data.expr_count or 0
    state.watched_expressions = data.watches or {}

    -- HACK: stop gap solution to saving breakpoints
    --       probably should be implemented in nvim-dap
    state.exceptions_options = data.exceptions_options or {}
  end
end

return M
