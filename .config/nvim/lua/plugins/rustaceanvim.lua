return {
    "mrcjkb/rustaceanvim",
    enabled = true,
    init = function()
        vim.g.rustaceanvim = {
            tools = {
                float_win_config = {
                    border = "rounded",
                },
            },
        }
    end,
}
