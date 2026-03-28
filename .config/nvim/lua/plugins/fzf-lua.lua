---@module "lazy"

---@type fzf-lua.Config
local fzf_opts = {
    files = {
        follow = true,
        -- path_shorten = 1,
        git_icons = true,
        formatter = "path.filename_first"
    }
}
---@type LazyPlugin
---@diagnostic disable:missing-fields
return {
    "ibhagwan/fzf-lua",
    event = {"VeryLazy"},
    config = function()
        local fzf = require("fzf-lua")
        fzf.setup(fzf_opts)

        local keymap = vim.keymap
        ---@type vim.keymap.set.Opts
        local opts = { noremap = true, silent = true}

        opts.desc = "Show files"
        keymap.set("n", "Ff", fzf.files, opts)
        opts.desc = "Show buffers"
        keymap.set("n", "Fb", fzf.buffers, opts)
        opts.desc = "Open config file"
        keymap.set("n", "Fc", function() fzf.files({cwd = "~/.config/nvim"}) end, opts)
        opts.desc = "Live grep project"
        keymap.set("n", "Fg", function() fzf.live_grep({cmd = "rg -."}) end, opts)
        opts.desc = "Visual grep project"
        keymap.set("v", "Fg", function() fzf.grep_visual({cmd = "rg -."}) end, opts)
        opts.desc = "Resume FZF"
        keymap.set("n", "Fr", fzf.resume, opts)
        opts.desc = "Complete path"
        keymap.set({ "n", "v", "i" }, "<C-\\>", fzf.complete_path, opts)

        vim.api.nvim_create_autocmd({"LspAttach"}, {
            callback = function ()
                opts.desc = "show references in fzf"
                keymap.set("n", "<leader>rr", fzf.lsp_references, opts)
            end
        })
    end,
}
