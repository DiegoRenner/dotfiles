return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--background-index-priority=low",
            "--clang-tidy",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--header-insertion=never",
            "--all-scopes-completion",
            "--query-driver=/usr/bin/g++-13,/usr/bin/g++,/usr/bin/c++,/opt/cuda/bin/nvcc*",
          },
        },
      },
    },
  },
}
