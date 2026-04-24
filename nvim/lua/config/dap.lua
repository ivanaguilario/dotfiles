local dap = require("dap")
local dapui = require("dapui")

local function first_path(paths)
  for _, path in ipairs(paths) do
    if path and path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
  end
end

local function first_directory(paths)
  for _, path in ipairs(paths) do
    if path and path ~= "" and vim.fn.isdirectory(vim.fn.expand(path)) == 1 then
      return vim.fn.expand(path)
    end
  end
end

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticSignInfo", linehl = "Visual", numhl = "" })

require("nvim-dap-virtual-text").setup({})

dapui.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

map("<leader>db", dap.toggle_breakpoint, "Toggle breakpoint")
map("<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Set conditional breakpoint")
map("<leader>dc", dap.continue, "Debug continue")
map("<leader>di", dap.step_into, "Debug step into")
map("<leader>do", dap.step_over, "Debug step over")
map("<leader>dO", dap.step_out, "Debug step out")
map("<leader>dl", dap.run_last, "Debug run last")
map("<leader>dr", dap.repl.toggle, "Toggle debug REPL")
map("<leader>du", dapui.toggle, "Toggle debug UI")
map("<leader>dx", dap.terminate, "Terminate debug session")
map("<leader>dw", function()
  dapui.elements.watches.add(vim.fn.expand("<cword>"))
end, "Watch word under cursor")

local delve_path = first_path({ vim.env.DLV_PATH, "dlv" })
if delve_path then
  require("dap-go").setup({
    delve = {
      path = delve_path,
      detached = vim.fn.has("win32") == 0,
    },
  })

  map("<leader>dt", require("dap-go").debug_test, "Debug nearest Go test")
  map("<leader>dT", require("dap-go").debug_last_test, "Debug last Go test")
end

local js_debug_path = first_directory({
  vim.env.VSCODE_JS_DEBUG_PATH,
  vim.env.JS_DEBUG_ADAPTER_PATH,
})

if js_debug_path then
  require("dap-vscode-js").setup({
    node_path = first_path({ vim.env.NODE_PATH, "node" }) or "node",
    debugger_path = js_debug_path,
    adapters = {
      "pwa-node",
      "pwa-chrome",
      "pwa-msedge",
    },
  })

  local js_languages = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  }

  for _, language in ipairs(js_languages) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch current file (Node)",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to Node process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      },
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch Chrome against localhost",
        url = function()
          return vim.fn.input("Debug URL: ", "http://localhost:3000")
        end,
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
        protocol = "inspector",
      },
    }
  end
end

local codelldb_path = first_path({ vim.env.CODELLDB_PATH, "codelldb" })
if codelldb_path then
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },
    },
  }

  local codelldb_configurations = {
    {
      name = "Launch executable",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = function()
        local input = vim.fn.input("Arguments: ")
        if input == "" then
          return {}
        end
        return vim.split(input, " ")
      end,
    },
  }

  dap.configurations.c = codelldb_configurations
  dap.configurations.cpp = codelldb_configurations
end
