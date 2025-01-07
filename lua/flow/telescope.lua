local cmd = require("flow.cmd")
local run_custom_cmd = require("flow").run_custom_cmd
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function custom_cmds()
  return function(opts)
    local custom_cmd_list = cmd.get_custom_cmds()
    opts = opts or require("telescope.themes").get_dropdown {}
    pickers.new(opts, {
      prompt_title = "Custom commands",
      finder = finders.new_table {
        results = custom_cmd_list,
        entry_maker = function(entry)
          return {
            value = string.format(CUSTOM_CMD_FILE_NAME_TMPL, entry),
            display = entry,
            ordinal = entry,
          }
        end
      },
      previewer = conf.file_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          -- if an existing command is selected, it should be executed. Else, a
          -- new command sould be created with that name
          if selection ~= nil then
            run_custom_cmd(selection.ordinal)
            return
          end

          cmd.set_custom_cmd(action_state.get_current_line())
        end)

        map("i", "<c-e>", function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          cmd.set_custom_cmd(selection.ordinal)
        end)

        map("i", "<c-d>", function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          cmd.delete_custom_cmd(selection.ordinal)
        end)
        return true
      end,
    }):find()
  end
end

return {
  custom_cmds = custom_cmds()
}
