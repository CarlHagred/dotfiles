return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,       -- ensure it loads before other UI-affecting plugins
        lazy = false,          -- load at startup so colorscheme is ready immediately
        opts = {
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            transparent_background = true,
            term_colors = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
            integrations = {
                aerial = true,
                alpha = true,
                cmp = true,
                dashboard = true,
                flash = true,
                fzf = true,
                grug_far = true,
                gitsigns = true,
                headlines = true,
                illuminate = true,
                indent_blankline = { enabled = true },
                leap = true,
                lsp_trouble = true,
                mason = true,
                mini = true,
                navic = { enabled = true, custom_bg = "lualine" },
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                snacks = true,
                telescope = true,
                treesitter_context = true,
                which_key = true,
            },
            -- Fine-grained highlight overrides to enforce transparency.
            custom_highlights = function(colors)
                local transparent = { bg = "NONE" }
                return {
                    Normal = transparent,
                    NormalNC = transparent,
                    NormalFloat = transparent,
                    FloatBorder = transparent,
                    SignColumn = transparent,
                    LineNr = transparent,
                    CursorLineNr = transparent,
                    FoldColumn = transparent,
                    MsgArea = transparent,
                    WinSeparator = { bg = "NONE", fg = colors.surface1 },
                    StatusLine = { bg = "NONE", fg = colors.text },
                    StatusLineNC = { bg = "NONE", fg = colors.overlay0 },
                    NeoTreeNormal = transparent,
                    NeoTreeNormalNC = transparent,
                    NeoTreeFloatBorder = transparent,
                    TelescopeNormal = transparent,
                    TelescopeBorder = transparent,
                    Pmenu = transparent,
                    PmenuSel = { bg = colors.surface0 },
                    WhichKeyFloat = transparent,
                    LazyNormal = transparent,
                    BufferLineFill = transparent,
                    VertSplit = { bg = "NONE", fg = colors.surface1 },
                }
            end,
        },
        config = function(_, opts)
            local catppuccin = require("catppuccin")
            catppuccin.setup(opts)

            -- Apply colorscheme
            vim.cmd("colorscheme catppuccin")

            -- (Optional) Extra enforcement for any plugin loading late that re-adds backgrounds.
            local function force_transparent()
                local groups = {
                    "Normal",
                    "NormalNC",
                    "NormalFloat",
                    "SignColumn",
                    "LineNr",
                    "FoldColumn",
                    "NeoTreeNormal",
                    "NeoTreeNormalNC",
                    "TelescopeNormal",
                }
                for _, g in ipairs(groups) do
                    vim.cmd(("highlight %s guibg=NONE ctermbg=NONE"):format(g))
                end
            end

            -- Run once after startup; you can remove this if unnecessary.
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "catppuccin",
                callback = force_transparent,
            })
            force_transparent()
        end,
        specs = {
            {
                "akinsho/bufferline.nvim",
                optional = true,
                opts = function(_, opts)
                    if (vim.g.colors_name or ""):find("catppuccin") then
                        local ok_new, mod_new = pcall(require, "catppuccin.groups.integrations.bufferline")
                        local ok_old, mod_old = pcall(require, "catppuccin.special.bufferline")
                        if ok_new and mod_new then
                            opts.highlights = mod_new.get()
                        elseif ok_old and mod_old then
                            if mod_old.get_theme then
                                opts.highlights = mod_old.get_theme()
                            else
                                opts.highlights = mod_old.get()
                            end
                        end
                    end
                end,
            },
            {
                "nvim-lualine/lualine.nvim",
                optional = true,
                opts = function(_, opts)
                    -- Ensure lualine doesn't introduce opaque sections
                    opts.options = opts.options or {}
                    opts.options.theme = "catppuccin"
                end,
            },
        },
    },
}
