nnoremap <leader>tg :lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>tf :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>tw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>tb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>th :lua require('telescope.builtin').help_tags()<CR>
