return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("custom.configs.conform")
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("custom.configs.lint")
    end,
  },
}
