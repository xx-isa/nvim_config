---@type string
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

---@type string
local home = vim.env.HOME

---@type string
local workspace_dir = home .. '/.jdtls/data/' .. project_name

---@type string
local jdtls = home .. "/src/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/"

---@type string
local jar = jdtls .. 'plugins/org.eclipse.equinox.launcher_1.7.100.v20251111-0406.jar'

---@type vim.lsp.Config
return {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1G',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        ---
        '-javaagent:' .. home .. '/.jdtls/lombok.jar',
        ---
        '-jar',  jar,
        ---
        '-configuration', jdtls .. 'config_linux',
        ---
        '-data', workspace_dir
    },
    root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew"}),
    settings = {
        java = {

        }
    },
    init_options = {
        bundles = {}
    },
}
