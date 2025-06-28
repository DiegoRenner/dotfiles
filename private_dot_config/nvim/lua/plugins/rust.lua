return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- opts.servers.rust_analyzer = {
      --   settings = {
      --     ["rust-analyzer"] = {
      --       check = {
      --         command = "clippy", -- or "check"
      --       },
      -- },
      -- },
      -- }
    end,
  },
}
