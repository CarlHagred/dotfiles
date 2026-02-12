return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          enabled = true,
          settings = {
            basedpyright = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },
        pylsp = {
          enabled = true,
          settings = {
            pylsp = {
              plugins = {
                -- Enable rope for auto-import
                rope_autoimport = { enabled = true },
                rope_completion = { enabled = true },
                -- Disable features handled by basedpyright/ruff
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
}
