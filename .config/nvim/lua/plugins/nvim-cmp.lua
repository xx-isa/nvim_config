local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local supertab = function(fallback, cmp)
    if cmp.visible() then
        -- if #cmp.get_entries() == 1 then 
        --     cmp.confirm({select = true })
        -- end
        cmp.select_next_item()
    elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
    -- elseif has_words_before() then
    --     cmp.complete()
    else
        fallback()
    end
end

local reverse_tab = function(fallback, cmp)
    if cmp.visible() then
        cmp.select_prev_item()
    elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
    else
        fallback()
    end
end

return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "chrisgrieser/cmp-nerdfont",
        "onsails/lspkind.nvim",
        'hrsh7th/cmp-nvim-lsp-signature-help',
        {
            'hrsh7th/cmp-vsnip',
            dependencies = {
                'hrsh7th/vim-vsnip',
                dependencies = { "rafamadriz/friendly-snippets" }
            }
        },
        "neotab.nvim"
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup {
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                    --require("luasnip").lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4)
                , ["<C-f>"] = cmp.mapping.scroll_docs(4)
                , ["<C-Space>"] = cmp.mapping.complete()
                , ["<C-e>"] = cmp.mapping.abort()
                , ["<Right>"] = cmp.mapping.abort()
                , ["<CR>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                })
                -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                , ["<Tab>"] = cmp.mapping(
                    (function(fallback) supertab(fallback, cmp) end)
                    , { "i", "s" })
                , ["<S-Tab>"] = cmp.mapping(
                    (function(fallback) reverse_tab(fallback, cmp) end)
                    , { "i", "s" })
                }),

            formatting = {
                format = function(entry, vim_item)
                    if vim.tbl_contains({ "path" }, entry.source.name) then
                        local icon, hl_group = require('nvim-web-devicons').get_icon(entry.completion_item.label)
                        if icon then
                            vim_item.kind = icon
                            vim_item.kind_hl_group = hl_group
                            return vim_item
                        end
                    end
                    return require("lspkind").cmp_format({
                        mode = 'symbol_text',
                    })(entry, vim_item)
                end
            },

            sources = cmp.config.sources(
                {
                    { name = "nvim_lsp_signature_help" },
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    -- { name = "nerdfont" }
                },
                {
                    { name = "buffer" },
                }
            ),
        }

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" }
            },
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })

        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        cmp.event:on(
            "confirm_done",
            cmp_autopairs.on_confirm_done()
        )
    end
}
