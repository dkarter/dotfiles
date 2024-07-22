-- Ollama integration for local LLM
return {
  'David-Kunz/gen.nvim',
  cmd = { 'Gen' },
  keys = require('core.mappings').gen_nvim_mappings,
  opts = {
    model = 'mistral',
    display_mode = 'split', -- The display mode. Can be "float" or "split".
    show_prompt = true, -- Shows the prompt submitted to Ollama.
    show_model = true, -- Displays which model you are using at the beginning of your chat session.
  },
}
