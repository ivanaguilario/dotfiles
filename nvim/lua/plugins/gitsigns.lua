return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("gitsigns").setup({
      current_line_blame = false,
    })

    local gs = package.loaded.gitsigns
    if not gs then
      return
    end

    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(gs.next_hunk)
      return "<Ignore>"
    end, { expr = true, desc = "Next git hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(gs.prev_hunk)
      return "<Ignore>"
    end, { expr = true, desc = "Prev git hunk" })

    vim.keymap.set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
    vim.keymap.set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
    vim.keymap.set("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
    vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
    vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
  end,
}
