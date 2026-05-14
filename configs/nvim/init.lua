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
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", function()
        telescope.find_files({ hidden = true })
      end, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Live grep" })
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end
      configs.setup({
        auto_install = true,
        ensure_installed = {
          "bash",
          "cpp",
          "css",
          "html",
          "java",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "rust",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
          },
          follow_current_file = {
            enabled = true,
          },
        },
        window = {
          mappings = {
            ["<space>"] = "none",
            ["<leader>"] = "none",
            ["<C-h>"] = "close_window",
          },
        },
      })
      vim.keymap.set("n", "<leader>e", ":Neotree reveal left<CR>", { desc = "File explorer" })
      vim.keymap.set("n", "<Tab>", "<C-w>w", { desc = "Next window" })
      vim.keymap.set("n", "<S-Tab>", "<C-w>W", { desc = "Previous window" })
      vim.keymap.set({ "n", "v" }, "<C-Left>", "<C-w>h", { desc = "Move left" })
      vim.keymap.set({ "n", "v" }, "<C-Right>", "<C-w>l", { desc = "Move right" })
      vim.keymap.set({ "n", "v" }, "<C-Up>", "<C-w>k", { desc = "Move up" })
      vim.keymap.set({ "n", "v" }, "<C-Down>", "<C-w>j", { desc = "Move down" })
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<Tab>", 'copilot#Accept("<Tab>")', { expr = true, silent = true, desc = "Copilot accept" })
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true, desc = "Copilot accept" })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("codecompanion").setup({
        display = {
          action_palette = {
            provider = "telescope",
          },
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>ac", ":CodeCompanionChat<CR>", { desc = "CodeCompanion chat" })
    end,
  },
})
