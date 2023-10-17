" vim colors
" adapted from https://github.com/andreasvc/vim-256noir

highlight clear
set background=light
syntax reset
let g:colors_name = "mier"

hi Normal cterm=NONE ctermfg=Black
hi Keyword cterm=bold ctermfg=Black
hi Constant cterm=NONE ctermfg=Black
hi String cterm=NONE ctermfg=Red
hi Comment cterm=NONE ctermfg=DarkBlue
hi Number cterm=NONE ctermfg=Red
" TODO: change/add these
" hi Error cterm=NONE ctermfg=Black ctermbg=DarkRed
" hi ErrorMsg cterm=NONE ctermfg=Black ctermbg=Red
" hi Search cterm=NONE ctermfg=Gray ctermbg=DarkGray
" hi IncSearch cterm=reverse ctermfg=Black ctermbg=Gray
" hi DiffChange cterm=NONE ctermfg=Red ctermbg=Black
" hi DiffText cterm=bold ctermfg=Gray ctermbg=Red
" hi SignColumn cterm=NONE ctermfg=Red ctermbg=DarkGray
" hi SpellBad cterm=undercurl ctermfg=White ctermbg=DarkRed
" hi SpellCap cterm=NONE ctermfg=Black ctermbg=Red
" hi SpellRare cterm=NONE ctermfg=Red
" hi WildMenu cterm=NONE ctermfg=DarkGray ctermbg=Black
" hi Pmenu cterm=NONE ctermfg=Black ctermbg=DarkGray
" hi PmenuThumb cterm=NONE ctermfg=White ctermbg=DarkGray
" hi SpecialKey cterm=NONE ctermfg=Black ctermbg=White
" hi MatchParen cterm=NONE ctermfg=White ctermbg=DarkGray
" hi CursorLine cterm=NONE ctermfg=NONE
" hi StatusLine cterm=bold,reverse ctermfg=Gray
" hi StatusLineNC cterm=reverse ctermfg=DarkGray
" hi Visual cterm=reverse ctermfg=Gray
" hi TermCursor cterm=reverse ctermfg=NONE ctermbg=NONE
" 
highlight! link Boolean Normal
highlight! link Delimiter Normal
highlight! link Identifier Normal
highlight! link Title Normal
highlight! link Debug Normal
highlight! link Exception Normal
highlight! link FoldColumn Normal
highlight! link Macro Normal
highlight! link ModeMsg Normal
highlight! link MoreMsg Normal
highlight! link Question Normal
highlight! link Conditional Keyword
highlight! link Statement Keyword
highlight! link Operator Keyword
highlight! link Structure Keyword
highlight! link Function Keyword
highlight! link Include Keyword
highlight! link Type Keyword
highlight! link Typedef Keyword
highlight! link Todo Keyword
highlight! link Label Keyword
highlight! link Define Keyword
highlight! link DiffAdd Keyword
highlight! link diffAdded Keyword
highlight! link diffCommon Keyword
highlight! link Directory Keyword
highlight! link PreCondit Keyword
highlight! link PreProc Keyword
highlight! link Repeat Keyword
highlight! link Special Keyword
highlight! link SpecialChar Keyword
highlight! link StorageClass Keyword
highlight! link SpecialComment String
highlight! link CursorLineNr String
highlight! link Character Number
highlight! link Float Number
highlight! link Tag Number
highlight! link Folded Number
highlight! link WarningMsg Number
highlight! link iCursor SpecialKey
highlight! link SpellLocal SpellCap
highlight! link LineNr Comment
highlight! link NonText Comment
highlight! link DiffDelete Comment
highlight! link diffRemoved Comment
highlight! link PmenuSbar Visual
highlight! link PmenuSel Visual
highlight! link VisualNOS Visual
highlight! link VertSplit Visual
highlight! link Cursor StatusLine
highlight! link Underlined SpellRare
highlight! link rstEmphasis SpellRare
highlight! link diffChanged DiffChange
