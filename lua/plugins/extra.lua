---@type LazySpec[]
return {
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  {
    "wakatime/vim-wakatime",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },
}
