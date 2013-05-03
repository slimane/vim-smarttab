" -- tab関連のファンクションおよび、ファクションのインターフェースとしてのコマンドを定義 --

let s:var = tabs#var#New()

if !exists("s:tabList")
    let s:tabList = s:var.tabList
    if exists('g:smart_tab_tab_list')
        call add(s:tabList(g:smart_tab_tab_list)
    endif
endif

if !exists("s:spaceList")
    let s:spaceList = s:var.spaceList
    if exists('g:smart_space_tab_list')
        call add(s:spaceList, g:smart_space_tab_list)
    endif
endif

let s:tabFlag   = s:var.tabFlag
let s:spaceFlag = s:var.spaceFlag




" 外部から利用するためのObject
function! tabs#body#New()
    let object = {}

    let object.tablist   = s:tabList
    let object.spacelist = s:spaceList



    " 検索除外ファイルタイプを指定する
    function! object.addExcludeList(fileType, indentType) dict
        if type(a:fileType) ==? type([])
            for l:fileType in a:fileTypeList
                call self.addExclude(l:fileType, a:indentType)
            endfor
        else
            call self.addExclude(a:fileType, a:indentType)
        endif
    endfunction


    function! object.addExclude(fileType, indentType)
        if a:indentType ==# s:tabFlag
            call add(s:tabList, a:fileType)
        endif

        if a:indentType ==# s:spaceFlag
            call add(s:spaceList, a:fileType)
        endif
    endfunction




    " 検索除外リスト(タブ文字でインデントするものを表示する)
    function! object.displayList()
        echomsg join(s:tabList)
    endfunction




    " buffer localな変数であるb:indentTypeにbufferのインデント文字を保持する
    function! object.getIndentType() 
        if exists('b:indentType')
            return b:indentType
        endif

        if index(s:tabList, &filetype, 0) !=? -1
            return s:tabFlag
        endif

        if index(s:spaceList, &filetype, 0) !=? -1
            return  s:spaceFlag
        endif

        " 指定行数までで行頭がtab文字を持つ行のリストを作成
        let Util = tabs#util#New()
        let l:maxLine = exists('g:smart_tab_lineMax')
        \                   ? g:smart_tab_lineMax
        \                   : s:var.lineMax
        let lines = Util.getFilterdLines(l:maxLine,  '^\t', 1)
        let lineLens  = []

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
        let lineLens  = []
        for line in lines
            call add(lineLens, match(line, '\S'))
        endfor

        return min(lineLens) !=# 0 ? min(lineLens) : &tabstop
    endfunction 




    " CondidacyIndentSize
    function! object.condidancy() dict
        call self.setIndentType()
        let b:indentSize = self.getTabSize()

        execute 'silent setlocal tabstop    =' . b:indentSize
        execute 'silent setlocal shiftwidth =' . b:indentSize
    endfunction




    function! object.setIndentType() dict
        let b:indentType = self.getIndentType()
    endfunction



    function! object.autoConverTabToSpace() dict
        call self.setIndentType()
        if b:indentType ==? s:spaceFlag
            call self.converTabToSpace()
        endif
    endfunction




    function! object.converTabToSpace() dict
        let l:expandtab = &expandtab == 1
        \                   ? 'expandtab'
        \                   : 'noexpandtab'

        silent setlocal expandtab
        silent %retab!

        execute 'silent setlocal ' . l:expandtab
    endfunction





    return object
endfunction
