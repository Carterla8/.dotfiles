return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon").setup()

    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    -- Your keybinds with <leader>m
    vim.keymap.set("n", "<leader>ma", mark.add_file, { desc = "Harpoon add file" })
    vim.keymap.set("n", "<leader>me", ui.toggle_quick_menu, { desc = "Harpoon explorer" })

    -- Jump to specific files
    vim.keymap.set("n", "<leader>m1", function()
      ui.nav_file(1)
    end, { desc = "Harpoon file 1" })
    vim.keymap.set("n", "<leader>m2", function()
      ui.nav_file(2)
    end, { desc = "Harpoon file 2" })
    vim.keymap.set("n", "<leader>m3", function()
      ui.nav_file(3)
    end, { desc = "Harpoon file 3" })
    vim.keymap.set("n", "<leader>m4", function()
      ui.nav_file(4)
    end, { desc = "Harpoon file 4" })

    -- Navigate through list
    vim.keymap.set("n", "<leader>mn", ui.nav_next, { desc = "Harpoon next" })
    vim.keymap.set("n", "<leader>mp", ui.nav_prev, { desc = "Harpoon prev" })
  end,
}
