---------------------
-- Neopywal Config --
---------------------

return {
    require("neopywal").setup({
        transparent_background = true,
    }),

    vim.cmd.colorscheme("neopywal"),
}
