local cmd = require("run-code.cmd")
local run_custom_cmd = require("run-code").run_custom_cmd
local pickers = require("telescope.pickers")
local finders = require ("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function custom_cmds()
  local custom_cmd_list = cmd.get_custom_cmds()

  return function(opts)
    opts = opts or require("telescope.themes").get_dropdown{}
    pickers.new(opts, {
      prompt_title = "Custom commands",
      finder = finders.new_table {
        results = custom_cmd_list
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          run_custom_cmd(selection[1])
        end)
        map("i", "<c-e>", function ()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          cmd.set_custom_cmd(selection[1])
        end)
        return true
      end,
    }):find()
  end
end

return {
  custom_cmds = custom_cmds()
}
