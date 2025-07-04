local function run_nearest_test()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  
  -- Extract class name from file path
  local class_name = filepath:match("([^/]+)%.scala$")
  if not class_name then
    print("Not a Scala file")
    return
  end
  
  -- Extract module name from path
  local module_name = filepath:match("/modules/([^/]+)/src/")
  if not module_name then
    print("Could not determine module name from path")
    return
  end
  
  -- Find all test methods in the file
  local tests = {}
  for i, line in ipairs(lines) do
    local test_match = line:match('test%s*%(%s*"([^"]+)"')
    if test_match then
      table.insert(tests, {
        name = test_match,
        line = i,
        distance = math.abs(i - cursor_line)
      })
    end
  end
  
  if #tests == 0 then
    print("No tests found in current file")
    return
  end
  
  -- Find closest test
  table.sort(tests, function(a, b) return a.distance < b.distance end)
  local closest_test = tests[1]
  
  -- Build sbt command
  local sbt_cmd = string.format('sbt "%s/testOnly *%s -- -z \\"%s\\""', 
                                module_name, class_name, closest_test.name)
  
  print("Running: " .. sbt_cmd)
  vim.cmd("terminal " .. sbt_cmd)
end

-- Set up the keybinding
vim.keymap.set('n', '<leader>tt', run_nearest_test, { 
  desc = 'Run nearest test',
  silent = true 
})

return {
  run_nearest_test = run_nearest_test
}
