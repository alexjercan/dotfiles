local lspconfig = require('lspconfig')
local lsp_completion = require('completion')
local lsp_status = require('lsp-status')
local lspkind = require('lspkind')
local lsp = vim.lsp
local buf_keymap = vim.api.nvim_buf_set_keymap
local cmd = vim.cmd

local kind_symbols = {
  	Text = '',
  	Method = 'Ƒ',
  	Function = 'ƒ',
  	Constructor = '',
  	Variable = '',
  	Class = '',
  	Interface = 'ﰮ',
  	Module = '',
  	Property = '',
  	Unit = '',
  	Value = '',
  	Enum = '了',
  	Keyword = '',
  	Snippet = '﬌',
  	Color = '',
  	File = '',
  	Folder = '',
  	EnumMember = '',
  	Constant = '',
  	Struct = ''
}

local sign_define = vim.fn.sign_define
sign_define('LspDiagnosticsSignError', {text = '', numhl = 'RedSign'})
sign_define('LspDiagnosticsSignWarning', {text = '', numhl = 'YellowSign'})
sign_define('LspDiagnosticsSignInformation', {text = '', numhl = 'WhiteSign'})
sign_define('LspDiagnosticsSignHint', {text = '', numhl = 'BlueSign'})
lsp_status.config {
  	kind_labels = kind_symbols,
  	select_symbol = function(cursor_pos, symbol)
    		if symbol.valueRange then
      			local value_range = {
        			['start'] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[1])},
        			['end'] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[2])}
      			}

      			return require('lsp-status/util').in_range(cursor_pos, value_range)
    		end
  	end,
  	current_function = false
}

lsp_status.register_progress()
lspkind.init {symbol_map = kind_symbols}
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  	virtual_text = false,
  	signs = true,
  	update_in_insert = false,
  	underline = true
})

local keymap_opts = {noremap = true, silent = true}
local function on_attach(client)
  	lsp_status.on_attach(client)
  	lsp_completion.on_attach(client)
  	buf_keymap(0, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.declaration()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>lD', '<cmd>lua vim.lsp.buf.definition()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>lH', '<cmd>lua vim.lsp.buf.signature_help()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
             	keymap_opts)
  	buf_keymap(0, 'n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', keymap_opts)
  	buf_keymap(0, 'n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', keymap_opts)

	if client.resolved_capabilities.document_formatting then
    		buf_keymap(0, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<cr>', keymap_opts)
  	end

  	if client.resolved_capabilities.document_highlight == true then
    		cmd('augroup lsp_aucmds')
    		cmd('au CursorHold <buffer> lua vim.lsp.buf.document_highlight()')
    		cmd('au CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
    		cmd('au CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
    		cmd('augroup END')
  	end
end

local servers = {
	clangd = {
    		cmd = {
      			'clangd', -- '--background-index',
      			'--clang-tidy', '--completion-style=bundled', '--header-insertion=iwyu',
      			'--suggest-missing-includes', '--cross-file-rename'
    		},
    		handlers = lsp_status.extensions.clangd.setup(),
    		init_options = {
      			clangdFileStatus = true,
      			usePlaceholders = true,
      			completeUnimported = true,
      			semanticHighlighting = true
    		}
  	},
	tsserver = {},
}

local snippet_capabilities = {
  	textDocument = {completion = {completionItem = {snippetSupport = true}}}
}

for server, config in pairs(servers) do
  	config.on_attach = on_attach
  	config.capabilities = vim.tbl_deep_extend('keep', config.capabilities or {},
                                            lsp_status.capabilities, snippet_capabilities)
  	lspconfig[server].setup(config)
end
