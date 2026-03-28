local toggle_hints = function ()
    local enable = not vim.lsp.inlay_hint.is_enabled();
    vim.lsp.inlay_hint.enable(enable)
end

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "mason-org/mason.nvim"
        },
        config = function()
            local utils = require("utils")
            local mason_lspconfig = require("mason-lspconfig")
            require("mason").setup()
            mason_lspconfig.setup({
                ensure_installed = utils.lsp_servers,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config('*', {
                capabilities = capabilities
            })

            local keymap = vim.keymap
            local opts = { noremap = true, silent = true }

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    opts.buffer = args.buf

                    opts.desc = "Show code actions ~/"
                    keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
                    keymap.set({ "i" }, "<C-\\>a", vim.lsp.buf.code_action, opts)
                    opts.desc = "Show line diagnostics"
                    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                    opts.desc = "Smart rename"
                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    opts.desc = "Show signature help"
                    keymap.set("n", "<leader>H", vim.lsp.buf.signature_help, opts)
                    opts.desc = "Format code"
                    keymap.set({ "n", "v" }, "<leader>fmt", vim.lsp.buf.format, opts)
                    opts.desc = "Toggle Inlay Hints"
                    keymap.set({"n"}, "<leader>h", toggle_hints, opts)
                end,
            })

            vim.lsp.handlers["textDocument/publishDiagnostics"] =
                vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    update_in_insert = true,
                })
        end,
    },
}
