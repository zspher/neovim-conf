local oil_detail = false

-- NOTE: development stuff, git, keymap hint, explorer, floating windows

---@module 'snacks'
---@type LazySpec[]
return {
  -- key help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "modern",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function() return require("which-key.extras").expand.buf() end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function() return require("which-key.extras").expand.win() end,
          },
          { "<leader>t", group = "test" },
          { "<leader>r", group = "refactor" },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function() require("which-key").show { keys = "<c-w>", loop = true } end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
  },

  -- picker and co
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        previewers = {
          diff = {
            builtin = false,
          },
          git = {
            builtin = false,
          },
        },
      },
    },
    -- stylua: ignore start
    keys = {
      -- NOTE: git
      { "<leader>gb", function() Snacks.picker.git_log_line() end, desc = "Git Blame Line" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse (open)", mode = { "n", "x" } },
      { "<leader>gY", function() Snacks.gitbrowse({open = function(url) vim.fn.setreg("+", url) end, notify = false}) end, desc = "Git Browse (copy)", mode = {"n", "x" } },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit (Root Dir)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Current File History" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },

      -- NOTE: buffer
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bo", function()
        local tab_buflist = vim.fn.tabpagebuflist()
        Snacks.bufdelete(function(buf) return not vim.list_contains(tab_buflist, buf) end)
      end, desc = "Delete Buffers other than the current layout" },
      { "<leader>bO", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },

      -- NOTE: picker
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader><space>",function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- git
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sw", function() Snacks.picker.grep_word() end,  desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    },
    -- stylua: ignore end
  },

  -- explorer
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      skip_confirm_for_simple_edits = true,
      delete_to_trash = true,
      keymaps = {
        ["q"] = "actions.close",
        ["<C-h>"] = false,
        ["<A-h>"] = "actions.select_split",
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            oil_detail = not oil_detail
            if oil_detail then
              require("oil").set_columns {
                "permissions",
                { "size", highlight = "Comment" },
                { "mtime", highlight = "Conceal" },
                "icon",
              }
            else
              require("oil").set_columns { "icon" }
            end
          end,
        },
      },
      view_options = {
        show_hidden = true,
        highlight_filename = function(entry, _, _, _)
          local state = vim.uv.fs_stat(entry.name)
          if state and state.type == "file" then
            local perms = string.format("%o", bit.band(state.mode, 511))
            local l = { "1", "3", "5", "7" }
            for _, v in ipairs(l) do
              if perms:match(v) then return "Error" end
            end
          end
          return nil
        end,
      },
      win_options = {
        signcolumn = "yes",
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            require("snacks").rename.on_rename_file(
              event.data.actions.src_url,
              event.data.actions.dest_url
            )
          end
        end,
      })
    end,
    keys = {
      {
        "<leader>e",
        function()
          if vim.bo.ft == "oil" then
            require("oil").close()
          else
            require("oil").open(nil)
          end
        end,
        desc = "Explorer (Current Dir)",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      settings = {
        save_on_toggle = true,
        key = function() return vim.uv.cwd() end,
      },
      default = {
        get_root_dir = function() return vim.uv.cwd() end,
      },
    },
    config = function(_, opts)
      local harpoon = require "harpoon"
      local extensions = require "harpoon.extensions"
      harpoon:setup(opts)
      harpoon:extend(extensions.builtins.navigate_with_number())
    end,
    keys = {
      { "<leader>h", "", desc = "+harpoon", mode = { "n" } },
      {
        "<leader>ha",
        function() require("harpoon"):list():add() end,
        desc = "Add file",
      },
      {
        "<leader>he",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list(), {
            border = "rounded",
            title_pos = "center",
            title = " Harpoon ",
            ui_max_width = 100,
          })
        end,
        desc = "Toggle quick menu",
      },
      {
        "<C-p>",
        function() require("harpoon"):list():prev { ui_nav_wrap = true } end,
        desc = "Goto previous mark",
      },
      {
        "<C-n>",
        function() require("harpoon"):list():next { ui_nav_wrap = true } end,
        desc = "Goto next mark",
      },
      {
        "<leader>bh",
        function()
          local harpoon_list = require("harpoon"):list().items
          local cwd = vim.uv.cwd()
          local buflist = {}
          for _, v in ipairs(harpoon_list) do
            local file = cwd .. "/" .. v.value
            local buf = vim.fn.bufnr(file, false)
            if buf ~= -1 then buflist[#buflist + 1] = buf end
          end
          vim.list_extend(buflist, vim.fn.tabpagebuflist())

          Snacks.bufdelete.delete {
            filter = function(buf) return not vim.tbl_contains(buflist, buf) end,
          }
        end,
        desc = "Delete Buffers other than in harpoon list",
      },
    },
  },

  -- git stuff
  {
    "refractalize/oil-git-status.nvim",
    config = true,
    keys = {
      {
        "<leader>e",
        function()
          if vim.bo.ft == "oil" then
            require("oil").close()
          else
            require("oil").open(nil)
          end
        end,
        desc = "Explorer (Current Dir)",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(
            mode,
            l,
            r,
            { buffer = buffer, desc = desc, silent = true }
          )
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "gitsigns.nvim",
    opts = function()
      Snacks.toggle({
        name = "Git Signs",
        get = function() return require("gitsigns.config").config.signcolumn end,
        set = function(state) require("gitsigns").toggle_signs(state) end,
      }):map "<leader>uG"
    end,
  },

  -- better diagnostics
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    ---@module "trouble"
    ---@type trouble.Config
    opts = {
      modes = {
        diagnostics = {
          filter = function(items)
            return vim.tbl_filter(
              function(item)
                return not string.match(item.basename, [[%__virtual.cs$]])
              end,
              items
            )
          end,
        },
        lsp = {
          win = { position = "right" },
        },
      },
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cS",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP references/definitions/... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            ---@diagnostic disable-next-line: missing-parameter, missing-fields
            require("trouble").prev {
              skip_groups = true,
              jump = true,
            }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            ---@diagnostic disable-next-line: missing-fields, missing-parameter
            require("trouble").next {
              skip_groups = true,
              jump = true,
            }
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      preset = "classic",
      transparent_bg = true,
      signs = {
        arrow = "",
      },
      options = {
        show_source = {
          if_many = true,
        },
        multilines = {
          enabled = true,
          always_show = true,
        },
      },
    },
  },

  -- better comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {},
    keys = {
      {
        "]t",
        function() require("todo-comments").jump_next() end,
        desc = "Next Todo Comment",
      },
      {
        "[t",
        function() require("todo-comments").jump_prev() end,
        desc = "Previous Todo Comment",
      },
      { "<leader>xT", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      {
        "<leader>xt",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
        desc = "Todo/Fix/Fixme (Trouble)",
      },
    },
  },
}
