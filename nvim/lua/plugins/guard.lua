
return {
  {
    "nvimdev/guard.nvim",
    dependencies = {
	"nvimdev/guard-collection",
    },
    config = function()
        local ft = require('guard.filetype')
	ft('c'):fmt('clang-format')
    end,
  }
}
