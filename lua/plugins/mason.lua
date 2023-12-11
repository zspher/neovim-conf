local function diableNixos()
  if vim.fn.isdirectory "/nix/var/nix/profiles/system" == 1 then return false end
  return true
end

return {

  {
    "williamboman/mason.nvim",
    enabled = diableNixos(),
    optional = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = diableNixos(),
    optional = true,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    enabled = diableNixos(),
    optional = true,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    enabled = diableNixos(),
    optional = true,
  },
}
