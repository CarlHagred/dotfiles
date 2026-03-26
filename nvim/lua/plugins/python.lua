return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = { enabled = false },
        ty = { enabled = false },
      },
    },
  },
}
