-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LSP Server to use for Rust.
-- Set to "bacon-ls" to use bacon-ls instead of rust-analyzer.
-- only for diagnostics. The rest of LSP support will still be
-- provided by rust-analyzer.
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Fix syntax highlighting for chezmoi files
vim.filetype.add({
  extension = {
    tmpl = function(path, bufnr)
      local new_path = path:gsub("%.tmpl$", "")
      return vim.filetype.match({ filename = new_path })
    end,
  },
  pattern = {
    [".*/.local/share/chezmoi/.*"] = function(path, bufnr)
      local name = vim.fn.fnamemodify(path, ":t")
      name = name:gsub("^dot_", "."):gsub("^private_dot_", "."):gsub("^private_", ""):gsub("%.tmpl$", "")
      return vim.filetype.match({ filename = name })
    end,
  },
})
