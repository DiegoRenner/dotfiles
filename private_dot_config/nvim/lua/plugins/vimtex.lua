return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
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
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-shell-escape",
          "-view=none",
        },
      }

      -- 2. Viewer Configuration (Zathura is best for Linux)
      vim.g.vimtex_view_method = "zathura"

      -- 3. Prevent forward search from stealing focus every time you save
      vim.g.vimtex_view_forward_search_on_start = 1

      -- 4. BibLaTeX support
      vim.g.vimtex_quickfix_mode = 0 -- Optional: suppress quickfix window popping up on warnings
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },
}
