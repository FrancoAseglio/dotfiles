return {
	"huggingface/llm.nvim",
	config = function()
		require("llm").setup({
			backend = "ollama",
			model = "qwen2.5-coder:7b",
			url = "http://localhost:11434/api/generate",

			request_body = {
				options = {
					temperature = 0.1,
					top_p = 0.9,
					num_predict = 100,
					stop = { "\n\n" },
				},
			},

			tokens_to_clear = {
				"```",
				"<fim",
				"</fim",
				"```python",
				"python",
				"```html",
				"html",
				"```java",
				"java",
				"```c",
				"c",
				"```cpp",
				"cpp",
			},

			fim = {
				enabled = true,
				prefix = "<fim_prefix>",
				middle = "<fim_middle>",
				suffix = "<fim_suffix>",
			},

			context_window = 1024,
			enable_suggestions_on_startup = true,
			enable_suggestions_on_files = "*.py,*.js,*.lua,*.rs,*.go,*.java,*.html,*.c",
			debounce_ms = 150,
			accept_keymap = "<C-l>",
			dismiss_keymap = "<S-Tab>",
		})
	end,
}
