local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function configure(name, opts)
  local base = vim.lsp.config[name]
  if type(base) ~= "table" then
    base = {}
  end

  vim.lsp.config(name, vim.tbl_deep_extend("force", base, opts or {}))
end

local function enable_if(name, bin)
  if vim.fn.executable(bin) == 1 then
    vim.lsp.enable(name)
  end
end

configure("clangd", {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion-decorators",
    "--compile-commands-dir=build",
  },
})
enable_if("clangd", "clangd")

configure("gopls", { capabilities = capabilities })
enable_if("gopls", "gopls")

configure("ts_ls", { capabilities = capabilities })
enable_if("ts_ls", "typescript-language-server")

configure("svelte", { capabilities = capabilities })
enable_if("svelte", "svelteserver")

configure("astro", { capabilities = capabilities })
enable_if("astro", "astro-ls")

configure("tofu_ls", {
  capabilities = capabilities,
  filetypes = { "tf", "terraform", "terraform-vars", "opentofu", "opentofu-vars" },
})
enable_if("tofu_ls", "tofu-ls")

configure("dockerls", {
  capabilities = capabilities,
  cmd = { "docker-language-server", "start", "--stdio" },
})
enable_if("dockerls", "docker-language-server")

configure("docker_compose_language_service", { capabilities = capabilities })
enable_if("docker_compose_language_service", "docker-compose-langserver")

configure("yamlls", {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "**/docker-compose.yml",
          "**/docker-compose.yaml",
          "**/docker-compose.*.yml",
          "**/docker-compose.*.yaml",
        },
      },
    },
  },
})
enable_if("yamlls", "yaml-language-server")

configure("marksman", { capabilities = capabilities })
enable_if("marksman", "marksman")

configure("bashls", { capabilities = capabilities })
enable_if("bashls", "bash-language-server")

configure("sqlls", { capabilities = capabilities })
enable_if("sqlls", "sql-language-server")
