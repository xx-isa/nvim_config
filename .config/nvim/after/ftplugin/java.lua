local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local home = vim.env.HOME

local workspace_dir = home .. '/.jdtls/data/' .. project_name



local config = {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        ---
        '-javaagent:' .. home .. '/.jdtls/lombok.jar',
        ---
        '-jar',  home .. '/src/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar',
        ---
        '-configuration', home .. '/src/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux',
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

require('jdtls').start_or_attach(config)
