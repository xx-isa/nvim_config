local bufnr = vim.api.nvim_get_current_buf()

local keymap = vim.keymap

local opts = {silent = true, buffer = bufnr}

opts.desc = "Mostra ações do código"
keymap.set(
    "n",
    "<leader>a",
    function()
        vim.cmd.RustLsp('codeAction')
    end,
    opts
)

-- vim.api.nvim_create_autocmd("CursorHold", {
--     buffer = bufnr,
--     callback = function ()
--         vim.cmd.RustLsp('hover', 'actions')
--     end
-- })
