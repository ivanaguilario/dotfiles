require("ivanaguilario.remap")
require("ivanaguilario.lines")

vim.filetype.add({
  extension = {
    tofu = "opentofu",
    psql = "sql",
    pgsql = "sql",
  },
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
})
