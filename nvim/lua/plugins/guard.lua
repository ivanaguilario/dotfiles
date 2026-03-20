
return {
  {
    "nvimdev/guard.nvim",
    dependencies = {
	"nvimdev/guard-collection",
    },
    config = function()
	local ft = require("guard.filetype")
	if vim.fn.executable("clang-format") == 1 then
		ft("c"):fmt("clang-format")
	end
    end,
  }
}
