---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {})
        or config.args
        or {}
    local args_str = type(args) == "table" and table.concat(args, " ") or args

    config = vim.deepcopy(config)
    config.args = function()
        local new_args = vim.fn.expand(
            vim.fn.input("Run with args: ", args_str --[[@as string]])
        )
        if config.type and config.type == "java" then
            ---@diagnostic disable-next-line: return-type-mismatch
            return new_args
        end
        return require("dap.utils").splitstr(new_args)
    end
    return config
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

        keys = function(_, keys)
            local dap = require "dap"
            local default_keys = {
                {
                    "<leader>db",
                    dap.toggle_breakpoint,
                    desc = "Toggle Breakpoint",
                },
                { "<leader>dc", dap.continue, desc = "Run/Continue" },
                {
                    "<leader>da",
                    function() dap.continue { before = get_args } end,
                    desc = "Run with Args",
                },
                { "<leader>dC", dap.run_to_cursor, desc = "Run to Cursor" },
                { "<leader>dg", dap.goto_, desc = "Go to Line (No Execute)" },
                { "<leader>di", dap.step_into, desc = "Step Into" },
                { "<leader>dj", dap.down, desc = "Down" },
                { "<leader>dk", dap.up, desc = "Up" },
                { "<leader>dl", dap.run_last, desc = "Run Last" },
                { "<leader>do", dap.step_out, desc = "Step Out" },
                { "<leader>dO", dap.step_over, desc = "Step Over" },
                { "<leader>dP", dap.pause, desc = "Pause" },
                { "<leader>dr", dap.repl.toggle, desc = "Toggle REPL" },
                { "<leader>ds", dap.session, desc = "Session" },
                { "<leader>dt", dap.terminate, desc = "Terminate" },
                {
                    "<leader>dw",
                    require("dap.ui.widgets").hover,
                    desc = "Widgets",
                },
                { "<F5>", dap.continue, desc = "Debugger: Start" },
                { "<F17>", dap.terminate, desc = "Debugger: Stop" }, -- Shift+F5
                { "<F29>", dap.restart_frame, desc = "Debugger: Restart" }, -- Control+F5
                { "<F6>", dap.pause, desc = "Debugger: Pause" },
                { "<F7>", dap.reverse_continue, "Debugger: Reverse" },
                { "<F10>", dap.step_over, desc = "Debugger: Step Over" },
                { "<F11>", dap.step_into, desc = "Debugger: Step Into" },
                { "<F23>", dap.step_out, desc = "Debugger: Step Out" }, -- Shift+F11
            }
            return vim.tbl_deep_extend("force", default_keys, keys)
        end,

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
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "js-debug",
                    args = {
                        "${port}",
                    },
                },
            }

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
    {
        "Weissle/persistent-breakpoints.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        event = { "BufReadPost" },
        opts = {
            load_breakpoints_event = { "BufReadPost" },
        },
        keys = function(_, keys)
            local dap = require "dap"
            local breakpoint = require "persistent-breakpoints.api"

            local function edit_breakpoint()
                -- Search for an existing breakpoint on this line in this buffer
                ---@return dap.SourceBreakpoint bp that was either found, or an empty placeholder
                local function find_bp()
                    local buf_bps = require("dap.breakpoints").get(
                        vim.fn.bufnr()
                    )[vim.fn.bufnr()]
                    ---@type dap.SourceBreakpoint
                    local bp = {
                        condition = "",
                        logMessage = "",
                        hitCondition = "",
                        line = vim.fn.line ".",
                    }
                    for _, candidate in ipairs(buf_bps) do
                        if
                            candidate.line
                            and candidate.line == vim.fn.line "."
                        then
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
                        table.insert(
                            menu_options,
                            ("%s: %s"):format(k, v.value)
                        )
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
                        dap.set_breakpoint(
                            bp.condition,
                            bp.hitCondition,
                            bp.logMessage
                        )
                    end)
                end

                customize_bp(find_bp())
                breakpoint.breakpoints_changed_in_current_buffer()
            end
            local default_keys = {
                {
                    "<leader>dB",
                    edit_breakpoint,
                    desc = "Breakpoint Condition",
                },
                {
                    "<F9>",
                    breakpoint.toggle_breakpoint,
                    desc = "Debugger: Toggle Breakpoint",
                },
                {
                    "<F33>",
                    breakpoint.clear_all_breakpoints,
                    desc = "Debugger: Clear All Breakpoints",
                },
            }
            return vim.tbl_deep_extend("force", default_keys, keys)
        end,
    },

    -- fancy UI for the debugger
    {
        "igorlfs/nvim-dap-view",
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dap-view").toggle({ }) end, desc = "Dap UI" },
          { "<leader>de", function() require("dap-view").add_expr() end, desc = "Watch", mode = {"n", "x"} },
        },
        opts = {},
        config = function(_, opts)
            local dap = require "dap"
            local dapview = require "dap-view"
            dapview.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapview.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapview.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapview.close()
            end
        end,
    },
}
