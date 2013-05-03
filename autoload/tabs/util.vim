
function! tabs#util#New()
    let object = {}

    " type patに一致するか、非一致かを設定する
    " 1 = 'match', not 1 = unmatch
    function! object.getFilterdLines(max, pat, type) dict
        return a:type ==? 1
        \       ? filter(getline(0, a:max), "v:val =~? '" . a:pat . "'")
        \       : filter(getline(0, a:max), "v:val !~? '" . a:pat . "'")
    endfunction

    return object
endfunction
