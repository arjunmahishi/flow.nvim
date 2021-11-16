local lng = require('run-code.language')

function run()
  -- TODO:
  --    [DONE] assert if the file is md
  --    [DONE] get text from current buffer
  --    [DONE] parse the file to get all the code blocks
  --    [DONE] select the current code block
  --    - execute block and print the output

  -- currently only markdown files are supported
  if vim.bo.filetype ~= "markdown" then
    print("This is currently only supported in markdown")
    return
  end

  local lines = lines_from_current_buffer()
  local blocks = code_blocks_in_lines(lines)
  local block = select_block(blocks)

  if block == nil then
    print("You are not on any code block")
    return
  end
  print(vim.inspect(block))
end

-- returns a table containing { {block}, start_line, end_line }
-- where each block is a string containing the snippet of code 
-- contained in the block
--
-- ASSUMPTION: the block will start and end with 3 backticks in a line with nothing else
-- TODO: handle edge cases like inline blocks etc
function code_blocks_in_lines(lines)
  local blocks = {}

  local block_started = false
  local start_line = -1
  local curr_block = {}
  for k, v in pairs(lines) do
    v0 = v:gsub("%s+", "") -- remove whitespaces
    if v0:sub(0, 3) == '```' then
      if not block_started then -- handle opening backticks
        block_started = true 
        start_line = k + 1
      else -- handle closing backticks
        text = table.concat(curr_block, "\n")
        blocks[#blocks + 1] = { text = text, start_line = start_line, end_line = k - 1 }

        -- house keeping
        block_started = false
        curr_block = {}
        start_line = -1
      end
    else -- handle regular line
      if block_started then
        curr_block[#curr_block + 1] = v
      end
    end
  end

  return blocks
end

-- return the selected block based on the cursor location
function select_block(blocks)
  local curr_win = vim.api.nvim_get_current_win()
  local curr_line = vim.api.nvim_win_get_cursor(curr_win)[1]

  for _, block in pairs(blocks) do
    if curr_line >= block.start_line - 1 and curr_line <= block.end_line + 1 then
      return block
    end
  end

  return nil
end

-- returns a table containing every line in the file
function lines_from_current_buffer()
  local curr_buff = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(curr_buff)

  return vim.api.nvim_buf_get_lines(curr_buff, 0, line_count, false)
end

function reload_plugin()
  package.loaded['run-code'] = nil
  print "reloaded run-code"
end

function str_split(s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end
  return result
end

return {
  run = run,
  reload_plugin = reload_plugin
}
