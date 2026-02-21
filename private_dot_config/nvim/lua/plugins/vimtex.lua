return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function() -- MUST be init(), not config()
      -- 1. Viewer Configuration
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_forward_search_on_start = 1

      -- 2. LaTeXmk Configuration
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "",
        out_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-pdf",
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      -- 3. BibLaTeX support
      vim.g.vimtex_quickfix_mode = 0
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },
}
