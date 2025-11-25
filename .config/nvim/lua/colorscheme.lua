-------------------------------
-- Colorscheme Configuration --
-------------------------------

-- Define colorscheme
local colorscheme = 'nord'

local isInstalled, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not isInstalled then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end
