lua require('lsp')

set completeopt=menuone,noinsert,noselect
set shortmess+=c
let g:completion_confirm_key = ""
let g:completion_trigger_keyword_length = 2
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
