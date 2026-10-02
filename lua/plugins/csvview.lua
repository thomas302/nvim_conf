return {
  "hat0uma/csvview.nvim",
  ---@type CsvView.Options
  opts = {
    parser = {
      -- Look for commas first, fallback to tabs or semicolons
      comments = { "#" },
    },
    view = {
      -- "border" draws crisp '│' table grids. Change to "highlight" for spaces only.
      display_mode = "border",
      -- Minimum width of columns
      min_column_width = 5,
      -- Spaces between virtual columns
      spacing = 2,
    },
  },
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  keys = {
    { "<leader>vt", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV Virtual View" },
  },
  ft = { "csv", "tsv" },
}

