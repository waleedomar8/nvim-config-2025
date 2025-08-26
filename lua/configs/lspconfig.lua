-- ~/.config/nvim/lua/configs/lspconfig.lua
require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "jdtls",
  "ts_ls", -- TypeScript/JavaScript
  "eslint", -- ESLint for React/Angular
  "tailwindcss", -- Tailwind CSS (common in React/RN)
  "emmet_ls", -- Emmet for HTML/JSX
}

local nvlsp = require "nvchad.configs.lspconfig"

-- Configure each server with default settings
for _, lsp in ipairs(servers) do
  require("lspconfig")[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- TypeScript/JavaScript specific configuration
require("lspconfig").ts_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "relative",
      },
    },
  },
}

-- Emmet for JSX/TSX
require("lspconfig").emmet_ls.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  filetypes = {
    "html",
    "typescriptreact",
    "javascriptreact",
    "css",
    "sass",
    "scss",
    "less",
  },
}

-- Tailwind CSS for React/RN projects
require("lspconfig").tailwindcss.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
}

vim.lsp.enable(servers)
