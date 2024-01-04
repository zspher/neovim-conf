local prefix = "<leader>r"
return {
    {

        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                [prefix] = { name = "+run/task", mode = "n" },
            },
        },
    },
    {
        "michaelb/sniprun",
        build = "bash ./install.sh 1",
        opts = {
            interpreter_options = {
                Generic = {
                    racket_config = {
                        supported_filetypes = { "racket" },
                        extension = ".rkt",
                        interpreter = "racket",
                        boilerplate_pre = "#lang racket",
                    },
                },
            },
            inline_messages = true,
        },
        keys = {
            { prefix .. "r", "<Plug>SnipRunOperator", desc = "REPL: Run" },
            { prefix .. "c", "<Plug>SnipClose", desc = "REPL: Clear" },
            { prefix .. "l", "<Plug>SnipRun", desc = "REPL: Run line" },
            { prefix, "<Plug>SnipRun", desc = "REPL: Run", mode = { "v" } },
        },
    },
    {
        "stevearc/overseer.nvim",
        cmd = {
            "OverseerOpen",
            "OverseerClose",
            "OverseerToggle",
            "OverseerSaveBundle",
            "OverseerLoadBundle",
            "OverseerDeleteBundle",
            "OverseerRunCmd",
            "OverseerRun",
            "OverseerInfo",
            "OverseerBuild",
            "OverseerQuickAction",
            "OverseerTaskAction ",
            "OverseerClearCache",
        },
        opts = {
            task_list = { default_detail = 2 },
            component_aliases = {
                -- Most tasks are initialized with the default components
                default = {
                    { "display_duration" },
                    { "on_output_summarize" },
                    "on_exit_set_status",
                    "on_complete_notify",
                    "on_complete_dispose",
                    { "on_output_quickfix" },
                },
            },
        },
        keys = {
            {
                prefix .. "o",
                "<Cmd>OverseerToggle<cr>",
                desc = "Task: Open",
            },
            { prefix .. "t", "<Cmd>OverseerRun<cr>", desc = "Task: Run" },
            {
                prefix .. "s",
                function()
                    local overseer = require "overseer"
                    local tasks = overseer.list_tasks { recent_first = true }
                    if vim.tbl_isempty(tasks) then
                        vim.notify("No tasks found", vim.log.levels.WARN)
                    else
                        overseer.run_action(tasks[1], "restart")
                    end
                end,
                desc = "Task: Restart",
            },
        },
    },
}
