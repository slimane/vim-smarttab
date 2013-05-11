" -- tab関連のファンクションおよび、ファクションのインターフェースとしてのコマンドを定義 --

let s:var = tabs#var#New()



let s:tabFlag   = s:var.tabFlag
let s:spaceFlag = s:var.spaceFlag




" 外部から利用するためのObject
function! tabs#body#New()
    let object = {}


    " buffer localな変数であるb:indentTypeにbufferのインデント文字を保持する
    function! object.getIndentType() dict
        if self.isDisableFiletype()
            return &expandtab ? s:tabFlag : s:spaceFlag
        endif

        if exists('b:indentType')
            return b:indentType
        endif


        " 指定行数までで行頭がtab文字を持つ行のリストを作成
        let Util = tabs#util#New()
        let l:maxLine = exists('g:smart_tab_lineMax')
        \                   ? g:smart_tab_lineMax
        \                   : s:var.lineMax
        let lines = Util.getFilterdLines(l:maxLine,  '^\t', 1)

        if len(lines) !=# 0
            return s:tabFlag
        endif

        return s:spaceFlag
    endfunction




    " tabsizeを推定
    function! object.getTabSize() dict
        if exists("b:indentSize")
            return b:indentSize
        endif

        if self.getIndentType()  ==# s:tabFlag
            return &tabstop
        endif


        " 指定行目までで行頭に2個以上空白を持つ行のリストを作成
        " 1個のみであればインデントとは思えないため
        let Util = tabs#util#New()
        let l:maxLine = exists('g:smart_tab_lineMax')
        \                   ? g:smart_tab_lineMax
        \                   : s:var.lineMax
        let lines     = Util.getFilterdLines(l:maxLine, '\v^\s{2,}\S', 1)

        let lines = map(lines, 'match(v:val, ''\S'')')

        return min(lines) !=# 0 ? min(lines) : &tabstop
    endfunction




    " CondidacyIndentSize
    function! object.condidancy() dict
        call self.setIndentType()
        let b:indentSize = self.getTabSize()

        execute 'silent setlocal '
        \       '   tabstop='     . b:indentSize
        \       '   shiftwidth='  . b:indentSize
        \       '   softtabstop=' . b:indentSize
    endfunction




    function! object.setIndentType() dict
        let b:indentType = self.getIndentType()
    endfunction



    function! object.autoConverTabToSpace() dict
        call self.setIndentType()

        if self.isDisableFiletype()
            return
        endif

        if b:indentType ==? s:spaceFlag
            call self.converTabToSpace()
        endif
    endfunction


    function! object.isDisableFiletype()
        let disable = exists('g:smart_tab_disable_filetype')
        \       ?   g:smart_tab_disable_filetype
        \       :   s:var.disable_filetype
        return index(disable, &filetype) !=# -1
    endfunction


    return object
endfunction
