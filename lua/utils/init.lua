local M = {}

function M.is_nixos()
  return vim.fn.isdirectory "/nix/var/nix/profiles/system" == 1
end

return M
