-- ~/.config/nvim/lua/plugins/metals.lua
return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      
      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      -- Debug settings
      metals_config.init_options.statusBarProvider = "on"
      
      -- LSP mappings - these won't conflict with LazyVim's built-ins
      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
        
        -- Metals-specific commands
        local map = vim.keymap.set
        map("n", "<leader>cws", function()
          require("metals").hover_worksheet()
        end, { desc = "Metals worksheet hover", buffer = bufnr })
        
        map("n", "<leader>ctt", function()
          require("metals.tvp").toggle_tree_view()
        end, { desc = "Metals toggle tree view", buffer = bufnr })
        
        map("n", "<leader>ctr", function()
          require("metals.tvp").reveal_in_tree()
        end, { desc = "Metals reveal in tree", buffer = bufnr })
        
        map("n", "<leader>cmc", function()
          require("metals").commands()
        end, { desc = "Metals commands", buffer = bufnr })
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  }
}



-- Add to your metals config's on_attach function
map("n", "<leader>tt", function()
  -- This opens test output in a terminal window
  local test_cmd = require("metals").test_nearest_command()
  if test_cmd then
    vim.cmd("TermExec cmd='" .. test_cmd .. "'")
  end
end, { desc = "Test nearest in terminal", buffer = bufnr })
