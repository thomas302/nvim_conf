return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { 
                    -- Custom structural definition hook
                    {
                        function()
                            if _G.GDocs and _G.GDocs.count then
                                return _G.GDocs.count()
                            end
                            return "0 words"
                        end,
                        cond = function()
                            -- Tells Lualine to bypass this entire segment when toggled off
                            return _G.GDocs and _G.GDocs.enabled == true
                        end,
                    },
                    "encoding", 
                    "fileformat", 
                    "filetype" 
                },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            }
        })
    end,
}

-- return {
 --     "nvim-lualine/lualine.nvim",
 --     dependencies = { "nvim-tree/nvim-web-devicons" },
 --     config = function()
 --         require("lualine").setup()
 --     end,
 -- }
