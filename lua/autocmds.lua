require "nvchad.autocmds"
require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- Java configuration
autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true

    -- Java-specific keymaps
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set("n", "<leader>co", function()
      if vim.fn.exists ":JdtOrganizeImports" > 0 then
        vim.cmd "JdtOrganizeImports"
      else
        require("jdtls").organize_imports()
      end
    end, opts)
    vim.keymap.set("n", "<leader>jv", function()
      require("jdtls").extract_variable()
    end, opts)
    vim.keymap.set("n", "<leader>jc", function()
      require("jdtls").extract_constant()
    end, opts)
    vim.keymap.set("v", "<leader>jm", function()
      require("jdtls").extract_method(true)
    end, opts)
  end,
})

-- TypeScript/JavaScript configuration
autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true

    -- TypeScript/JavaScript specific keymaps
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set("n", "<leader>ts", ":TypescriptOrganizeImports<CR>", opts)
    vim.keymap.set("n", "<leader>tr", ":TypescriptRenameFile<CR>", opts)
    vim.keymap.set("n", "<leader>tu", ":TypescriptRemoveUnused<CR>", opts)
    vim.keymap.set("n", "<leader>tf", ":TypescriptFixAll<CR>", opts)
    vim.keymap.set("n", "<leader>ta", ":TypescriptAddMissingImports<CR>", opts)
  end,
})

-- React/JSX specific configuration
autocmd("FileType", {
  pattern = { "javascriptreact", "typescriptreact" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
    vim.bo.commentstring = "{/* %s */}"

    -- Enable emmet for JSX
    vim.b.emmet_jsx_enabled = 1

    -- React-specific keymaps
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set("n", "<leader>rc", ":!npm run dev<CR>", opts)
    vim.keymap.set("n", "<leader>rb", ":!npm run build<CR>", opts)
    vim.keymap.set("n", "<leader>rt", ":!npm test<CR>", opts)
  end,
})

-- Angular specific configuration
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.component.ts", "*.service.ts", "*.module.ts", "*.pipe.ts", "*.directive.ts" },
  callback = function()
    vim.bo.filetype = "typescript"
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true

    -- Angular-specific keymaps
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set("n", "<leader>ng", ":!ng generate component ", opts)
    vim.keymap.set("n", "<leader>ns", ":!ng serve<CR>", opts)
    vim.keymap.set("n", "<leader>nb", ":!ng build<CR>", opts)
    vim.keymap.set("n", "<leader>nt", ":!ng test<CR>", opts)
    vim.keymap.set("n", "<leader>ne", ":!ng e2e<CR>", opts)
  end,
})

-- Angular HTML templates
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.component.html",
  callback = function()
    vim.bo.filetype = "html"
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true

    -- Enable Angular template syntax
    vim.b.angular_template = true
  end,
})

-- Angular SCSS/CSS files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.component.scss", "*.component.css" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})

-- Package.json configuration
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "package.json",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true

    -- Enable package-info plugin if available
    local ok, package_info = pcall(require, "package-info")
    if ok then
      package_info.show()

      -- Package.json specific keymaps
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set("n", "<leader>pu", function()
        package_info.update()
      end, opts)
      vim.keymap.set("n", "<leader>pi", function()
        package_info.install()
      end, opts)
      vim.keymap.set("n", "<leader>pd", function()
        package_info.delete()
      end, opts)
      vim.keymap.set("n", "<leader>pc", function()
        package_info.change_version()
      end, opts)
    end
  end,
})

-- React Native specific configuration
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "App.tsx", "App.jsx", "index.js", "index.ts" },
  callback = function()
    -- Check if it's a React Native project by looking for react-native in package.json
    local package_json = vim.fn.findfile("package.json", ".;")
    if package_json ~= "" then
      local content = vim.fn.readfile(package_json)
      local package_str = table.concat(content, "\n")

      if string.find(package_str, "react%-native") then
        -- React Native specific keymaps
        local opts = { noremap = true, silent = true, buffer = true }
        vim.keymap.set("n", "<leader>rns", ":!npx react-native start<CR>", opts)
        vim.keymap.set("n", "<leader>rni", ":!npx react-native run-ios<CR>", opts)
        vim.keymap.set("n", "<leader>rna", ":!npx react-native run-android<CR>", opts)
        vim.keymap.set("n", "<leader>rnl", ":!npx react-native log-ios<CR>", opts)
        vim.keymap.set("n", "<leader>rnc", ":!npx react-native clean<CR>", opts)
      end
    end
  end,
})

-- Next.js specific configuration
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "next.config.js", "next.config.ts", "pages/**/*.tsx", "pages/**/*.jsx" },
  callback = function()
    -- Next.js specific keymaps
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set("n", "<leader>nd", ":!npm run dev<CR>", opts)
    vim.keymap.set("n", "<leader>nb", ":!npm run build<CR>", opts)
    vim.keymap.set("n", "<leader>ns", ":!npm start<CR>", opts)
  end,
})

-- Vue.js configuration
autocmd("FileType", {
  pattern = "vue",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true

    -- Vue-specific keymaps
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set("n", "<leader>vs", ":!npm run serve<CR>", opts)
    vim.keymap.set("n", "<leader>vb", ":!npm run build<CR>", opts)
  end,
})

-- JSON configuration
autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
    vim.bo.conceallevel = 0 -- Show quotes in JSON files
  end,
})

-- YAML configuration
autocmd("FileType", {
  pattern = { "yaml", "yml" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})

-- HTML/CSS configuration
autocmd("FileType", {
  pattern = { "html", "css", "scss", "sass", "less" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})

-- Markdown configuration
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
    vim.bo.wrap = true
    vim.bo.linebreak = true
  end,
})

-- Auto-format on save for specific file types
autocmd("BufWritePre", {
  pattern = {
    "*.js",
    "*.jsx",
    "*.ts",
    "*.tsx",
    "*.json",
    "*.html",
    "*.css",
    "*.scss",
    "*.yaml",
    "*.yml",
    "*.md",
    "*.java",
  },
  callback = function()
    -- Only format if conform.nvim is available and format on save is enabled
    local ok, conform = pcall(require, "conform")
    if ok and vim.g.format_on_save ~= false then
      conform.format { async = false, lsp_fallback = true }
    end
  end,
})

-- Auto-organize imports on save for TypeScript/JavaScript
autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    -- Only if TypeScript tools is available
    if vim.fn.exists ":TypescriptOrganizeImports" > 0 then
      vim.cmd "TypescriptOrganizeImports"
    end
  end,
})

-- Set up project-specific configurations
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    -- Load project-specific .nvimrc if it exists
    local nvimrc = vim.fn.findfile(".nvimrc", ".;")
    if nvimrc ~= "" and vim.fn.filereadable(nvimrc) == 1 then
      vim.cmd("source " .. nvimrc)
    end
  end,
})

-- Highlight TODO, FIXME, NOTE, etc.
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("Todo", "\\<\\(TODO\\|FIXME\\|NOTE\\|HACK\\|BUG\\)\\>")
  end,
})

-- Enable spell check for markdown and text files
autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.bo.spell = true
    vim.bo.spelllang = "en_us"
  end,
})
