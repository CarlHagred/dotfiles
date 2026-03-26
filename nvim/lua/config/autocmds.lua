-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Silently handle stale swap files instead of showing the E325 dialog,
-- which errors out when triggered from programmatic buffer opens (e.g. snacks picker).
vim.api.nvim_create_autocmd("SwapExists", {
  group = vim.api.nvim_create_augroup("handle_swapfile", { clear = true }),
  callback = function()
    vim.v.swapchoice = "e"
  end,
})
