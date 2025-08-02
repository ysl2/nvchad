-- Ref: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/markdown.lua
return {
  { import = "nvchad.blink.lazyspec" },
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        github = {
          download_url_template = "https://ghfast.top/https://github.com/%s/releases/download/%s/%s",
        },
        ensure_installed = { "marksman", "prettier", "markdownlint-cli2", "markdown-toc" },
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local servers = { "marksman" }
      vim.lsp.enable(servers)
    end
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()

          -- You can call `try_lint` with a linter name or a list of names to always
          -- run specific linters, independent of the `linters_by_ft` configuration
          -- require("lint").try_lint("cspell")
        end,
      })
    end
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find "<!%-%- toc %-%->" then
                return true
              end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
}
