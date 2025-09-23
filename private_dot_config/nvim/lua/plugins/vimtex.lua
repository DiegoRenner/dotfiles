return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      -- Disable conflicting latexmk viewer
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-shell-escape", -- <<< add this
          "-view=none", -- important: let VimTeX manage the viewer
        },
      }

      -- Viewer (Arch friendly: use zathura if installed, otherwise evince)
      vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_view_general_viewer = "xdg-open"
      vim.g.vimtex_view_forward_search_on_start = 1
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },
}
