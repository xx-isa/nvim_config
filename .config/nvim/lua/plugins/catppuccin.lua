local opts = {
    flavour = "frappe",
    background = {
        light = "latte",
        dark = "frappe",
    },
    transparent_background = true,
    custom_highlights = function(colors)
        return {
            NormalFloat = { bg = colors.surface0 },
            FloatBorder = { bg = colors.surface0 },
            CursorLine = { bg = colors.surface0 },
            Pmenu = { bg = colors.surface0 },
            LineNr = { fg = colors.overlay2 },
        }
    end,
}
return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = opts,
}
