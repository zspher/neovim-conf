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
    require("persistent-breakpoints.api").breakpoints_changed_in_current_buffer()
end

---@type LazySpec[]
return {
    {
        "Weissle/persistent-breakpoints.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        opts = {
            load_breakpoints_event = "BufRead",
            always_reload = true,
        },
        keys = {
            {
                "<leader>dB",
                edit_breakpoint,
                desc = "Breakpoint Condition",
            },
            {
                "<F9>",
                function()
                    require("persistent-breakpoints.api").toggle_breakpoint()
                end,
                desc = "Debugger: Toggle Breakpoint",
            },
            {
                "<F33>",
                function()
                    require("persistent-breakpoints.api").clear_all_breakpoints()
                end,
                desc = "Debugger: Clear All Breakpoints",
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "igorlfs/nvim-dap-view",
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
            "Weissle/persistent-breakpoints.nvim",
        },
        keys = {
            {
                "<leader>db",
                function() require("dap").toggle_breakpoint() end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>da",
                function()
                    require("persistent-breakpoints.api").load_breakpoints()
                    require("dap").continue { before = get_args }
                end,
                desc = "Run with Args",
            },
            {
                "<leader>dC",
                function() require("dap").run_to_cursor() end,
                desc = "Run to Cursor",
            },
            {
                "<leader>dg",
                function() require("dap").goto_() end,
                desc = "Go to Line (No Execute)",
            },
            {
                "<leader>di",
                function() require("dap").step_into() end,
                desc = "Step Into",
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
                "<leader>do",
                function() require("dap").step_out() end,
                desc = "Step Out",
            },
            {
                "<leader>dO",
                function() require("dap").step_over() end,
                desc = "Step Over",
            },
            {
                "<leader>dP",
                function() require("dap").pause() end,
                desc = "Pause",
            },
            {
                "<leader>dr",
                function() require("dap").repl.toggle() end,
                desc = "Toggle REPL",
            },
            {
                "<leader>ds",
                function() require("dap").session() end,
                desc = "Session",
            },
            {
                "<leader>dt",
                function() require("dap").terminate() end,
                desc = "Terminate",
            },
            {
                "<leader>dw",
                function() require("dap.ui.widgets").hover() end,
                desc = "Widgets",
            },
            {
                "<F5>",
                function()
                    require("persistent-breakpoints.api").load_breakpoints()
                    require("dap").continue()
                end,
                desc = "Debugger: Start",
            },
            {
                "<F17>",
                function() require("dap").terminate() end,
                desc = "Debugger: Stop",
            }, -- Shift+F5
            {
                "<F29>",
                function() require("dap").restart_frame() end,
                desc = "Debugger: Restart",
            }, -- Control+F5
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
                "<F23>",
                function() require("dap").step_out() end,
                desc = "Debugger: Step Out",
            }, -- Shift+F11
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
        },
        opts = {
            windows = {
                terminal = {
                    width = 0.4,
                    position = "right",
                },
            },
            winbar = {
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
                                local statusline =
                                    require "dap-view.util.statusline"

                                local session = require("dap").session()

                                if session == nil then
                                    return statusline.hl("", "ControlNC")
                                end

                                local supported =
                                    session.capabilities.supportsStepBack
                                return statusline.hl(
                                    "",
                                    supported and "ControlPlay" or "ControlNC"
                                )
                            end,
                            action = function()
                                if
                                    require("dap").session().capabilities.supportsStepBack
                                then
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
