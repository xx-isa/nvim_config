local M = {}

M.colorscheme = "catppuccin"

-- :h lspconfig-all
M.lsp_servers = {
    "lua_ls",
    "clangd",
    -- "pyright",
    -- "dockerls",
    -- "bashls",
    -- "jdtls",
    -- "hls",
}

M.ts_parsers = {
    "python",
    "haskell",
    "java",
    "rust"
}

return M
