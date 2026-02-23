
local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities()


vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    --"--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--compile-commands-dir=build",
  }
})
vim.lsp.enable('clangd')

vim.lsp.config('gopls', {
    capabilities = capabilities
})
vim.lsp.enable('gopls')

vim.lsp.config('ts_ls', {
    capabilities = capabilities
})
vim.lsp.enable('ts_ls')

vim.lsp.config('tofu_ls', {
    capabilities = capabilities
})
vim.lsp.enable('tofu_ls')
