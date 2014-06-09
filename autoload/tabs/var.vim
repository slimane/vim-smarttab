let s:spaceFlag = 0
let s:tabFlag   = 1
let s:lineMax = 200
let s:disable_smarttab_filetype =
\           ['markdown'
\           , 'snippet'
\           , 'gitcommit'
\           , 'snippet'
\           , 'haskell']

function! tabs#var#New()
    let object = {}


    let object.tabFlag = s:tabFlag
    let object.spaceFlag = s:spaceFlag
    let object.lineMax = s:lineMax

    let object.disable_filetype = s:disable_smarttab_filetype

    return object
endfunction
