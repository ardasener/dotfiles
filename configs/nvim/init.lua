vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.mouse = "a"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "0.2.2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", telescope.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Live grep" })
    end,
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "<C-n>", require("oil").toggle_float, { desc = "File manager" })
    end,
  },
})
