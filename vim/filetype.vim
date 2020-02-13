"if no rules from $VIMRUNTIME/filetype.vim execute
"':setf' this file will be read

if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect

"new filetype user-info
"au! BufNewFile,BufRead * if getline(1) =~ '#use user-info-vim' | setf user-info | endif
au BufNewFile,BufRead *.ui setf userinfo

augroup END
