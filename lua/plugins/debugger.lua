---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {})
    or config.args
    or {}
  local args_str = type(args) == "table" and table.concat(args, " ") or args

  config = vim.deepcopy(config)
  config.args = function()
    local new_args =
      vim.fn.expand(vim.fn.input("Run with args: ", args_str --[[@as string]]))
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

local function edit_breakpoint()
  -- Search for an existing breakpoint on this line in this buffer
  ---@return dap.SourceBreakpoint bp that was either found, or an empty placeholder
  local function find_bp()
    local buf_bps =
      require("dap.breakpoints").get(vim.fn.bufnr())[vim.fn.bufnr()]
    ---@type dap.SourceBreakpoint
    local bp = {
      condition = "",
      logMessage = "",
      hitCondition = "",
      line = vim.fn.line ".",
    }
    for _, candidate in ipairs(buf_bps) do
      if candidate.line and candidate.line == vim.fn.line "." then
        bp = candidate
        break
      end
    end
    return bp
  end

  -- Elicit customization via a UI prompt
  ---@param bp dap.SourceBreakpoint a breakpoint
  local function customize_bp(bp)
    local props = {
      ["Condition"] = {
        value = bp.condition,
        setter = function(v) bp.condition = v end,
      },
      ["Hit Condition"] = {
        value = bp.hitCondition,
        setter = function(v) bp.hitCondition = v end,
      },
      ["Log Message"] = {
        value = bp.logMessage,
        setter = function(v) bp.logMessage = v end,
      },
    }
    local menu_options = {}
    for k, v in pairs(props) do
      table.insert(menu_options, ("%s: %s"):format(k, v.value))
    end
    vim.ui.select(menu_options, {
      prompt = "Edit Breakpoint",
    }, function(choice)
      local prompt = (tostring(choice)):gsub(":.*", "")
      props[prompt].setter(vim.fn.input {
        prompt = prompt,
        default = props[prompt].value,
      })

      -- Set breakpoint for current line, with customizations (see h:dap.set_breakpoint())
      require("dap").set_breakpoint(
        bp.condition,
        bp.hitCondition,
        bp.logMessage
      )
    end)
  end

  customize_bp(find_bp())
end

function RunHandshake(self, request_payload)
  local dap_utils = require "dap.utils"
  local signResult =
    io.popen("vsdbgsignature " .. request_payload.arguments.value)
  if signResult == nil then
    dap_utils.notify("error while signing handshake", vim.log.levels.ERROR)
    return
  end
  local signature = signResult:read "*a"
  signature = string.gsub(signature, "\n", "")
  local response = {
    type = "response",
    seq = 0,
    command = "handshake",
    request_seq = request_payload.seq,
    success = true,
    body = {
      signature = signature,
    },
  }
  local function send_payload(client, payload)
    local rpc = require "dap.rpc"
    local msg = rpc.msg_with_content_length(vim.json.encode(payload))
    client.write(msg)
  end
  send_payload(self.client, response)
end

---@type LazySpec[]
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "igorlfs/nvim-dap-view",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    keys = {
      {
        "<leader>dc",
        function() require("dap").run_to_cursor() end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function() require("dap").goto_() end,
        desc = "Go to Line (No Execute)",
      },
      {
        "<leader>dj",
        function() require("dap").down() end,
        desc = "Down",
      },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      {
        "<leader>dl",
        function() require("dap").run_last() end,
        desc = "Run Last",
      },
      {
        "<leader>dr",
        function() require("dap").repl.toggle() end,
        desc = "Toggle REPL",
      },
      {
        "<leader>dw",
        function() require("dap.ui.widgets").hover() end,
        desc = "Widgets",
      },
      {
        "<leader>da",
        function() require("dap").continue { before = get_args } end,
        desc = "Run with Args",
      },
      {
        "<F5>",
        function() require("dap").continue() end,
        desc = "Debugger: Start",
      },
      {
        "<F21>", -- Shift+F9
        edit_breakpoint,
        desc = "Set Condition Breakpoint",
      },
      {
        "<F9>",
        function() require("dap").toggle_breakpoint() end,
        desc = "Debugger: Toggle Breakpoint",
      },
      {
        "<F33>", -- Control+F9
        function() require("dap").clear_breakpoints() end,
        desc = "Debugger: Clear All Breakpoints",
      },
      {
        "<F17>", -- Shift+F5
        function() require("dap").terminate() end,
        desc = "Debugger: Stop",
      },
      {
        "<F29>", -- Control+F5
        function() require("dap").restart_frame() end,
        desc = "Debugger: Restart",
      },
      {
        "<F6>",
        function() require("dap").pause() end,
        desc = "Debugger: Pause",
      },
      {
        "<F7>",
        function() require("dap").reverse_continue() end,
        "Debugger: Reverse",
      },
      {
        "<F10>",
        function() require("dap").step_over() end,
        desc = "Debugger: Step Over",
      },
      {
        "<F11>",
        function() require("dap").step_into() end,
        desc = "Debugger: Step Into",
      },
      {
        "<F23>", -- Shift+F11
        function() require("dap").step_out() end,
        desc = "Debugger: Step Out",
      },
    },

    config = function()
      -- add jsonc support to launch.json support
      local vscode = require "dap.ext.vscode"
      local json = require "plenary.json"
      ---@diagnostic disable-next-line: duplicate-set-field
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      local dap = require "dap"
      dap.adapters["netcoredbg"] = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }
      dap.adapters["codelldb"] = {
        type = "executable",
        command = "codelldb",
      }
      dap.adapters.coreclr = {
        id = "coreclr",
        type = "executable",
        command = "vsdbg-ui",
        args = {
          "--interpreter=vscode",
        },
        reverse_request_handlers = {
          handshake = RunHandshake,
        },
      }
      -- js-debug
      for _, adapterType in ipairs { "node", "chrome", "msedge" } do
        local pwaType = "pwa-" .. adapterType

        dap.adapters[pwaType] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "js-debug",
            args = { "${port}" },
          },
        }

        -- Define adapters without the "pwa-" prefix for VSCode compatibility
        dap.adapters[adapterType] = function(cb, config)
          local nativeAdapter = dap.adapters[pwaType]

          config.type = pwaType

          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      vim.api.nvim_set_hl(
        0,
        "DapStoppedLine",
        { default = true, link = "Visual" }
      )

      local dap_icons = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = { " " },
        BreakpointCondition = { " " },
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = { ".>" },
      }

      for name, sign in pairs(dap_icons) do
        vim.fn.sign_define("Dap" .. name, {
          text = sign[1],
          texthl = sign[2] or "DiagnosticInfo",
          linehl = sign[3],
          numhl = sign[3],
        })
      end
    end,
  },

  -- fancy UI for the debugger
  {
    "igorlfs/nvim-dap-view",
    keys = {
      {
        "<leader>du",
        function() require("dap-view").toggle() end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function() require("dap-view").add_expr() end,
        desc = "Watch",
        mode = { "n", "x" },
      },
      {
        "<leader>ds",
        function() require("dap-view").show_view "sessions" end,
        desc = "Show Session",
      },
      {
        "<leader>dW",
        function() require("dap-view").show_view "watches" end,
        desc = "Show Watch",
      },
      {
        "<leader>dB",
        function() require("dap-view").show_view "breakpoints" end,
        desc = "Show Breakpoints",
      },
    },
    opts = {
      auto_toggle = "open_term",
      windows = {
        terminal = {
          size = 0.4,
          position = "right",
        },
      },
      winbar = {
        sections = {
          "watches",
          "scopes",
          "exceptions",
          "sessions",
          "breakpoints",
          "threads",
          "repl",
        },
        controls = {
          enabled = true,
          buttons = {
            "play",
            "step_into",
            "step_over",
            "step_out",
            "step_back",
            "reverse_continue",
            "run_last",
            "terminate",
            "disconnect",
          },
          custom_buttons = {
            reverse_continue = {
              render = function()
                local statusline = require "dap-view.util.statusline"

                local session = require("dap").session()

                if session == nil then
                  return statusline.hl("", "ControlNC")
                end

                local supported = session.capabilities.supportsStepBack
                return statusline.hl(
                  "",
                  supported and "ControlPlay" or "ControlNC"
                )
              end,
              action = function()
                if require("dap").session().capabilities.supportsStepBack then
                  require("dap").reverse_continue()
                end
              end,
            },
          },
        },
      },
    },
    config = function(_, opts)
      local dap = require "dap"
      local dapview = require "dap-view"

      dapview.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapview.open()
      end
    end,
  },
}
