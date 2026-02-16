return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = { enabled = false },
        pyright = { enabled = false },
        pylsp = { enabled = false },
        ty = {
          enabled = true,
          cmd = { vim.fn.expand("~/.local/bin/ty-server") },
        },
      },
    },
  },
}
