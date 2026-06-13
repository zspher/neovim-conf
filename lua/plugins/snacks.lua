-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">"
      or vim.schedule(function() vim.cmd.wincmd(dir) end)
  end
end

---@module 'snacks'
---@type LazySpec[]
return {
  {
    "snacks.nvim",
    opts = {
      indent = { enabled = true },
      dashboard = { enabled = false },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      toggle = { enabled = true },
      words = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
    },
    keys = {},
  },

  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      ---@type table<string, snacks.win.Config>
      styles = {},
      indent = {
        scope = {
          hl = "SnacksIndent1",
        },
      },
      image = {
        math = { enabled = false },
        doc = {
          inline = false,
        },
        markdown = { enabled = true },
        max_width = 20,
        max_height = 10,
      },
      terminal = {
        win = {
          keys = {
            nav_h = {
              "<C-h>",
              term_nav "h",
              desc = "Go to Left Window",
              expr = true,
              mode = "t",
            },
            nav_j = {
              "<C-j>",
              term_nav "j",
              desc = "Go to Lower Window",
              expr = true,
              mode = "t",
            },
            nav_k = {
              "<C-k>",
              term_nav "k",
              desc = "Go to Upper Window",
              expr = true,
              mode = "t",
            },
            nav_l = {
              "<C-l>",
              term_nav "l",
              desc = "Go to Right Window",
              expr = true,
              mode = "t",
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer" },
      { "<leader>ft", function() Snacks.terminal() end, desc = "Terminal (cwd)" },
      { "<c-/>", function() Snacks.terminal() end, desc = "Terminal (cwd)", mode = { "n", "t" } },
    },
  },

  -- snacks toggles
  {
    "snacks.nvim",
    opts = function()
      Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
      Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
      Snacks.toggle
        .option("relativenumber", { name = "Relative Number" })
        :map "<leader>uL"
      Snacks.toggle.diagnostics():map "<leader>ud"
      Snacks.toggle.line_number():map "<leader>ul"
      Snacks.toggle
        .option("conceallevel", {
          off = 0,
          on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
          name = "Conceal Level",
        })
        :map "<leader>uc"
      Snacks.toggle.treesitter():map "<leader>uT"
      Snacks.toggle.dim():map "<leader>uD"
      Snacks.toggle.indent():map "<leader>ug"
      Snacks.toggle.scroll():map "<leader>uS"
      Snacks.toggle.profiler():map "<leader>dpp"
      Snacks.toggle.profiler_highlights():map "<leader>dph"
      Snacks.toggle.zen():map "<leader>uz"

      Snacks.toggle({
        name = "autoformat",
        get = function() return not vim.g.disable_autoformat end,
        set = function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end,
      }):map "<leader>uF"

      Snacks.toggle({
        name = "buffer autoformat",
        get = function()
          return not vim.b[vim.api.nvim_get_current_buf()].disable_autoformat
        end,
        set = function()
          local buf = vim.api.nvim_get_current_buf()
          vim.b[buf].disable_autoformat = not vim.b[buf].disable_autoformat
        end,
      }):map "<leader>uf"
    end,
  },

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
        actions = {
          trouble_open = function(...)
            -- stylua: ignore
            return require("trouble.sources.snacks").actions.trouble_open.action(...)
          end,
        },
        win = {
          input = {
            keys = {
              ["<a-t>"] = {
                "trouble_open",
                mode = { "n", "i" },
              },
            },
          },
        },
      },
    },

    -- stylua: ignore
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
      { "<leader>bi", function() Snacks.bufdelete.invisible() end, desc = "Delete Invisible Buffers" },

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
  },
}
