return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local ok_configs, configs = pcall(require, "nvim-treesitter.configs")
    local ok_ts, ts = pcall(require, "nvim-treesitter")

    local setup = nil
    if ok_configs and type(configs) == "table" and type(configs.setup) == "function" then
      setup = configs.setup
    elseif ok_ts and type(ts) == "table" and type(ts.setup) == "function" then
      setup = ts.setup
    else
      return
    end

    setup({
      ensure_installed = {
        "astro",
        "bash",
        "c",
        "cpp",
        "dockerfile",
        "go",
        "hcl",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "sql",
        "svelte",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })

    vim.treesitter.language.register("terraform", "tf")
  end,
}
