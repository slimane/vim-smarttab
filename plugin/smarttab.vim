" 各種変数値をdictionaryで管理するクラスを宣言
let s:body = tabs#body#New()


command! -nargs=1 AddSpaceLang        :call s:var.setSpaceList("<args>")
command! -nargs=0 CondidacyIndentSize :call s:body.condidancy()
command! -nargs=0 IndentTypeCheck     :call s:body.setIndentType()
command! -nargs=0 TabFormatting       :call s:body.autoConverTabToSpace()
command! -nargs=1 AddTabList          :call s:body.addExclude(<f-args>, 1)

command! -nargs=0 TabToSpace          :call s:body.converTabToSpace()

if !exists('g:vim-smarttab_auto_expand_disable')
    augroup vim-smarttab.vim
        autocmd!
        autocmd   FileType      * IndentTypeCheck
        autocmd   BufWritePre   * TabFormatting
        autocmd   FileType      * CondidacyIndentSize
    augroup end
endif
