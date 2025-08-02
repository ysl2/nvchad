return {
  -- {
  --   "stevearc/conform.nvim",
  --   -- event = 'BufWritePre', -- uncomment for format on save
  --   opts = require "configs.conform",
  -- },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require "configs.lspconfig"
  --   end,
  -- },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
        vim.keymap.del("n", "H", { buffer = bufnr })
        vim.keymap.set("n", "I", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
        vim.keymap.set("n", "z", api.tree.collapse_all, opts "Collapse")
        vim.keymap.set("n", "Z", api.tree.expand_all, opts "Expand All")
        vim.keymap.set("n", "s", api.node.open.horizontal, opts "Open: Horizontal Split")
        vim.keymap.del("n", "<C-v>", { buffer = bufnr })
        vim.keymap.set("n", "v", api.node.open.vertical, opts "Open: Vertical Split")

        vim.keymap.set("n", "t", function()
          local node = api.tree.get_node_under_cursor()
          api.node.open.tab(node)
          vim.cmd.tabprev()
        end, opts "open_tab_silent")

        vim.keymap.set("n", "T", function()
          local node = api.tree.get_node_under_cursor()
          vim.cmd "quit"
          api.node.open.tab(node)
        end, opts "open_tab_and_close_tree")

        vim.keymap.set("n", "<C-t>", function()
          local node = api.tree.get_node_under_cursor()
          vim.cmd "wincmd l"
          api.node.open.tab(node)
        end, opts "open_tab_and_swap_cursor")
      end,
      filters = { custom = { "^.git$" } },
    },
  },
  {
    "akinsho/bufferline.nvim",
    custom = true,
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {
        options = {
          mode = "tabs",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = false,
        },
      }
    end,
  },
  {
    "folke/persistence.nvim",
    custom = true,
    lazy = false,
    opts = function()
      -- Auto restore session
      vim.api.nvim_create_autocmd("VimEnter", {
        nested = true,
        callback = function()
          local persistence = require "persistence"
          if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
            persistence.load()
          else
            persistence.stop()
          end
        end,
      })
    end,
  },
  {
    "csexton/trailertrash.vim",
    custom = true,
    event = "VeryLazy",
    config = function()
      vim.cmd "hi link UnwantedTrailerTrash NONE"
      vim.api.nvim_create_autocmd("BufWritePre", {
        command = "TrailerTrim",
      })
    end,
  },
  {
    -- Ref: https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/plugins/extras/lang/markdown.lua#L74
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    build = function()
      require("lazy").load { plugins = { "markdown-preview.nvim" } }
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_combine_preview = 1
    end,
    config = function()
      vim.cmd [[do FileType]]
    end,
  },
}
