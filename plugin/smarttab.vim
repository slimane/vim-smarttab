" 各種変数値をdictionaryで管理するクラスを宣言
let s:body = tabs#body#New()
let s:var = tabs#var#New()


command! -nargs=0 CondidacyIndentSize  call s:body.condidancy()
command! -nargs=0 IndentTypeCheck      call s:body.setIndentType()
command! -nargs=0 TabFormatting        call s:body.autoConverTabToSpace()

if !exists('g:smarttab_auto_expand_disable')
    augroup vim-smarttab.vim
        autocmd!
        autocmd   FileType      * IndentTypeCheck
        autocmd   FileType      * CondidacyIndentSize
        autocmd   BufWritePre   * TabFormatting
    augroup end
endif
