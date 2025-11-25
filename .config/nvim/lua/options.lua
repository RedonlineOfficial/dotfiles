-- -------------- --
-- Neovim Options --
-- -------------- --

-- General
vim.opt.clipboard = 'unnamedplus'       -- Use system clipboard
vim.opt.mouse = 'a'                     -- Enables mouse support

-- Completion
-- Options:
--      - menu: provides a menu when selecting completions
--      - menuone: Shows a menu even if only one entry is present
--      - noselect: does not require the user to select the first option
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Tab
vim.opt.tabstop = 4                     -- Number of visual spaces per tab
vim.opt.softtabstop = 4                 -- Number of spaces in tab when editing
vim.opt.shiftwidth = 4                  -- Insert 4 spaces with tab
vim.opt.expandtab = true                -- Tabs use spaces

-- UI Config
vim.opt.number = true                   -- Shows a numberline on the left side
vim.opt.relativenumber = true           -- Makes the numberline relative to current line
vim.opt.cursorline = true               -- Highlight the current line the cursor is on
vim.opt.splitbelow = true               -- Opens new vertical window below
vim.opt.splitright = true               -- Opens new horizontal window to the right
vim.opt.showmode = false                -- Removes the current mode in bottom bar

-- Searching & Highlighting
vim.opt.incsearch = true                -- Search incrementally as characters are entered
vim.opt.hlsearch = false                -- Do not highlight matches
vim.opt.ignorecase = true               -- Ignore case when searching
vim.opt.smartcase = true                -- Make it case sensitive if an uppercase is entered
