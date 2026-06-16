local function harpoon_to_buflist()
  local harpoon_list = require("harpoon"):list().items
  local cwd = vim.uv.cwd()
  local buflist = {}
  for _, v in ipairs(harpoon_list) do
    local file = vim.fs.normalize(cwd .. "/" .. v.value)
    local buf = vim.fn.bufnr(file, false)
    if buf ~= -1 then buflist[#buflist + 1] = buf end
  end
  return buflist
end

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
          { "<leader>gh", group = "git stage" },
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
          {
            "<leader>h",
            group = "harpoon",
            icon = { cat = "filetype", name = "harpoon" },
            expand = function()
              local ret = {} ---@type wk.Spec[]

              -- harpoon lists start at 1 and which-key expand starts at 0
              ret[#ret + 1] = { cond = false }
              for i, item in ipairs(require("harpoon"):list().items) do
                ret[#ret + 1] = {
                  "",
                  function() require("harpoon"):list():select(i) end,
                  desc = item.value,
                  icon = { cat = "file", name = item.value },
                }
              end

              ret = vim.list_slice(ret, 1, 10)
              for i, v in ipairs(ret) do
                v[1] = tostring(i - 1)
              end
              return ret
            end,
          },
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

  -- explorer
  {
    "barrettruth/canola.nvim",
    lazy = vim.fn.argc(-1) == 0,
    branch = "canola",
    dependencies = {
      "barrettruth/canola-collection",
    },
    init = function()
      vim.g.canola = {
        columns = {
          "git_status",
          "icon",
          -- "permissions",
        },
        confirm = "delete",
        hidden = { enabled = false },
        keymaps = {
          ["C-h"] = false,
          ["<A-h>"] = {
            callback = "actions.select",
            opts = { horizontal = true },
          },
          ["C-l"] = false,
          ["<A-l>"] = "actions.refresh",
        },
      }
      vim.g.canola_git = {
        format = "symbol",
      }
      vim.g.canola_ssh = {}
      vim.g.canola_trash = {}
    end,
    keys = {
      {
        "<leader>e",
        function() require("canola").toggle() end,
        desc = "Explorer (Current Dir)",
      },
    },
  },
  {
    "zspher/harpoon",
    opts = {
      settings = {
        save_on_toggle = true,
      },
    },
    config = function(_, opts)
      local harpoon = require "harpoon"
      local extensions = require "harpoon.extensions"
      harpoon:setup(opts)
      harpoon:extend(extensions.builtins.navigate_with_number())
    end,
    keys = {
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
          local buflist = harpoon_to_buflist()
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

        Snacks.toggle({
          name = "Git Signs",
          get = function() return require("gitsigns.config").config.signcolumn end,
          set = function(state) require("gitsigns").toggle_signs(state) end,
        }):map "<leader>uG"

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
        map("n", "<leader>gb", function() gs.blame() end, "Blame Buffer")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")

        map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      end,
    },
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
        show_all_diags_on_cursorline = true,
        show_diags_only_under_cursor = true,
        show_source = {
          if_many = true,
        },
        multilines = {
          enabled = true,
        },
      },
    },
  },

  -- better comments
  {
    "zspher/todo-comments.nvim",
    lazy = false,
    cmd = { "TodoTrouble" },
    opts = {},
    keys = {
      { "<leader>xT", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      {
        "<leader>xt",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
        desc = "Todo/Fix/Fixme (Trouble)",
      },
    },
  },

  -- runner
  {
    "stevearc/overseer.nvim",
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {
      dap = false,
      task_list = {
        render = function(task)
          local render = require "overseer.render"

          return {
            render.status_and_name(task),
            render.join(render.duration(task), {
              ---@diagnostic disable-next-line: assign-type-mismatch
              { os.date("%H:%M:%S", task.time_end), "Comment" },
            }),
          }
        end,
      },
    },
    keys = {
      {
        "<leader>ct",
        "<Cmd>OverseerRun<CR>",
        desc = "Run Task",
      },
      {
        "<leader>cT",
        function()
          local overseer = require "overseer"
          local task_list = require "overseer.task_list"
          local tasks = overseer.list_tasks {
            status = {
              overseer.STATUS.SUCCESS,
              overseer.STATUS.FAILURE,
              overseer.STATUS.CANCELED,
            },
            sort = task_list.sort_finished_recently,
          }
          if vim.tbl_isempty(tasks) then
            vim.cmd "OverseerRun"
          else
            local most_recent = tasks[1]
            overseer.run_action(most_recent, "restart")
          end
        end,
        desc = "Restart Task",
      },
      {
        "<leader>co",
        "<Cmd>OverseerToggle<CR>",
        desc = "Show Task Output",
      },
    },
  },
}
