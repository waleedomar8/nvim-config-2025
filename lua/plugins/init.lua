return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- Java LSP enhancement
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls = require "jdtls"

      -- Find root directory
      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.xml" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if not root_dir then
        return
      end

      -- Mason path for jdtls
      local mason_path = vim.fn.stdpath "data" .. "/mason"
      local jdtls_path = mason_path .. "/packages/jdtls"

      -- Find launcher jar
      local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      if launcher_jar == "" then
        vim.notify("JDTLS not found. Install via :MasonInstall jdtls", vim.log.levels.WARN)
        return
      end

      -- OS config
      local os_config = "config_linux"
      if vim.fn.has "mac" == 1 then
        os_config = "config_mac"
      elseif vim.fn.has "win32" == 1 then
        os_config = "config_win"
      end

      -- Workspace
      local workspace_dir = vim.fn.stdpath "data" .. "/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          launcher_jar,
          "-configuration",
          jdtls_path .. "/" .. os_config,
          "-data",
          workspace_dir,
        },

        root_dir = root_dir,

        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = "interactive",
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            format = {
              enabled = true,
            },
          },
        },

        on_attach = function(client, bufnr)
          -- Use NvChad's default on_attach
          require("nvchad.configs.lspconfig").on_attach(client, bufnr)

          -- Java-specific keymaps
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "<leader>co", jdtls.organize_imports, opts)
        end,

        capabilities = require("nvchad.configs.lspconfig").capabilities,
      }

      jdtls.start_or_attach(config)
    end,
  },

  -- Optional: Add formatting support
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },

  -- TypeScript/React enhancements
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("typescript-tools").setup {
        on_attach = require("nvchad.configs.lspconfig").on_attach,
        capabilities = require("nvchad.configs.lspconfig").capabilities,
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = {},
          tsserver_path = nil,
          tsserver_plugins = {},
          tsserver_max_memory = "auto",
          tsserver_format_options = {},
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "literal",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayVariableTypeHints = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayEnumMemberValueHints = false,
          },
        },
      }
    end,
  },

  -- React/JSX support
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      }
    end,
  },

  -- Better syntax highlighting for React/TS
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "jsx",
        "json",
        "yaml",
        "java",
      },
    },
  },

  -- Formatting support
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },

  -- Package.json support (for React/Angular projects)
  {
    "vuki656/package-info.nvim",
    ft = "json",
    config = function()
      require("package-info").setup {
        colors = {
          up_to_date = "#3C4048",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
      }
    end,
  },

  -- REST client for API testing (useful for React/Angular)
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup {
        result_split_horizontal = false,
        result_split_in_place = false,
        skip_ssl_verification = false,
        encode_url = true,
        highlight = {
          enabled = true,
          timeout = 150,
        },
      }
    end,
  },

  -- Git integration (essential for team projects)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Better commenting for JSX/TSX
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
