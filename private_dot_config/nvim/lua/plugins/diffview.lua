return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  opts = {},
  init = function()
    -- better intra-hunk matching for long single-line paragraphs (LaTeX)
    vim.opt.diffopt:append("linematch:60")
  end,
}
