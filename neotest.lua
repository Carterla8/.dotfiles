-- Add this to your LazyVim neotest config (usually in ~/.config/nvim/lua/plugins/neotest.lua)
-- Or create ~/.config/nvim/lua/config/neotest.lua and require it

-- Helper functions for SBT multi-module support
local function find_sbt_root(path)
  local current = path
  while current ~= "/" do
    if vim.fn.filereadable(current .. "/build.sbt") == 1 then
      return current
    end
    current = vim.fn.fnamemodify(current, ":h")
  end
  return nil
end

local function get_module_name(file_path)
  local sbt_root = find_sbt_root(file_path)
  if not sbt_root then
    return nil
  end
  
  local modules_dir = sbt_root .. "/modules"
  if string.find(file_path, modules_dir, 1, true) then
    local relative_path = string.sub(file_path, string.len(modules_dir) + 2)
    local module_name = string.match(relative_path, "([^/]+)")
    return module_name
  end
  
  return nil
end

-- If you have an existing neotest config, just modify the scala adapter:
return {
  "nvim-neotest/neotest",
  dependencies = {
    "stevanmilic/neotest-scala",
  },
  opts = {
    adapters = {
      ["neotest-scala"] = {
        command = function(position)
          local file_path = position.path
          local sbt_root = find_sbt_root(file_path)
          local module_name = get_module_name(file_path)
          
          if not sbt_root then
            return { "sbt", "test" }
          end
          
          vim.cmd("cd " .. sbt_root)
          
          if module_name then
            if position.type == "test" then
              return { "sbt", module_name .. "/testOnly *" .. position.name .. "*" }
            elseif position.type == "file" then
              local class_name = vim.fn.fnamemodify(position.path, ":t:r")
              return { "sbt", module_name .. "/testOnly *" .. class_name .. "*" }
            else
              return { "sbt", module_name .. "/test" }
            end
          else
            return { "sbt", "test" }
          end
        end,
        
        cwd = function(path)
          return find_sbt_root(path) or vim.fn.getcwd()
        end,
        
        framework = "munit", -- Adjust to your framework
        root_pattern = { "build.sbt", "project/build.properties" },
      },
    },
  },
}
