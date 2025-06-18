-- ~/.config/nvim/lua/plugins/metals.lua
return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap", -- for debugging
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        testUserInterface = "Test Explorer",
      }
      metals_config.init_options.statusBarProvider = "on"
      
      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
        
        local map = vim.keymap.set
        
        -- Test running (your main ones)
        map("n", "<leader>tc", function()
          require("metals").test_class()
        end, { desc = "Test class", buffer = bufnr })
        
        map("n", "<leader>tf", function()
          require("metals").test_file()
        end, { desc = "Test file", buffer = bufnr })
        
        map("n", "<leader>tt", function()
          require("metals").test_nearest()
        end, { desc = "Test nearest", buffer = bufnr })
        
        map("n", "<leader>ts", function()
          require("metals").test_suite()
        end, { desc = "Test suite", buffer = bufnr })
        
        -- Debug test
        map("n", "<leader>td", function()
          require("metals").test_debug_nearest()
        end, { desc = "Debug nearest test", buffer = bufnr })
        
        -- Test in popup (your new one)
        map("n", "<leader>tp", function()
          local cmd = "sbt test"
          require("lazyvim.util").terminal.open(cmd, { 
            cwd = vim.fn.getcwd(),
            size = { width = 0.8, height = 0.8 }
          })
        end, { desc = "Test nearest in popup", buffer = bufnr })
        
        -- Other Metals features
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
