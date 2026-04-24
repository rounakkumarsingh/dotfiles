return {
	"saghen/blink.cmp",
	dependencies = {
		"Exafunction/codeium.nvim",
		"rafamadriz/friendly-snippets",
	},
	version = "*",
	opts = {
		keymap = {
			preset = "none",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide" },
			["<C-y>"] = { "select_and_accept" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "codeium" },
			providers = {
				codeium = { name = "Codeium", module = "codeium.blink", async = true },
			},
		},
		completion = {
			accept = { auto_brackets = { enabled = false } },
			menu = {
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
