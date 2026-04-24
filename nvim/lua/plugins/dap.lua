return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      require("config.dap")
    end,
  },
}
