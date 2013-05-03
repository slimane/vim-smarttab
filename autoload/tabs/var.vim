let s:spaceFlag = 0
let s:tabFlag   = 1
let s:lineMax = 200
let s:tabLang =
\           ['markdown'
\           , 'snippet'
\           , 'gitcommit'
\           , 'snippet']
let s:spaceLang =
\           ['help']

function! tabs#var#New()
    let object = {}


    let object.tabFlag = s:tabFlag
    let object.spaceFlag = s:spaceFlag
    let object.lineMax = s:lineMax

    let object.tabList = s:tabLang


    function! object.setTabsList(filetype) dict
        call add(self.tabList, a:filetype)
    endfunctio




    let object.spaceList = s:spaceLang

    function! object.setSpaceList(filetype) dict
        call add(self.spaceList, a:filetype)
    endfunction


    return object

endfunction
