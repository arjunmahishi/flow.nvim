local md = {}

-- returns a table containing { {block}, start_line, end_line }
-- where each block is a string containing the snippet of code 
-- contained in the block
--
-- ASSUMPTION: the block will start and end with 3 backticks in a line with nothing else
-- TODO: handle edge cases like inline blocks etc
md.code_blocks_in_lines = function(lines)
  local blocks = {}

  local block_started = false
  local start_line = -1
  local curr_block = {}
  local lang = ""
  for k, v in pairs(lines) do
    v0 = v:gsub("%s+", "") -- remove whitespaces
    if v0:sub(0, 3) == '```' then
      if not block_started then -- handle opening backticks
        block_started = true 
        start_line = k + 1
        lang = v0:sub(4):gsub("%s+.*", "")
      else -- handle closing backticks
        code = table.concat(curr_block, "\n")
        blocks[#blocks + 1] = { code = code, start_line = start_line, end_line = k - 1, lang = lang }

        -- house keeping
        block_started = false
        curr_block = {}
        start_line = -1
        lang = ""
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
md.select_block = function(blocks)
  local curr_win = vim.api.nvim_get_current_win()
  local curr_line = vim.api.nvim_win_get_cursor(curr_win)[1]

  for _, block in pairs(blocks) do
    if curr_line >= block.start_line - 1 and curr_line <= block.end_line + 1 then
      return block
    end
  end

  return nil
end

return md
