require "nvchad.autocmds"

-- Create a dedicated augroup to avoid conflicts.
-- local augroup = vim.api.nvim_create_augroup("MyCustomTermClose", { clear = true })
vim.api.nvim_create_autocmd("TermClose", {
  -- group = augroup,
  -- pattern = "*",
  callback = function(args)
    -- vim.schedule defers the function call to be executed on Neovim's main loop.
    -- This safely bypasses the "Press ENTER" prompt.
    vim.schedule(function()
      -- Check if the buffer is still valid, just in case.
      if vim.api.nvim_buf_is_valid(args.buf) then
        -- Use the API to force-delete the buffer, which is more low-level than :b
        vim.api.nvim_buf_delete(args.buf, { force = true })
      end
    end)
  end,
  desc = "Gracefully close terminal buffer on process exit",
})

-- Ref: https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/config/autocmds.lua#L7
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd "checktime"
    end
  end,
})
