----------------------------------
-- Oil Git Status Configuration --
----------------------------------

--- Keybinds ---
--- Settings ---
require('oil-git-status').setup({
    show_ignored = false, -- show files that match gitignore with !!
    symbols = { -- customize the symbols that appear in the git status columns
        index = {
            ["!"] = "!",
            ["?"] = "?",
            ["A"] = "A",
            ["C"] = "C",
            ["D"] = "D",
            ["M"] = "M",
            ["R"] = "R",
            ["T"] = "T",
            ["U"] = "U",
            [" "] = " ",
        },
        working_tree = {
            ["!"] = "!",
            ["?"] = "?",
            ["A"] = "A",
            ["C"] = "C",
            ["D"] = "D",
            ["M"] = "M",
            ["R"] = "R",
            ["T"] = "T",
            ["U"] = "U",
            [" "] = " ",
        },
    },
})
