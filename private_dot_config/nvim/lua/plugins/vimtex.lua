return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- Use init() to set globals before the plugin loads

      -- 1. LaTeXmk Configuration
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        aux_dir = "",
        out_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-shell-escape",
          "-view=none",
        },
      }

      -- 2. Viewer Configuration (Zathura is best for Linux)
      vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_view_general_viewer = "xdg-open"
      vim.g.vimtex_view_forward_search_on_start = 1

      -- 3. Prevent forward search from stealing focus every time you save
      vim.g.vimtex_view_forward_search_on_start = 0
    end,
  },
}
