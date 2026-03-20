return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({})

    local ok_cmp, cmp = pcall(require, "cmp")
    if not ok_cmp then
      return
    end

    local ok_cmp_ap, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if not ok_cmp_ap then
      return
    end

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
