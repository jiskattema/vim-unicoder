if exists('g:loaded_unicoder')
  finish
endif
let g:loaded_unicoder = 1

" Defaults {{{
if !exists('g:unicoder_command_abbreviations')
  let g:unicoder_command_abbreviations = 1
endif
" }}}

function! s:irepl(prefix, default, repl)
  let n = len(a:prefix)
  let bs = repeat("\<bs>", n)
  if n > 0
    return getline('.')[col('.') - n - 1] == a:prefix ? bs.a:repl : a:default
  else
    return a:repl
  endif
endfunction

function! s:crepl(prefix, default, repl)
  let n = len(a:prefix)
  let bs = repeat(nr2char(8), n)
  if n > 0
    return getcmdline()[getcmdpos() - n - 1] == a:prefix ? bs.a:repl : a:default
  else
    return a:repl
  endif
endfunction

function! s:Prefixab(opts, prefix, lhs, rhs)
  let args = string(a:prefix).', '.string(a:lhs).', '.string(a:rhs)
  silent! exe 'inoreab '.a:opts.' '.a:lhs.' <c-r>=<sid>irepl('.args.')<cr>'
  if g:unicoder_command_abbreviations
    silent! exe 'cnoreab '.a:opts.' '.a:lhs.' <c-r>=<sid>crepl('.args.')<cr>'
  endif
endfunction
command! -nargs=+ Prefixab call s:Prefixab('', <f-args>)
command! -nargs=+ Noprefixab call s:Prefixab('', '', <f-args>)

function! CompleteIAB(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start >= 0 
            if line[start] == '\' || line[start] == '`'
              return start
            elseif line[start] =~ '\s'
              return -3
            endif 
            let start -= 1
        endwhile
        return -3
    else
        " find abbreviations matching "a:base"
        let abbrevs = split(execute('iab'), '<CR>')
        let res = []
        for abbrev in abbrevs
          let lst = matchlist(abbrev, '^.*irepl(''\(.*\)'', *''\(.*\)'', *''\(.*\)'' *)')
          let finalabbrev = lst[1] . lst[2]

          let matched = matchfuzzy([finalabbrev], a:base)
          if len(matched) > 0
              let displ = printf('%0.5s   %s', lst[3], lst[1] . lst[2])
              call add(res, {'word': finalabbrev, 'abbr': displ})
          endif
        endfor
        return {'words': res}
    endif
endfun
set completefunc=CompleteIAB

" Initialization
function! s:setup_abbreviations()
  augroup pencil_iskeyword
    autocmd!
  augroup END

  " Greek {{{
  " Uppercase greek {{{
  Prefixab  \\ GA     Α
  Prefixab  \\ GB     Β
  Prefixab  \\ GG     Γ
  Prefixab  \\ GD     Δ
  Prefixab  \\ GE     Ε
  Prefixab  \\ GZ     Ζ
  Prefixab  \\ GH     Η
  Prefixab  \\ GTH    Θ
  Prefixab  \\ GI     Ι
  Prefixab  \\ GK     Κ
  Prefixab  \\ GL     Λ
  Prefixab  \\ GM     Μ
  Prefixab  \\ GN     Ν
  Prefixab  \\ GX     Ξ
  Prefixab  \\ GO     Ο
  Prefixab  \\ GP     Π
  Prefixab  \\ GR     Ρ
  Prefixab  \\ GS     Σ
  Prefixab  \\ GT     Τ
  Prefixab  \\ GU     Υ
  Prefixab  \\ GF     Φ
  Prefixab  \\ GC     Χ
  Prefixab  \\ GPS    Ψ
  Prefixab  \\ GW     Ω

  Prefixab  \\ Alpha       Α
  Prefixab  \\ Beta        Β
  Prefixab  \\ Gamma       Γ
  Prefixab  \\ Delta       Δ
  Prefixab  \\ Epsilon     Ε
  Prefixab  \\ Zeta        Ζ
  Prefixab  \\ Eta         Η
  Prefixab  \\ Theta       Θ
  Prefixab  \\ Iota        Ι
  Prefixab  \\ Kappa       Κ
  Prefixab  \\ Lambda      Λ
  Prefixab  \\ Mu          Μ
  Prefixab  \\ Nu          Ν
  Prefixab  \\ Xi          Ξ
  Prefixab  \\ Omicron     Ο
  Prefixab  \\ Pi          Π
  Prefixab  \\ Rho         Ρ
  Prefixab  \\ Sigma       Σ
  Prefixab  \\ Tau         Τ
  Prefixab  \\ Upsilon     Υ
  Prefixab  \\ Phi         Φ
  Prefixab  \\ Chi         Χ
  Prefixab  \\ Psi         Ψ
  Prefixab  \\ Omega       Ω
  " }}}

  " Lowercase greek {{{
  Prefixab  \\ ga     α
  Prefixab  \\ gb     β
  Prefixab  \\ gg     γ
  Prefixab  \\ gd     δ
  Prefixab  \\ ge     ε
  Prefixab  \\ gz     ζ
  Prefixab  \\ gh     η
  Prefixab  \\ gth    θ
  Prefixab  \\ gi     ι
  Prefixab  \\ gk     κ
  Prefixab  \\ gl     λ
  Prefixab  \\ gm     μ
  Prefixab  \\ gn     ν
  Prefixab  \\ gx     ξ
  Prefixab  \\ go     ο
  Prefixab  \\ gp     π
  Prefixab  \\ gr     ρ
  Prefixab  \\ gs     σ
  Prefixab  \\ gt     τ
  Prefixab  \\ gu     υ
  Prefixab  \\ gf     φ
  Prefixab  \\ gc     χ
  Prefixab  \\ gps    ψ
  Prefixab  \\ gw     ω

  Prefixab  \\ alpha       α
  Prefixab  \\ beta        β
  Prefixab  \\ gamma       γ
  Prefixab  \\ delta       δ
  Prefixab  \\ epsilon     ε
  Prefixab  \\ zeta        ζ
  Prefixab  \\ eta         η
  Prefixab  \\ theta       θ
  Prefixab  \\ iota        ι
  Prefixab  \\ kappa       κ
  Prefixab  \\ lambda      λ
  Prefixab  \\ mu          μ
  Prefixab  \\ nu          ν
  Prefixab  \\ xi          ξ
  Prefixab  \\ omicron     ο
  Prefixab  \\ pi          π
  Prefixab  \\ rho         ρ
  Prefixab  \\ sigma       σ
  Prefixab  \\ tau         τ
  Prefixab  \\ upsilon     υ
  Prefixab  \\ phi         φ
  Prefixab  \\ chi         χ
  Prefixab  \\ psi         ψ
  Prefixab  \\ omega       ω
  " }}}
  " }}}
 
  " Mathcal {{{
  Prefixab  \\ mcalA       𝓐
  Prefixab  \\ mcalB       𝓑
  Prefixab  \\ mcalC       𝓒
  Prefixab  \\ mcalD       𝓓
  Prefixab  \\ mcalE       𝓔
  Prefixab  \\ mcalF       𝓕
  Prefixab  \\ mcalG       𝓖
  Prefixab  \\ mcalH       𝓗
  Prefixab  \\ mcalI       𝓘
  Prefixab  \\ mcalJ       𝓙
  Prefixab  \\ mcalK       𝓚
  Prefixab  \\ mcalL       𝓛
  Prefixab  \\ mcalM       𝓜
  Prefixab  \\ mcalN       𝓝
  Prefixab  \\ mcalO       𝓞
  Prefixab  \\ mcalP       𝓟
  Prefixab  \\ mcalQ       𝓠
  Prefixab  \\ mcalR       𝓡
  Prefixab  \\ mcalS       𝓢
  Prefixab  \\ mcalT       𝓣
  Prefixab  \\ mcalU       𝓤
  Prefixab  \\ mcalV       𝓥
  Prefixab  \\ mcalW       𝓦
  Prefixab  \\ mcalX       𝓧
  Prefixab  \\ mcalY       𝓨
  Prefixab  \\ mcalZ       𝓩
  " }}}

  " Shapes {{{
  Prefixab  \\ box         □
  Prefixab  \\ bbox        ■
  Prefixab  \\ sbox        ▫
  Prefixab  \\ sbbox       ▪

  Prefixab  \\ square      □
  Prefixab  \\ bsquare     ■
  Prefixab  \\ ssquare     ▫
  Prefixab  \\ sbsquare    ▪

  Prefixab  \\ diamond     ◇
  Prefixab  \\ bdiamond    ◆
  Prefixab  \\ lozenge     ◊

  Prefixab  \\ circ        ○
  Prefixab  \\ circle      ○
  Prefixab  \\ bcircle     ●
  Prefixab  \\ dcircle     ◌

  Prefixab  \\ triangle    △
  Prefixab  \\ btriangle   ▲

  Prefixab  \\ skull       ☠
  Prefixab  \\ danger      ☡
  Prefixab  \\ radiation   ☢
  Prefixab  \\ biohazard   ☣
  Prefixab  \\ yinyang     ☯
  Prefixab  \\ frownie     ☹
  Prefixab  \\ smiley      ☺
  Prefixab  \\ blacksmiley ☻
  Prefixab  \\ sun         ☼
  Prefixab  \\ rightmoon   ☽
  Prefixab  \\ leftmoon    ☾
  Prefixab  \\ female      ♀
  Prefixab  \\ male        ♂
  " }}}

  " Miscellaneous {{{
  Prefixab  \\ dagger      †
  Prefixab  \\ ddager      ‡
  Prefixab  \\ prime       ′
  Prefixab  \\ second      ″
  Prefixab  \\ third       ‴
  Prefixab  \\ fourth      ⁗
  Prefixab  \\ euro        €
  " }}}

  " Math {{{
  Prefixab  \\ pm          ±
  Prefixab  \\ mp          ∓

  Prefixab  \\ sum         ∑
  Prefixab  \\ prod        ∏
  Prefixab  \\ coprod      ∐

  Prefixab  \\ qed         ∎
  Prefixab  \\ ast         ∗
  Prefixab  \\ times       ×
  Prefixab  \\ div         ÷
  Prefixab  \\ bullet      •
  Prefixab  \\ comp        ∘
  Prefixab  \\ cdot        ∙
  Noprefixab \.            ∙
  Noprefixab \:            ∶
  Noprefixab \::           ∷
  Prefixab  \\ sqrt        √
  Prefixab  \\ sqrt3       ∛
  Prefixab  \\ sqrt4       ∜
  Prefixab  \\ inf         ∞
  Prefixab  \\ propto      ∝
  Prefixab  \\ pitchfork   ⋔

  Prefixab  \\ forall      ∀
  Prefixab  \\ all         ∀
  Prefixab  \\ exists      ∃
  Prefixab  \\ ex          ∃
  Prefixab  \\ nexists     ∄
  Prefixab  \\ nex         ∄

  " Brackets {{{
  Prefixab  \\ lceil        ⌈
  Prefixab  \\ rceil        ⌉

  Prefixab  \\ lfloor       ⌊
  Prefixab  \\ rfloor       ⌋

  Prefixab  \\ langle       ⟨
  Prefixab  \\ rangle       ⟩

  Prefixab  \\ llens        ⦇
  Prefixab  \\ rlens        ⦈

  Noprefixab \[[            ⟦
  Noprefixab \]]            ⟧
  " }}}


  " Sets {{{
  Prefixab  \\ empty       ∅
  Prefixab  \\ emptyset    ∅
  Prefixab  \\ in          ∈
  Prefixab  \\ notin       ∉

  Prefixab  \\ inters      ∩
  Prefixab  \\ cap         ∩
  Prefixab  \\ union       ∪
  Prefixab  \\ cup         ∪

  Prefixab  \\ subset      ⊂
  Prefixab  \\ supset      ⊃
  Prefixab  \\ nsubset     ⊄
  Prefixab  \\ nsupset     ⊅
  Prefixab  \\ subseteq    ⊆
  Prefixab  \\ supseteq    ⊇
  Prefixab  \\ nsubseteq   ⊈
  Prefixab  \\ nsupseteq   ⊉
  " }}}

  " Lattices {{{
  Prefixab  \\ sqsubset    ⊏
  Prefixab  \\ sqsupset    ⊐
  Prefixab  \\ sqsubseteq  ⊑
  Prefixab  \\ sqsupseteq  ⊒
  Prefixab  \\ sqcap       ⊓
  Prefixab  \\ sqcup       ⊔
  " }}}

  " Logic {{{
  Prefixab  \\ land        ∧
  Prefixab  \\ and         ∧
  Prefixab  \\ lor         ∨
  Prefixab  \\ or          ∨
  Prefixab  \\ lnot        ¬
  Prefixab  \\ not         ¬
  Prefixab  \\ neg         ¬

  Prefixab  \\ top         ⊤
  Prefixab  \\ bot         ⊥

  Prefixab  \\ multimap    ⊸
  Noprefixab \-o           ⊸
  Prefixab  \\ multimapinv ⟜
  Prefixab  \\ invmultimap ⟜

  Prefixab  \\ parr        ⅋
  Prefixab  \\ invamp      ⅋

  Prefixab  \\ therefore   ∴
  Prefixab  \\ because     ∵
  " }}}

  " Calculus {{{
  Prefixab  \\ nabla       ∇
  Prefixab  \\ grad        ∇
  Prefixab  \\ partial     𝜕
  Prefixab  \\ increment   ∆
  Prefixab  \\ inc         ∆

  Prefixab  \\ int         ∫
  Prefixab  \\ iint        ∬
  Prefixab  \\ iiint       ∭
  Prefixab  \\ oint        ∮
  Prefixab  \\ oiint       ∯
  Prefixab  \\ oiiint      ∰
  " }}}

  " Equalities {{{
  Prefixab  \\ sim         ∼
  Prefixab  \\ nsim        ≁
  Noprefixab \~            ∼
  Noprefixab \~n           ≁

  Prefixab  \\ simeq       ≃
  Prefixab  \\ nsimeq      ≄
  Noprefixab \=~           ≃
  Noprefixab \=~n          ≄

  Prefixab  \\ cong        ≅
  Prefixab  \\ ncong       ≇
  Prefixab  \\ iso         ≅
  Prefixab  \\ niso        ≇
  Noprefixab \==~          ≅
  Noprefixab \==~n         ≇

  Prefixab  \\ approx      ≈
  Prefixab  \\ napprox     ≉
  Noprefixab \~2           ≈
  Noprefixab \~2n          ≉

  Prefixab  \\ neq         ≠
  Noprefixab \=n           ≠
  Noprefixab \!=           ≠
  Noprefixab \/=           ≠

  Prefixab  \\ equiv       ≡
  Prefixab  \\ nequiv      ≢
  Noprefixab \===          ≡
  Noprefixab \===n         ≢

  Prefixab  \\ Equiv       ≣
  " }}}

  " Inequalities {{{
  Prefixab  \\ leq         ≤
  Prefixab  \\ nleq        ≰
  Noprefixab \<=         ≤
  Noprefixab \<=n        ≰

  Prefixab  \\ geq         ≥
  Prefixab  \\ ngeq        ≱
  Noprefixab \>=         ≥
  Noprefixab \>=n        ≱

  Prefixab  \\ ll          «
  Noprefixab \<<           «
  Prefixab  \\ lll         ⋘

  Noprefixab \>>           »
  Prefixab  \\ ggg         ⋙
  " }}}

  " Entailment (turnstiles) {{{
  Prefixab  \\ ent         ⊢
  Prefixab  \\ entails     ⊢
  Prefixab  \\ nent        ⊬
  Prefixab  \\ nentails    ⊬
  Prefixab  \\ vdash       ⊢
  Prefixab  \\ nvdash      ⊬
  Noprefixab \\\|-         ⊢
  Noprefixab \\\|-n        ⊬

  Prefixab  \\ dashv       ⊣
  Noprefixab \-\|          ⊣

  Prefixab  \\ models      ⊨
  Prefixab  \\ vDash       ⊨
  Prefixab  \\ nvDash      ⊭
  Noprefixab \\\|=         ⊨
  Noprefixab \\\|=n        ⊭

  Prefixab  \\ Vdash       ⊩
  Prefixab  \\ nVdash      ⊮
  Noprefixab \\\|\|-       ⊩
  Noprefixab \\\|\|-n      ⊮

  Prefixab  \\ VDash       ⊫
  Prefixab  \\ nVDash      ⊯
  Noprefixab \\\|\|=       ⊫
  Noprefixab \\\|\|=n      ⊯

  Prefixab  \\ Vvdash      ⊪
  Noprefixab \\\|\|\|-     ⊪
  " }}}

  " Circled operators {{{
  Prefixab  \\ oplus       ⊕
  Prefixab  \\ ominus      ⊖
  Prefixab  \\ otimes      ⊗
  Prefixab  \\ oslash      ⊘
  Prefixab  \\ odot        ⊙
  Prefixab  \\ ocirc       ⊚
  Prefixab  \\ oast        ⊛
  Prefixab  \\ oequal      ⊜

  Noprefixab \o+           ⊕
  Noprefixab \o-           ⊖
  Prefixab  \\ ox          ⊗
  Noprefixab \o/           ⊘
  Noprefixab \o.           ⊙
  Prefixab  \\ oo          ⊚
  Noprefixab \o*           ⊛
  Noprefixab \o=           ⊜
  " }}}

  " Boxed operators {{{
  Prefixab  \\ boxplus     ⊞
  Prefixab  \\ boxminus    ⊟
  Prefixab  \\ boxtimes    ⊠
  Prefixab  \\ boxdot      ⊡

  Prefixab  \\ bplus       ⊞
  Prefixab  \\ bminus      ⊟
  Prefixab  \\ btimes      ⊠
  Prefixab  \\ bdot        ⊡

  Noprefixab \b+           ⊞
  Noprefixab \b-           ⊟
  Prefixab  \\ bx          ⊠
  Noprefixab \b.           ⊡
  " }}}
  " }}}

  " Dots {{{
  Prefixab  \\ ldots       …
  Noprefixab \...          …
  Prefixab  \\ cdots       ⋯
  Prefixab  \\ vdots       ⋮
  Prefixab  \\ iddots      ⋰
  Prefixab  \\ ddots       ⋱
  " }}}

  " Arrows {{{

  " Simple {{{
  Prefixab  \\ mapsto      ↦

  Prefixab  \\ to          →
  Prefixab  \\ arrow       →
  Prefixab  \\ rarrow      →
  Prefixab  \\ rightarrow  →
  Prefixab  \\ larrow      ←
  Prefixab  \\ leftarrow   ←
  Prefixab  \\ uarrow      ↑
  Prefixab  \\ uparrow     ↑
  Prefixab  \\ darrow      ↓
  Prefixab  \\ downarrow   ↓
  Prefixab  \\ lrarrow     ↔
  Prefixab  \\ leftrightarrow ↔
  Prefixab  \\ udarrow     ↕
  Prefixab  \\ updownarrow ↕
  Prefixab  \\ nwarrow     ↖
  Prefixab  \\ nearrow     ↗
  Prefixab  \\ searrow     ↘
  Prefixab  \\ swarrow     ↙

  Noprefixab \->           →
  Noprefixab \<-           ←
  Noprefixab \-v           ↓
  Noprefixab \-^           ↑
  Noprefixab \-!           ↑
  Noprefixab \<->          ↔
  Noprefixab \^-v          ↕
  Noprefixab \!-v          ↕
  " }}}

  " Double {{{
  Prefixab  \\ To          ⇒
  Prefixab  \\ Arrow       ⇒
  Prefixab  \\ Rarrow      ⇒
  Prefixab  \\ Rightarrow  ⇒
  Prefixab  \\ Larrow      ⇐
  Prefixab  \\ Leftarrow   ⇐
  Prefixab  \\ Uarrow      ⇑
  Prefixab  \\ Uparrow     ⇑
  Prefixab  \\ Darrow      ⇓
  Prefixab  \\ Downarrow   ⇓
  Prefixab  \\ Lrarrow     ⇔
  Prefixab  \\ Leftrightarrow ⇔
  Prefixab  \\ Udarrow     ⇕
  Prefixab  \\ Updownarrow ⇕
  Prefixab  \\ Nwarrow     ⇖
  Prefixab  \\ Nearrow     ⇗
  Prefixab  \\ Searrow     ⇘
  Prefixab  \\ Swarrow     ⇙

  Noprefixab \=>           ⇒
  Noprefixab \=<           ⇐
  Noprefixab \=v           ⇓
  Noprefixab \=^           ⇑
  Noprefixab \=!           ⇑
  Noprefixab \<=>          ⇔
  Noprefixab \^=v          ⇕
  Noprefixab \!=v          ⇕
  " }}}
  " }}}

  " Sets {{{
  Prefixab  \\ bb          𝔹
  Prefixab  \\ bn          ℕ
  Prefixab  \\ bz          ℤ
  Prefixab  \\ bq          ℚ
  Prefixab  \\ br          ℝ
  Prefixab  \\ bc          ℂ
  Prefixab  \\ bp          ℙ

  Prefixab  \\ Bool        𝔹
  Prefixab  \\ Bools       𝔹
  Prefixab  \\ Nats        ℕ
  Prefixab  \\ Ints        ℤ
  Prefixab  \\ Rats        ℚ
  Prefixab  \\ Comps       ℂ
  Prefixab  \\ Quats       ℍ

  Prefixab  \\ Boolean     𝔹
  Prefixab  \\ Booleans    𝔹
  Prefixab  \\ Integers    ℤ
  Prefixab  \\ Rationals   ℚ
  Prefixab  \\ Reals       ℝ
  Prefixab  \\ Complex     ℂ
  Prefixab  \\ Complexes   ℂ
  Prefixab  \\ Quaternions ℍ
  Prefixab  \\ Primes      ℙ
  " }}}

  " Fractions {{{
  Prefixab  \\ frac14      ¼
  Prefixab  \\ frac12      ½
  Prefixab  \\ frac34      ¾
  Prefixab  \\ frac13      ⅓
  Prefixab  \\ frac23      ⅔
  Prefixab  \\ frac15      ⅕
  Prefixab  \\ frac25      ⅖
  Prefixab  \\ frac35      ⅗
  Prefixab  \\ frac45      ⅘
  Prefixab  \\ frac16      ⅙
  Prefixab  \\ frac56      ⅚
  Prefixab  \\ frac18      ⅛
  Prefixab  \\ frac38      ⅜
  Prefixab  \\ frac58      ⅝
  Prefixab  \\ frac78      ⅞
  " }}}

  " Subscripts {{{
  Prefixab  \\ _a          ₐ
  Prefixab  \\ _e          ₑ
  Prefixab  \\ _h          ₕ
  Prefixab  \\ _i          ᵢ
  Prefixab  \\ _j          ⱼ
  Prefixab  \\ _k          ₖ
  Prefixab  \\ _l          ₗ
  Prefixab  \\ _m          ₘ
  Prefixab  \\ _n          ₙ
  Prefixab  \\ _o          ₒ
  Prefixab  \\ _p          ₚ
  Prefixab  \\ _r          ᵣ
  Prefixab  \\ _s          ₛ
  Prefixab  \\ _t          ₜ
  Prefixab  \\ _u          ᵤ
  Prefixab  \\ _v          ᵥ
  Prefixab  \\ _x          ₓ

  Prefixab  \\ _0          ₀
  Prefixab  \\ _1          ₁
  Prefixab  \\ _2          ₂
  Prefixab  \\ _3          ₃
  Prefixab  \\ _4          ₄
  Prefixab  \\ _5          ₅
  Prefixab  \\ _6          ₆
  Prefixab  \\ _7          ₇
  Prefixab  \\ _8          ₈
  Prefixab  \\ _9          ₉
  Noprefixab \_+           ₊
  Noprefixab \_-           ₋
  Noprefixab \_=           ₌
  Noprefixab \_(           ₍
  Noprefixab \_)           ₎
  " }}}

  " Superscripts {{{
  Noprefixab \^a           ᵃ
  Noprefixab \^b           ᵇ
  Noprefixab \^c           ᶜ
  Noprefixab \^d           ᵈ
  Noprefixab \^e           ᵉ
  Noprefixab \^f           ᶠ
  Noprefixab \^g           ᵍ
  Noprefixab \^h           ʰ
  Noprefixab \^i           ⁱ
  Noprefixab \^j           ʲ
  Noprefixab \^k           ᵏ
  Noprefixab \^l           ˡ
  Noprefixab \^m           ᵐ
  Noprefixab \^n           ⁿ
  Noprefixab \^o           ᵒ
  Noprefixab \^p           ᵖ
  Noprefixab \^r           ʳ
  Noprefixab \^s           ˢ
  Noprefixab \^t           ᵗ
  Noprefixab \^u           ᵘ
  Noprefixab \^v           ᵛ
  Noprefixab \^w           ʷ
  Noprefixab \^x           ˣ
  Noprefixab \^y           ʸ
  Noprefixab \^z           ᶻ

  Noprefixab \^A           ᴬ
  Noprefixab \^B           ᴮ
  Noprefixab \^D           ᴰ
  Noprefixab \^E           ᴱ
  Noprefixab \^G           ᴳ
  Noprefixab \^H           ᴴ
  Noprefixab \^I           ᴵ
  Noprefixab \^J           ᴶ
  Noprefixab \^K           ᴷ
  Noprefixab \^L           ᴸ
  Noprefixab \^M           ᴹ
  Noprefixab \^N           ᴺ
  Noprefixab \^O           ᴼ
  Noprefixab \^P           ᴾ
  Noprefixab \^R           ᴿ
  Noprefixab \^T           ᵀ
  Noprefixab \^U           ᵁ
  Noprefixab \^V           ⱽ
  Noprefixab \^W           ᵂ

  Noprefixab \^0           ⁰
  Noprefixab \^1           ¹
  Noprefixab \^2           ²
  Noprefixab \^3           ³
  Noprefixab \^4           ⁴
  Noprefixab \^5           ⁵
  Noprefixab \^6           ⁶
  Noprefixab \^7           ⁷
  Noprefixab \^8           ⁸
  Noprefixab \^9           ⁹
  Noprefixab \^+           ⁺
  Noprefixab \^-           ⁻
  Noprefixab \^=           ⁼
  Noprefixab \^(           ⁽
  Noprefixab \^)           ⁾
  " }}}

  " Circled {{{

  " Numbers {{{
  Noprefixab \(0)          ⓪
  Noprefixab \(1)          ①
  Noprefixab \(2)          ②
  Noprefixab \(3)          ③
  Noprefixab \(4)          ④
  Noprefixab \(5)          ⑤
  Noprefixab \(6)          ⑥
  Noprefixab \(7)          ⑦
  Noprefixab \(8)          ⑧
  Noprefixab \(9)          ⑨
  Noprefixab \(10)         ⑩
  Noprefixab \(11)         ⑪
  Noprefixab \(12)         ⑫
  Noprefixab \(13)         ⑬
  Noprefixab \(14)         ⑭
  Noprefixab \(15)         ⑮
  Noprefixab \(16)         ⑯
  Noprefixab \(17)         ⑰
  Noprefixab \(18)         ⑱
  Noprefixab \(19)         ⑲
  Noprefixab \(20)         ⑳
  " }}}

  " Uppercase {{{
  Noprefixab \(A)          Ⓐ
  Noprefixab \(B)          Ⓑ
  Noprefixab \(C)          Ⓒ
  Noprefixab \(D)          Ⓓ
  Noprefixab \(E)          Ⓔ
  Noprefixab \(F)          Ⓕ
  Noprefixab \(G)          Ⓖ
  Noprefixab \(H)          Ⓗ
  Noprefixab \(I)          Ⓘ
  Noprefixab \(J)          Ⓙ
  Noprefixab \(K)          Ⓚ
  Noprefixab \(L)          Ⓛ
  Noprefixab \(M)          Ⓜ
  Noprefixab \(N)          Ⓝ
  Noprefixab \(O)          Ⓞ
  Noprefixab \(P)          Ⓟ
  Noprefixab \(Q)          Ⓠ
  Noprefixab \(R)          Ⓡ
  Noprefixab \(S)          Ⓢ
  Noprefixab \(T)          Ⓣ
  Noprefixab \(U)          Ⓤ
  Noprefixab \(V)          Ⓥ
  Noprefixab \(W)          Ⓦ
  Noprefixab \(X)          Ⓧ
  Noprefixab \(Y)          Ⓨ
  Noprefixab \(Z)          Ⓩ
  " }}}

  " Lowercase {{{
  Noprefixab \(a)          ⓐ
  Noprefixab \(b)          ⓑ
  Noprefixab \(c)          ⓒ
  Noprefixab \(d)          ⓓ
  Noprefixab \(e)          ⓔ
  Noprefixab \(f)          ⓕ
  Noprefixab \(g)          ⓖ
  Noprefixab \(h)          ⓗ
  Noprefixab \(i)          ⓘ
  Noprefixab \(j)          ⓙ
  Noprefixab \(k)          ⓚ
  Noprefixab \(l)          ⓛ
  Noprefixab \(m)          ⓜ
  Noprefixab \(n)          ⓝ
  Noprefixab \(o)          ⓞ
  Noprefixab \(p)          ⓟ
  Noprefixab \(q)          ⓠ
  Noprefixab \(r)          ⓡ
  Noprefixab \(s)          ⓢ
  Noprefixab \(t)          ⓣ
  Noprefixab \(u)          ⓤ
  Noprefixab \(v)          ⓥ
  Noprefixab \(w)          ⓦ
  Noprefixab \(x)          ⓧ
  Noprefixab \(y)          ⓨ
  Noprefixab \(z)          ⓩ
  " }}}
  " }}}

  " Font Awesome {{{
  Prefixab ` fa_twitter_square   
  Prefixab ` fa_facebook_square   
  Prefixab ` fa_linkedin_square   
  Prefixab ` fa_github_square   
  Prefixab ` fa_twitter   
  Prefixab ` fa_facebook   
  Prefixab ` fa_github   
  Prefixab ` fa_pinterest   
  Prefixab ` fa_pinterest_square   
  Prefixab ` fa_google_plus_square   
  Prefixab ` fa_google_plus   
  Prefixab ` fa_linkedin   
  Prefixab ` fa_github_alt   
  Prefixab ` fa_maxcdn   
  Prefixab ` fa_html5   
  Prefixab ` fa_css3   
  Prefixab ` fa_youtube_square   
  Prefixab ` fa_youtube   
  Prefixab ` fa_xing   
  Prefixab ` fa_xing_square   
  Prefixab ` fa_dropbox   
  Prefixab ` fa_stack_overflow   
  Prefixab ` fa_instagram   
  Prefixab ` fa_flickr   
  Prefixab ` fa_adn   
  Prefixab ` fa_bitbucket   
  Prefixab ` fa_bitbucket_square   
  Prefixab ` fa_tumblr   
  Prefixab ` fa_tumblr_square   
  Prefixab ` fa_apple   
  Prefixab ` fa_windows   
  Prefixab ` fa_android   
  Prefixab ` fa_linux   
  Prefixab ` fa_dribbble   
  Prefixab ` fa_skype   
  Prefixab ` fa_foursquare   
  Prefixab ` fa_trello   
  Prefixab ` fa_gratipay   
  Prefixab ` fa_vk   
  Prefixab ` fa_weibo   
  Prefixab ` fa_renren   
  Prefixab ` fa_pagelines   
  Prefixab ` fa_stack_exchange   
  Prefixab ` fa_vimeo_square   
  Prefixab ` fa_slack   
  Prefixab ` fa_wordpress   
  Prefixab ` fa_openid   
  Prefixab ` fa_yahoo   
  Prefixab ` fa_google   
  Prefixab ` fa_reddit   
  Prefixab ` fa_reddit_square   
  Prefixab ` fa_stumbleupon_circle   
  Prefixab ` fa_stumbleupon   
  Prefixab ` fa_delicious   
  Prefixab ` fa_digg   
  Prefixab ` fa_pied_piper_pp   
  Prefixab ` fa_pied_piper_alt   
  Prefixab ` fa_drupal   
  Prefixab ` fa_joomla   
  Prefixab ` fa_behance   
  Prefixab ` fa_behance_square   
  Prefixab ` fa_steam   
  Prefixab ` fa_steam_square   
  Prefixab ` fa_spotify   
  Prefixab ` fa_deviantart   
  Prefixab ` fa_soundcloud   
  Prefixab ` fa_vine   
  Prefixab ` fa_codepen   
  Prefixab ` fa_jsfiddle   
  Prefixab ` fa_rebel   
  Prefixab ` fa_empire   
  Prefixab ` fa_git_square   
  Prefixab ` fa_git   
  Prefixab ` fa_hacker_news   
  Prefixab ` fa_tencent_weibo   
  Prefixab ` fa_qq   
  Prefixab ` fa_weixin   
  Prefixab ` fa_slideshare   
  Prefixab ` fa_twitch   
  Prefixab ` fa_yelp   
  Prefixab ` fa_lastfm   
  Prefixab ` fa_lastfm_square   
  Prefixab ` fa_ioxhost   
  Prefixab ` fa_angellist   
  Prefixab ` fa_meanpath   
  Prefixab ` fa_buysellads   
  Prefixab ` fa_connectdevelop   
  Prefixab ` fa_dashcube   
  Prefixab ` fa_forumbee   
  Prefixab ` fa_leanpub   
  Prefixab ` fa_sellsy   
  Prefixab ` fa_shirtsinbulk   
  Prefixab ` fa_simplybuilt   
  Prefixab ` fa_skyatlas   
  Prefixab ` fa_facebook_official   
  Prefixab ` fa_pinterest_p   
  Prefixab ` fa_whatsapp   
  Prefixab ` fa_viacoin   
  Prefixab ` fa_medium   
  Prefixab ` fa_y_combinator   
  Prefixab ` fa_optin_monster   
  Prefixab ` fa_opencart   
  Prefixab ` fa_expeditedssl   
  Prefixab ` fa_tripadvisor   
  Prefixab ` fa_odnoklassniki   
  Prefixab ` fa_odnoklassniki_square   
  Prefixab ` fa_get_pocket   
  Prefixab ` fa_wikipedia_w   
  Prefixab ` fa_safari   
  Prefixab ` fa_chrome   
  Prefixab ` fa_firefox   
  Prefixab ` fa_opera   
  Prefixab ` fa_internet_explorer   
  Prefixab ` fa_contao   
  Prefixab ` fa_500px   
  Prefixab ` fa_amazon   
  Prefixab ` fa_houzz   
  Prefixab ` fa_vimeo   
  Prefixab ` fa_black_tie   
  Prefixab ` fa_fonticons   
  Prefixab ` fa_reddit_alien   
  Prefixab ` fa_edge   
  Prefixab ` fa_codiepie   
  Prefixab ` fa_modx   
  Prefixab ` fa_fort_awesome   
  Prefixab ` fa_usb   
  Prefixab ` fa_product_hunt   
  Prefixab ` fa_mixcloud   
  Prefixab ` fa_scribd   
  Prefixab ` fa_gitlab   
  Prefixab ` fa_wpbeginner   
  Prefixab ` fa_wpforms   
  Prefixab ` fa_envira   
  Prefixab ` fa_glide   
  Prefixab ` fa_glide_g   
  Prefixab ` fa_viadeo   
  Prefixab ` fa_viadeo_square   
  Prefixab ` fa_snapchat   
  Prefixab ` fa_snapchat_ghost   
  Prefixab ` fa_snapchat_square   
  Prefixab ` fa_pied_piper   
  Prefixab ` fa_first_order   
  Prefixab ` fa_yoast   
  Prefixab ` fa_themeisle   
  Prefixab ` fa_google_plus_official   
  Prefixab ` fa_font_awesome   
  Prefixab ` fa_linode   
  Prefixab ` fa_quora   
  Prefixab ` fa_free_code_camp   
  Prefixab ` fa_telegram   
  Prefixab ` fa_bandcamp   
  Prefixab ` fa_grav   
  Prefixab ` fa_etsy   
  Prefixab ` fa_imdb   
  Prefixab ` fa_ravelry   
  Prefixab ` fa_eercast   
  Prefixab ` fa_superpowers   
  Prefixab ` fa_wpexplorer   
  Prefixab ` fa_meetup   
  Prefixab ` fa_paypal   
  Prefixab ` fa_google_wallet   
  Prefixab ` fa_cc_visa   
  Prefixab ` fa_cc_mastercard   
  Prefixab ` fa_cc_discover   
  Prefixab ` fa_cc_amex   
  Prefixab ` fa_cc_paypal   
  Prefixab ` fa_cc_stripe   
  Prefixab ` fa_cc_jcb   
  Prefixab ` fa_cc_diners_club   
  Prefixab ` fa_youtube_play   
  Prefixab ` fa_eur   
  Prefixab ` fa_gbp   
  Prefixab ` fa_usd   
  Prefixab ` fa_inr   
  Prefixab ` fa_jpy   
  Prefixab ` fa_rub   
  Prefixab ` fa_krw   
  Prefixab ` fa_try   
  Prefixab ` fa_ils   
  Prefixab ` fa_btc   
  Prefixab ` fa_gg   
  Prefixab ` fa_gg_circle   
  Prefixab ` fa_arrow_circle_o_down   
  Prefixab ` fa_arrow_circle_o_up   
  Prefixab ` fa_chevron_left   
  Prefixab ` fa_chevron_right   
  Prefixab ` fa_arrow_left   
  Prefixab ` fa_arrow_right   
  Prefixab ` fa_arrow_up   
  Prefixab ` fa_arrow_down   
  Prefixab ` fa_chevron_up   
  Prefixab ` fa_chevron_down   
  Prefixab ` fa_arrow_circle_left   
  Prefixab ` fa_arrow_circle_right   
  Prefixab ` fa_arrow_circle_up   
  Prefixab ` fa_arrow_circle_down   
  Prefixab ` fa_caret_down   
  Prefixab ` fa_caret_up   
  Prefixab ` fa_caret_left   
  Prefixab ` fa_caret_right   
  Prefixab ` fa_angle_double_left   
  Prefixab ` fa_angle_double_right   
  Prefixab ` fa_angle_double_up   
  Prefixab ` fa_angle_double_down   
  Prefixab ` fa_angle_left   
  Prefixab ` fa_angle_right   
  Prefixab ` fa_angle_up   
  Prefixab ` fa_angle_down   
  Prefixab ` fa_chevron_circle_left   
  Prefixab ` fa_chevron_circle_right   
  Prefixab ` fa_chevron_circle_up   
  Prefixab ` fa_chevron_circle_down   
  Prefixab ` fa_long_arrow_down   
  Prefixab ` fa_long_arrow_up   
  Prefixab ` fa_long_arrow_left   
  Prefixab ` fa_long_arrow_right   
  Prefixab ` fa_arrow_circle_o_right   
  Prefixab ` fa_arrow_circle_o_left   
  Prefixab ` fa_hand_o_right   
  Prefixab ` fa_hand_o_left   
  Prefixab ` fa_hand_o_up   
  Prefixab ` fa_hand_o_down   
  Prefixab ` fa_venus   
  Prefixab ` fa_mars   
  Prefixab ` fa_mercury   
  Prefixab ` fa_transgender   
  Prefixab ` fa_transgender_alt   
  Prefixab ` fa_venus_double   
  Prefixab ` fa_mars_double   
  Prefixab ` fa_venus_mars   
  Prefixab ` fa_mars_stroke   
  Prefixab ` fa_mars_stroke_v   
  Prefixab ` fa_mars_stroke_h   
  Prefixab ` fa_neuter   
  Prefixab ` fa_genderless   
  Prefixab ` fa_user_md   
  Prefixab ` fa_stethoscope   
  Prefixab ` fa_hospital_o   
  Prefixab ` fa_medkit   
  Prefixab ` fa_h_square   
  Prefixab ` fa_ambulance   
  Prefixab ` fa_plus_square   
  Prefixab ` fa_credit_card_alt   
  Prefixab ` fa_th_large   
  Prefixab ` fa_th   
  Prefixab ` fa_th_list   
  Prefixab ` fa_repeat   
  Prefixab ` fa_list_alt   
  Prefixab ` fa_font   
  Prefixab ` fa_bold   
  Prefixab ` fa_italic   
  Prefixab ` fa_text_height   
  Prefixab ` fa_text_width   
  Prefixab ` fa_align_left   
  Prefixab ` fa_align_center   
  Prefixab ` fa_align_right   
  Prefixab ` fa_align_justify   
  Prefixab ` fa_list   
  Prefixab ` fa_outdent   
  Prefixab ` fa_indent   
  Prefixab ` fa_link   
  Prefixab ` fa_scissors   
  Prefixab ` fa_files_o   
  Prefixab ` fa_paperclip   
  Prefixab ` fa_floppy_o   
  Prefixab ` fa_list_ul   
  Prefixab ` fa_list_ol   
  Prefixab ` fa_strikethrough   
  Prefixab ` fa_underline   
  Prefixab ` fa_table   
  Prefixab ` fa_columns   
  Prefixab ` fa_undo   
  Prefixab ` fa_clipboard   
  Prefixab ` fa_chain_broken   
  Prefixab ` fa_superscript   
  Prefixab ` fa_subscript   
  Prefixab ` fa_header   
  Prefixab ` fa_paragraph   
  Prefixab ` fa_file_o   
  Prefixab ` fa_file_text_o   
  Prefixab ` fa_file   
  Prefixab ` fa_file_text   
  Prefixab ` fa_eraser   
  Prefixab ` fa_train   
  Prefixab ` fa_subway   
  Prefixab ` fa_play_circle_o   
  Prefixab ` fa_step_backward   
  Prefixab ` fa_fast_backward   
  Prefixab ` fa_backward   
  Prefixab ` fa_play   
  Prefixab ` fa_pause   
  Prefixab ` fa_stop   
  Prefixab ` fa_forward   
  Prefixab ` fa_fast_forward   
  Prefixab ` fa_step_forward   
  Prefixab ` fa_eject   
  Prefixab ` fa_expand   
  Prefixab ` fa_compress   
  Prefixab ` fa_play_circle   
  Prefixab ` fa_pause_circle   
  Prefixab ` fa_pause_circle_o   
  Prefixab ` fa_stop_circle   
  Prefixab ` fa_stop_circle_o   
  Prefixab ` fa_arrows_alt   
  Prefixab ` fa_glass   
  Prefixab ` fa_music   
  Prefixab ` fa_search   
  Prefixab ` fa_envelope_o   
  Prefixab ` fa_star   
  Prefixab ` fa_star_o   
  Prefixab ` fa_user   
  Prefixab ` fa_film   
  Prefixab ` fa_check   
  Prefixab ` fa_times   
  Prefixab ` fa_search_plus   
  Prefixab ` fa_search_minus   
  Prefixab ` fa_power_off   
  Prefixab ` fa_signal   
  Prefixab ` fa_trash_o   
  Prefixab ` fa_home   
  Prefixab ` fa_clock_o   
  Prefixab ` fa_road   
  Prefixab ` fa_download   
  Prefixab ` fa_inbox   
  Prefixab ` fa_lock   
  Prefixab ` fa_flag   
  Prefixab ` fa_headphones   
  Prefixab ` fa_volume_off   
  Prefixab ` fa_volume_down   
  Prefixab ` fa_volume_up   
  Prefixab ` fa_qrcode   
  Prefixab ` fa_barcode   
  Prefixab ` fa_tag   
  Prefixab ` fa_tags   
  Prefixab ` fa_book   
  Prefixab ` fa_bookmark   
  Prefixab ` fa_print   
  Prefixab ` fa_camera   
  Prefixab ` fa_video_camera   
  Prefixab ` fa_picture_o   
  Prefixab ` fa_pencil   
  Prefixab ` fa_map_marker   
  Prefixab ` fa_adjust   
  Prefixab ` fa_tint   
  Prefixab ` fa_pencil_square_o   
  Prefixab ` fa_share_square_o   
  Prefixab ` fa_plus_circle   
  Prefixab ` fa_minus_circle   
  Prefixab ` fa_times_circle   
  Prefixab ` fa_check_circle   
  Prefixab ` fa_question_circle   
  Prefixab ` fa_info_circle   
  Prefixab ` fa_crosshairs   
  Prefixab ` fa_times_circle_o   
  Prefixab ` fa_check_circle_o   
  Prefixab ` fa_ban   
  Prefixab ` fa_share   
  Prefixab ` fa_plus   
  Prefixab ` fa_minus   
  Prefixab ` fa_asterisk   
  Prefixab ` fa_exclamation_circle   
  Prefixab ` fa_gift   
  Prefixab ` fa_leaf   
  Prefixab ` fa_fire   
  Prefixab ` fa_eye   
  Prefixab ` fa_eye_slash   
  Prefixab ` fa_exclamation_triangle   
  Prefixab ` fa_calendar   
  Prefixab ` fa_comment   
  Prefixab ` fa_magnet   
  Prefixab ` fa_retweet   
  Prefixab ` fa_shopping_cart   
  Prefixab ` fa_folder   
  Prefixab ` fa_folder_open   
  Prefixab ` fa_camera_retro   
  Prefixab ` fa_key   
  Prefixab ` fa_cogs   
  Prefixab ` fa_comments   
  Prefixab ` fa_star_half   
  Prefixab ` fa_sign_out   
  Prefixab ` fa_thumb_tack   
  Prefixab ` fa_external_link   
  Prefixab ` fa_sign_in   
  Prefixab ` fa_trophy   
  Prefixab ` fa_upload   
  Prefixab ` fa_lemon_o   
  Prefixab ` fa_phone   
  Prefixab ` fa_bookmark_o   
  Prefixab ` fa_phone_square   
  Prefixab ` fa_unlock   
  Prefixab ` fa_rss   
  Prefixab ` fa_hdd_o   
  Prefixab ` fa_bullhorn   
  Prefixab ` fa_bell_o   
  Prefixab ` fa_certificate   
  Prefixab ` fa_globe   
  Prefixab ` fa_wrench   
  Prefixab ` fa_tasks   
  Prefixab ` fa_filter   
  Prefixab ` fa_briefcase   
  Prefixab ` fa_users   
  Prefixab ` fa_cloud   
  Prefixab ` fa_flask   
  Prefixab ` fa_bars   
  Prefixab ` fa_magic   
  Prefixab ` fa_sort   
  Prefixab ` fa_sort_desc   
  Prefixab ` fa_sort_asc   
  Prefixab ` fa_envelope   
  Prefixab ` fa_gavel   
  Prefixab ` fa_tachometer   
  Prefixab ` fa_comment_o   
  Prefixab ` fa_comments_o   
  Prefixab ` fa_bolt   
  Prefixab ` fa_sitemap   
  Prefixab ` fa_umbrella   
  Prefixab ` fa_lightbulb_o   
  Prefixab ` fa_cloud_download   
  Prefixab ` fa_cloud_upload   
  Prefixab ` fa_suitcase   
  Prefixab ` fa_bell   
  Prefixab ` fa_coffee   
  Prefixab ` fa_cutlery   
  Prefixab ` fa_building_o   
  Prefixab ` fa_beer   
  Prefixab ` fa_desktop   
  Prefixab ` fa_laptop   
  Prefixab ` fa_tablet   
  Prefixab ` fa_mobile   
  Prefixab ` fa_quote_left   
  Prefixab ` fa_quote_right   
  Prefixab ` fa_reply   
  Prefixab ` fa_folder_o   
  Prefixab ` fa_folder_open_o   
  Prefixab ` fa_smile_o   
  Prefixab ` fa_frown_o   
  Prefixab ` fa_meh_o   
  Prefixab ` fa_gamepad   
  Prefixab ` fa_keyboard_o   
  Prefixab ` fa_flag_o   
  Prefixab ` fa_flag_checkered   
  Prefixab ` fa_terminal   
  Prefixab ` fa_code   
  Prefixab ` fa_reply_all   
  Prefixab ` fa_star_half_o   
  Prefixab ` fa_location_arrow   
  Prefixab ` fa_crop   
  Prefixab ` fa_code_fork   
  Prefixab ` fa_question   
  Prefixab ` fa_info   
  Prefixab ` fa_exclamation   
  Prefixab ` fa_puzzle_piece   
  Prefixab ` fa_microphone   
  Prefixab ` fa_microphone_slash   
  Prefixab ` fa_shield   
  Prefixab ` fa_calendar_o   
  Prefixab ` fa_fire_extinguisher   
  Prefixab ` fa_anchor   
  Prefixab ` fa_unlock_alt   
  Prefixab ` fa_bullseye   
  Prefixab ` fa_ellipsis_h   
  Prefixab ` fa_ellipsis_v   
  Prefixab ` fa_rss_square   
  Prefixab ` fa_ticket   
  Prefixab ` fa_level_up   
  Prefixab ` fa_level_down   
  Prefixab ` fa_pencil_square   
  Prefixab ` fa_external_link_square   
  Prefixab ` fa_share_square   
  Prefixab ` fa_compass   
  Prefixab ` fa_sort_alpha_asc   
  Prefixab ` fa_sort_alpha_desc   
  Prefixab ` fa_sort_amount_asc   
  Prefixab ` fa_sort_amount_desc   
  Prefixab ` fa_sort_numeric_asc   
  Prefixab ` fa_sort_numeric_desc   
  Prefixab ` fa_female   
  Prefixab ` fa_male   
  Prefixab ` fa_sun_o   
  Prefixab ` fa_moon_o   
  Prefixab ` fa_archive   
  Prefixab ` fa_bug   
  Prefixab ` fa_envelope_square   
  Prefixab ` fa_university   
  Prefixab ` fa_graduation_cap   
  Prefixab ` fa_language   
  Prefixab ` fa_fax   
  Prefixab ` fa_building   
  Prefixab ` fa_child   
  Prefixab ` fa_paw   
  Prefixab ` fa_spoon   
  Prefixab ` fa_cube   
  Prefixab ` fa_cubes   
  Prefixab ` fa_recycle   
  Prefixab ` fa_tree   
  Prefixab ` fa_database   
  Prefixab ` fa_life_ring   
  Prefixab ` fa_paper_plane   
  Prefixab ` fa_paper_plane_o   
  Prefixab ` fa_history   
  Prefixab ` fa_circle_thin   
  Prefixab ` fa_sliders   
  Prefixab ` fa_bomb   
  Prefixab ` fa_futbol_o   
  Prefixab ` fa_binoculars   
  Prefixab ` fa_plug   
  Prefixab ` fa_newspaper_o   
  Prefixab ` fa_wifi   
  Prefixab ` fa_calculator   
  Prefixab ` fa_bell_slash   
  Prefixab ` fa_bell_slash_o   
  Prefixab ` fa_trash   
  Prefixab ` fa_copyright   
  Prefixab ` fa_at   
  Prefixab ` fa_eyedropper   
  Prefixab ` fa_paint_brush   
  Prefixab ` fa_birthday_cake   
  Prefixab ` fa_toggle_off   
  Prefixab ` fa_toggle_on   
  Prefixab ` fa_cart_plus   
  Prefixab ` fa_cart_arrow_down   
  Prefixab ` fa_diamond   
  Prefixab ` fa_user_secret   
  Prefixab ` fa_street_view   
  Prefixab ` fa_server   
  Prefixab ` fa_user_plus   
  Prefixab ` fa_user_times   
  Prefixab ` fa_bed   
  Prefixab ` fa_battery_full   
  Prefixab ` fa_battery_three_quarters   
  Prefixab ` fa_battery_half   
  Prefixab ` fa_battery_quarter   
  Prefixab ` fa_battery_empty   
  Prefixab ` fa_mouse_pointer   
  Prefixab ` fa_i_cursor   
  Prefixab ` fa_object_group   
  Prefixab ` fa_object_ungroup   
  Prefixab ` fa_sticky_note   
  Prefixab ` fa_sticky_note_o   
  Prefixab ` fa_clone   
  Prefixab ` fa_balance_scale   
  Prefixab ` fa_hourglass_o   
  Prefixab ` fa_hourglass_start   
  Prefixab ` fa_hourglass_half   
  Prefixab ` fa_hourglass_end   
  Prefixab ` fa_hourglass   
  Prefixab ` fa_trademark   
  Prefixab ` fa_registered   
  Prefixab ` fa_creative_commons   
  Prefixab ` fa_television   
  Prefixab ` fa_calendar_plus_o   
  Prefixab ` fa_calendar_minus_o   
  Prefixab ` fa_calendar_times_o   
  Prefixab ` fa_calendar_check_o   
  Prefixab ` fa_industry   
  Prefixab ` fa_map_pin   
  Prefixab ` fa_map_signs   
  Prefixab ` fa_map_o   
  Prefixab ` fa_map   
  Prefixab ` fa_commenting   
  Prefixab ` fa_commenting_o   
  Prefixab ` fa_shopping_bag   
  Prefixab ` fa_shopping_basket   
  Prefixab ` fa_hashtag   
  Prefixab ` fa_percent   
  Prefixab ` fa_handshake_o   
  Prefixab ` fa_envelope_open   
  Prefixab ` fa_envelope_open_o   
  Prefixab ` fa_address_book   
  Prefixab ` fa_address_book_o   
  Prefixab ` fa_address_card   
  Prefixab ` fa_address_card_o   
  Prefixab ` fa_user_circle   
  Prefixab ` fa_user_circle_o   
  Prefixab ` fa_user_o   
  Prefixab ` fa_id_badge   
  Prefixab ` fa_id_card   
  Prefixab ` fa_id_card_o   
  Prefixab ` fa_thermometer_full   
  Prefixab ` fa_thermometer_three_quarters   
  Prefixab ` fa_thermometer_half   
  Prefixab ` fa_thermometer_quarter   
  Prefixab ` fa_thermometer_empty   
  Prefixab ` fa_shower   
  Prefixab ` fa_bath   
  Prefixab ` fa_podcast   
  Prefixab ` fa_window_maximize   
  Prefixab ` fa_window_minimize   
  Prefixab ` fa_window_restore   
  Prefixab ` fa_window_close   
  Prefixab ` fa_window_close_o   
  Prefixab ` fa_microchip   
  Prefixab ` fa_snowflake_o   
  Prefixab ` fa_tty   
  Prefixab ` fa_cc   
  Prefixab ` fa_universal_access   
  Prefixab ` fa_question_circle_o   
  Prefixab ` fa_blind   
  Prefixab ` fa_audio_description   
  Prefixab ` fa_volume_control_phone   
  Prefixab ` fa_braille   
  Prefixab ` fa_assistive_listening_systems   
  Prefixab ` fa_american_sign_language_interpreting   
  Prefixab ` fa_deaf   
  Prefixab ` fa_sign_language   
  Prefixab ` fa_low_vision   
  Prefixab ` fa_share_alt   
  Prefixab ` fa_share_alt_square   
  Prefixab ` fa_bluetooth   
  Prefixab ` fa_bluetooth_b   
  Prefixab ` fa_bar_chart   
  Prefixab ` fa_area_chart   
  Prefixab ` fa_pie_chart   
  Prefixab ` fa_line_chart   
  Prefixab ` fa_money   
  Prefixab ` fa_arrows   
  Prefixab ` fa_arrows_v   
  Prefixab ` fa_arrows_h   
  Prefixab ` fa_exchange   
  Prefixab ` fa_caret_square_o_down   
  Prefixab ` fa_caret_square_o_up   
  Prefixab ` fa_caret_square_o_right   
  Prefixab ` fa_caret_square_o_left   
  Prefixab ` fa_file_pdf_o   
  Prefixab ` fa_file_word_o   
  Prefixab ` fa_file_excel_o   
  Prefixab ` fa_file_powerpoint_o   
  Prefixab ` fa_file_image_o   
  Prefixab ` fa_file_archive_o   
  Prefixab ` fa_file_audio_o   
  Prefixab ` fa_file_video_o   
  Prefixab ` fa_file_code_o   
  Prefixab ` fa_check_square_o   
  Prefixab ` fa_square_o   
  Prefixab ` fa_square   
  Prefixab ` fa_circle_o   
  Prefixab ` fa_circle   
  Prefixab ` fa_minus_square   
  Prefixab ` fa_minus_square_o   
  Prefixab ` fa_check_square   
  Prefixab ` fa_dot_circle_o   
  Prefixab ` fa_plus_square_o   
  Prefixab ` fa_thumbs_o_up   
  Prefixab ` fa_thumbs_o_down   
  Prefixab ` fa_thumbs_up   
  Prefixab ` fa_thumbs_down   
  Prefixab ` fa_hand_rock_o   
  Prefixab ` fa_hand_paper_o   
  Prefixab ` fa_hand_scissors_o   
  Prefixab ` fa_hand_lizard_o   
  Prefixab ` fa_hand_spock_o   
  Prefixab ` fa_hand_pointer_o   
  Prefixab ` fa_hand_peace_o   
  Prefixab ` fa_heart   
  Prefixab ` fa_heart_o   
  Prefixab ` fa_heartbeat   
  Prefixab ` fa_wheelchair   
  Prefixab ` fa_wheelchair_alt   
  Prefixab ` fa_credit_card   
  Prefixab ` fa_cog   
  Prefixab ` fa_refresh   
  Prefixab ` fa_spinner   
  Prefixab ` fa_circle_o_notch   
  Prefixab ` fa_plane   
  Prefixab ` fa_truck   
  Prefixab ` fa_fighter_jet   
  Prefixab ` fa_rocket   
  Prefixab ` fa_space_shuttle   
  Prefixab ` fa_car   
  Prefixab ` fa_taxi   
  Prefixab ` fa_bicycle   
  Prefixab ` fa_bus   
  Prefixab ` fa_ship   
  Prefixab ` fa_motorcycle   
  Prefixab ` fa_random   
  " }}}
  " Emoji {{{
  Prefixab ` p1  👍
  Prefixab ` m1  👎
  Prefixab ` 100  💯
  Prefixab ` 1234  🔢
  Prefixab ` 8ball  🎱
  Prefixab ` a  🅰
  Prefixab ` ab  🆎
  Prefixab ` abc  🔤
  Prefixab ` abcd  🔡
  Prefixab ` accept  🉑
  Prefixab ` admission_tickets  🎟
  Prefixab ` adult  🧑
  Prefixab ` aerial_tramway  🚡
  Prefixab ` airplane  ✈
  Prefixab ` airplane_arriving  🛬
  Prefixab ` airplane_departure  🛫
  Prefixab ` alarm_clock  ⏰
  Prefixab ` alembic  ⚗
  Prefixab ` alien  👽
  Prefixab ` ambulance  🚑
  Prefixab ` amphora  🏺
  Prefixab ` anchor  ⚓
  Prefixab ` angel  👼
  Prefixab ` anger  💢
  Prefixab ` angry  😠
  Prefixab ` anguished  😧
  Prefixab ` ant  🐜
  Prefixab ` apple  🍎
  Prefixab ` aquarius  ♒
  Prefixab ` aries  ♈
  Prefixab ` arrow_backward  ◀
  Prefixab ` arrow_double_down  ⏬
  Prefixab ` arrow_double_up  ⏫
  Prefixab ` arrow_down  ⬇
  Prefixab ` arrow_down_small  🔽
  Prefixab ` arrow_forward  ▶
  Prefixab ` arrow_heading_down  ⤵
  Prefixab ` arrow_heading_up  ⤴
  Prefixab ` arrow_left  ⬅
  Prefixab ` arrow_lower_left  ↙
  Prefixab ` arrow_lower_right  ↘
  Prefixab ` arrow_right  ➡
  Prefixab ` arrow_right_hook  ↪
  Prefixab ` arrow_up  ⬆
  Prefixab ` arrow_up_down  ↕
  Prefixab ` arrow_up_small  🔼
  Prefixab ` arrow_upper_left  ↖
  Prefixab ` arrow_upper_right  ↗
  Prefixab ` arrows_clockwise  🔃
  Prefixab ` arrows_counterclockwise  🔄
  Prefixab ` art  🎨
  Prefixab ` articulated_lorry  🚛
  Prefixab ` astonished  😲
  Prefixab ` athletic_shoe  👟
  Prefixab ` atm  🏧
  Prefixab ` atom_symbol  ⚛
  Prefixab ` avocado  🥑
  Prefixab ` b  🅱
  Prefixab ` baby  👶
  Prefixab ` baby_bottle  🍼
  Prefixab ` baby_chick  🐤
  Prefixab ` baby_symbol  🚼
  Prefixab ` back  🔙
  Prefixab ` bacon  🥓
  Prefixab ` badminton_racquet_and_shuttlecock  🏸
  Prefixab ` baggage_claim  🛄
  Prefixab ` baguette_bread  🥖
  Prefixab ` balloon  🎈
  Prefixab ` ballot_box_with_ballot  🗳
  Prefixab ` ballot_box_with_check  ☑
  Prefixab ` bamboo  🎍
  Prefixab ` banana  🍌
  Prefixab ` bangbang  ‼
  Prefixab ` bank  🏦
  Prefixab ` bar_chart  📊
  Prefixab ` barber  💈
  Prefixab ` barely_sunny  🌥
  Prefixab ` baseball  ⚾
  Prefixab ` basketball  🏀
  Prefixab ` bat  🦇
  Prefixab ` bath  🛀
  Prefixab ` bathtub  🛁
  Prefixab ` battery  🔋
  Prefixab ` beach_with_umbrella  🏖
  Prefixab ` bear  🐻
  Prefixab ` bearded_person  🧔
  Prefixab ` bed  🛏
  Prefixab ` bee  🐝
  Prefixab ` beer  🍺
  Prefixab ` beers  🍻
  Prefixab ` beetle  🐞
  Prefixab ` beginner  🔰
  Prefixab ` bell  🔔
  Prefixab ` bellhop_bell  🛎
  Prefixab ` bento  🍱
  Prefixab ` bicyclist  🚴
  Prefixab ` bike  🚲
  Prefixab ` bikini  👙
  Prefixab ` billed_cap  🧢
  Prefixab ` biohazard_sign  ☣
  Prefixab ` bird  🐦
  Prefixab ` birthday  🎂
  Prefixab ` black_circle  ⚫
  Prefixab ` black_circle_for_record  ⏺
  Prefixab ` black_heart  🖤
  Prefixab ` black_joker  🃏
  Prefixab ` black_large_square  ⬛
  Prefixab ` black_left_pointing_double_triangle_with_vertical_bar  ⏮
  Prefixab ` black_medium_small_square  ◾
  Prefixab ` black_medium_square  ◼
  Prefixab ` black_nib  ✒
  Prefixab ` black_right_pointing_double_triangle_with_vertical_bar  ⏭
  Prefixab ` black_right_pointing_triangle_with_double_vertical_bar  ⏯
  Prefixab ` black_small_square  ▪
  Prefixab ` black_square_button  🔲
  Prefixab ` black_square_for_stop  ⏹
  Prefixab ` blossom  🌼
  Prefixab ` blowfish  🐡
  Prefixab ` blue_book  📘
  Prefixab ` blue_car  🚙
  Prefixab ` blue_heart  💙
  Prefixab ` blush  😊
  Prefixab ` boar  🐗
  Prefixab ` boat  ⛵
  Prefixab ` bomb  💣
  Prefixab ` book  📖
  Prefixab ` bookmark  🔖
  Prefixab ` bookmark_tabs  📑
  Prefixab ` books  📚
  Prefixab ` boom  💥
  Prefixab ` boot  👢
  Prefixab ` bouquet  💐
  Prefixab ` bow  🙇
  Prefixab ` bow_and_arrow  🏹
  Prefixab ` bowl_with_spoon  🥣
  Prefixab ` bowling  🎳
  Prefixab ` boxing_glove  🥊
  Prefixab ` boy  👦
  Prefixab ` brain  🧠
  Prefixab ` bread  🍞
  Prefixab ` breast-feeding  🤱
  Prefixab ` bride_with_veil  👰
  Prefixab ` bridge_at_night  🌉
  Prefixab ` briefcase  💼
  Prefixab ` broccoli  🥦
  Prefixab ` broken_heart  💔
  Prefixab ` bug  🐛
  Prefixab ` building_construction  🏗
  Prefixab ` bulb  💡
  Prefixab ` bullettrain_front  🚅
  Prefixab ` bullettrain_side  🚄
  Prefixab ` burrito  🌯
  Prefixab ` bus  🚌
  Prefixab ` busstop  🚏
  Prefixab ` bust_in_silhouette  👤
  Prefixab ` busts_in_silhouette  👥
  Prefixab ` butterfly  🦋
  Prefixab ` cactus  🌵
  Prefixab ` cake  🍰
  Prefixab ` calendar  📆
  Prefixab ` call_me_hand  🤙
  Prefixab ` calling  📲
  Prefixab ` camel  🐫
  Prefixab ` camera  📷
  Prefixab ` camera_with_flash  📸
  Prefixab ` camping  🏕
  Prefixab ` cancer  ♋
  Prefixab ` candle  🕯
  Prefixab ` candy  🍬
  Prefixab ` canned_food  🥫
  Prefixab ` canoe  🛶
  Prefixab ` capital_abcd  🔠
  Prefixab ` capricorn  ♑
  Prefixab ` car  🚗
  Prefixab ` card_file_box  🗃
  Prefixab ` card_index  📇
  Prefixab ` card_index_dividers  🗂
  Prefixab ` carousel_horse  🎠
  Prefixab ` carrot  🥕
  Prefixab ` cat  🐱
  Prefixab ` cat2  🐈
  Prefixab ` cd  💿
  Prefixab ` chains  ⛓
  Prefixab ` champagne  🍾
  Prefixab ` chart  💹
  Prefixab ` chart_with_downwards_trend  📉
  Prefixab ` chart_with_upwards_trend  📈
  Prefixab ` checkered_flag  🏁
  Prefixab ` cheese_wedge  🧀
  Prefixab ` cherries  🍒
  Prefixab ` cherry_blossom  🌸
  Prefixab ` chestnut  🌰
  Prefixab ` chicken  🐔
  Prefixab ` child  🧒
  Prefixab ` children_crossing  🚸
  Prefixab ` chipmunk  🐿
  Prefixab ` chocolate_bar  🍫
  Prefixab ` chopsticks  🥢
  Prefixab ` christmas_tree  🎄
  Prefixab ` church  ⛪
  Prefixab ` cinema  🎦
  Prefixab ` circus_tent  🎪
  Prefixab ` city_sunrise  🌇
  Prefixab ` city_sunset  🌆
  Prefixab ` cityscape  🏙
  Prefixab ` cl  🆑
  Prefixab ` clap  👏
  Prefixab ` clapper  🎬
  Prefixab ` classical_building  🏛
  Prefixab ` clinking_glasses  🥂
  Prefixab ` clipboard  📋
  Prefixab ` clock1  🕐
  Prefixab ` clock10  🕙
  Prefixab ` clock1030  🕥
  Prefixab ` clock11  🕚
  Prefixab ` clock1130  🕦
  Prefixab ` clock12  🕛
  Prefixab ` clock1230  🕧
  Prefixab ` clock130  🕜
  Prefixab ` clock2  🕑
  Prefixab ` clock230  🕝
  Prefixab ` clock3  🕒
  Prefixab ` clock330  🕞
  Prefixab ` clock4  🕓
  Prefixab ` clock430  🕟
  Prefixab ` clock5  🕔
  Prefixab ` clock530  🕠
  Prefixab ` clock6  🕕
  Prefixab ` clock630  🕡
  Prefixab ` clock7  🕖
  Prefixab ` clock730  🕢
  Prefixab ` clock8  🕗
  Prefixab ` clock830  🕣
  Prefixab ` clock9  🕘
  Prefixab ` clock930  🕤
  Prefixab ` closed_book  📕
  Prefixab ` closed_lock_with_key  🔐
  Prefixab ` closed_umbrella  🌂
  Prefixab ` cloud  ☁
  Prefixab ` clown_face  🤡
  Prefixab ` clubs  ♣
  Prefixab ` coat  🧥
  Prefixab ` cocktail  🍸
  Prefixab ` coconut  🥥
  Prefixab ` coffee  ☕
  Prefixab ` coffin  ⚰
  Prefixab ` cold_sweat  😰
  Prefixab ` collision  💥
  Prefixab ` comet  ☄
  Prefixab ` compression  🗜
  Prefixab ` computer  💻
  Prefixab ` confetti_ball  🎊
  Prefixab ` confounded  😖
  Prefixab ` confused  😕
  Prefixab ` congratulations  ㊗
  Prefixab ` construction  🚧
  Prefixab ` construction_worker  👷
  Prefixab ` control_knobs  🎛
  Prefixab ` convenience_store  🏪
  Prefixab ` cookie  🍪
  Prefixab ` cool  🆒
  Prefixab ` cop  👮
  Prefixab ` copyright  ©
  Prefixab ` corn  🌽
  Prefixab ` couch_and_lamp  🛋
  Prefixab ` couple  👫
  Prefixab ` couple_with_heart  💑
  Prefixab ` couplekiss  💏
  Prefixab ` cow  🐮
  Prefixab ` cow2  🐄
  Prefixab ` crab  🦀
  Prefixab ` credit_card  💳
  Prefixab ` crescent_moon  🌙
  Prefixab ` cricket  🦗
  Prefixab ` cricket_bat_and_ball  🏏
  Prefixab ` crocodile  🐊
  Prefixab ` croissant  🥐
  Prefixab ` crossed_flags  🎌
  Prefixab ` crossed_swords  ⚔
  Prefixab ` crown  👑
  Prefixab ` cry  😢
  Prefixab ` crying_cat_face  😿
  Prefixab ` crystal_ball  🔮
  Prefixab ` cucumber  🥒
  Prefixab ` cup_with_straw  🥤
  Prefixab ` cupid  💘
  Prefixab ` curling_stone  🥌
  Prefixab ` curly_loop  ➰
  Prefixab ` currency_exchange  💱
  Prefixab ` curry  🍛
  Prefixab ` custard  🍮
  Prefixab ` customs  🛃
  Prefixab ` cut_of_meat  🥩
  Prefixab ` cyclone  🌀
  Prefixab ` dagger_knife  🗡
  Prefixab ` dancer  💃
  Prefixab ` dancers  👯
  Prefixab ` dango  🍡
  Prefixab ` dark_sunglasses  🕶
  Prefixab ` dart  🎯
  Prefixab ` dash  💨
  Prefixab ` date  📅
  Prefixab ` deciduous_tree  🌳
  Prefixab ` deer  🦌
  Prefixab ` department_store  🏬
  Prefixab ` derelict_house_building  🏚
  Prefixab ` desert  🏜
  Prefixab ` desert_island  🏝
  Prefixab ` desktop_computer  🖥
  Prefixab ` diamond_shape_with_a_dot_inside  💠
  Prefixab ` diamonds  ♦
  Prefixab ` disappointed  😞
  Prefixab ` disappointed_relieved  😥
  Prefixab ` dizzy  💫
  Prefixab ` dizzy_face  😵
  Prefixab ` do_not_litter  🚯
  Prefixab ` dog  🐶
  Prefixab ` dog2  🐕
  Prefixab ` dollar  💵
  Prefixab ` dolls  🎎
  Prefixab ` dolphin  🐬
  Prefixab ` door  🚪
  Prefixab ` double_vertical_bar  ⏸
  Prefixab ` doughnut  🍩
  Prefixab ` dove_of_peace  🕊
  Prefixab ` dragon  🐉
  Prefixab ` dragon_face  🐲
  Prefixab ` dress  👗
  Prefixab ` dromedary_camel  🐪
  Prefixab ` drooling_face  🤤
  Prefixab ` droplet  💧
  Prefixab ` drum_with_drumsticks  🥁
  Prefixab ` duck  🦆
  Prefixab ` dumpling  🥟
  Prefixab ` dvd  📀
  Prefixab ` e-mail  📧
  Prefixab ` eagle  🦅
  Prefixab ` ear  👂
  Prefixab ` ear_of_rice  🌾
  Prefixab ` earth_africa  🌍
  Prefixab ` earth_americas  🌎
  Prefixab ` earth_asia  🌏
  Prefixab ` egg  🍳
  Prefixab ` eggplant  🍆
  Prefixab ` eight_pointed_black_star  ✴
  Prefixab ` eight_spoked_asterisk  ✳
  Prefixab ` eject  ⏏
  Prefixab ` electric_plug  🔌
  Prefixab ` elephant  🐘
  Prefixab ` elf  🧝
  Prefixab ` email  ✉
  Prefixab ` end  🔚
  Prefixab ` envelope  ✉
  Prefixab ` envelope_with_arrow  📩
  Prefixab ` euro  💶
  Prefixab ` european_castle  🏰
  Prefixab ` european_post_office  🏤
  Prefixab ` evergreen_tree  🌲
  Prefixab ` exclamation  ❗
  Prefixab ` expressionless  😑
  Prefixab ` eye  👁
  Prefixab ` eyeglasses  👓
  Prefixab ` eyes  👀
  Prefixab ` face_palm  🤦
  Prefixab ` face_with_cowboy_hat  🤠
  Prefixab ` face_with_finger_covering_closed_lips  🤫
  Prefixab ` face_with_head_bandage  🤕
  Prefixab ` face_with_monocle  🧐
  Prefixab ` face_with_one_eyebrow_raised  🤨
  Prefixab ` face_with_open_mouth_vomiting  🤮
  Prefixab ` face_with_rolling_eyes  🙄
  Prefixab ` face_with_thermometer  🤒
  Prefixab ` facepunch  👊
  Prefixab ` factory  🏭
  Prefixab ` fairy  🧚
  Prefixab ` fallen_leaf  🍂
  Prefixab ` family  👪
  Prefixab ` fast_forward  ⏩
  Prefixab ` fax  📠
  Prefixab ` fearful  😨
  Prefixab ` feet  🐾
  Prefixab ` female_sign  ♀
  Prefixab ` fencer  🤺
  Prefixab ` ferris_wheel  🎡
  Prefixab ` ferry  ⛴
  Prefixab ` field_hockey_stick_and_ball  🏑
  Prefixab ` file_cabinet  🗄
  Prefixab ` file_folder  📁
  Prefixab ` film_frames  🎞
  Prefixab ` film_projector  📽
  Prefixab ` fire  🔥
  Prefixab ` fire_engine  🚒
  Prefixab ` fireworks  🎆
  Prefixab ` first_place_medal  🥇
  Prefixab ` first_quarter_moon  🌓
  Prefixab ` first_quarter_moon_with_face  🌛
  Prefixab ` fish  🐟
  Prefixab ` fish_cake  🍥
  Prefixab ` fishing_pole_and_fish  🎣
  Prefixab ` fist  ✊
  Prefixab ` five  5
  Prefixab ` flags  🎏
  Prefixab ` flashlight  🔦
  Prefixab ` fleur_de_lis  ⚜
  Prefixab ` flipper  🐬
  Prefixab ` floppy_disk  💾
  Prefixab ` flower_playing_cards  🎴
  Prefixab ` flushed  😳
  Prefixab ` flying_saucer  🛸
  Prefixab ` fog  🌫
  Prefixab ` foggy  🌁
  Prefixab ` football  🏈
  Prefixab ` footprints  👣
  Prefixab ` fork_and_knife  🍴
  Prefixab ` fortune_cookie  🥠
  Prefixab ` fountain  ⛲
  Prefixab ` four  4
  Prefixab ` four_leaf_clover  🍀
  Prefixab ` fox_face  🦊
  Prefixab ` frame_with_picture  🖼
  Prefixab ` free  🆓
  Prefixab ` fried_egg  🍳
  Prefixab ` fried_shrimp  🍤
  Prefixab ` fries  🍟
  Prefixab ` frog  🐸
  Prefixab ` frowning  😦
  Prefixab ` fuelpump  ⛽
  Prefixab ` full_moon  🌕
  Prefixab ` full_moon_with_face  🌝
  Prefixab ` funeral_urn  ⚱
  Prefixab ` game_die  🎲
  Prefixab ` gear  ⚙
  Prefixab ` gem  💎
  Prefixab ` gemini  ♊
  Prefixab ` genie  🧞
  Prefixab ` ghost  👻
  Prefixab ` gift  🎁
  Prefixab ` gift_heart  💝
  Prefixab ` giraffe_face  🦒
  Prefixab ` girl  👧
  Prefixab ` glass_of_milk  🥛
  Prefixab ` globe_with_meridians  🌐
  Prefixab ` gloves  🧤
  Prefixab ` goal_net  🥅
  Prefixab ` goat  🐐
  Prefixab ` golf  ⛳
  Prefixab ` golfer  🏌
  Prefixab ` gorilla  🦍
  Prefixab ` grapes  🍇
  Prefixab ` green_apple  🍏
  Prefixab ` green_book  📗
  Prefixab ` green_heart  💚
  Prefixab ` green_salad  🥗
  Prefixab ` grey_exclamation  ❕
  Prefixab ` grey_question  ❔
  Prefixab ` grimacing  😬
  Prefixab ` grin  😁
  Prefixab ` grinning  😀
  Prefixab ` grinning_face_with_one_large_and_one_small_eye  🤪
  Prefixab ` grinning_face_with_star_eyes  🤩
  Prefixab ` guardsman  💂
  Prefixab ` guitar  🎸
  Prefixab ` gun  🔫
  Prefixab ` haircut  💇
  Prefixab ` hamburger  🍔
  Prefixab ` hammer  🔨
  Prefixab ` hammer_and_pick  ⚒
  Prefixab ` hammer_and_wrench  🛠
  Prefixab ` hamster  🐹
  Prefixab ` hand  ✋
  Prefixab ` hand_with_index_and_middle_fingers_crossed  🤞
  Prefixab ` handbag  👜
  Prefixab ` handball  🤾
  Prefixab ` handshake  🤝
  Prefixab ` hankey  💩
  Prefixab ` hash  #
  Prefixab ` hatched_chick  🐥
  Prefixab ` hatching_chick  🐣
  Prefixab ` headphones  🎧
  Prefixab ` hear_no_evil  🙉
  Prefixab ` heart  ❤
  Prefixab ` heart_decoration  💟
  Prefixab ` heart_eyes  😍
  Prefixab ` heart_eyes_cat  😻
  Prefixab ` heartbeat  💓
  Prefixab ` heartpulse  💗
  Prefixab ` hearts  ♥
  Prefixab ` heavy_check_mark  ✔
  Prefixab ` heavy_division_sign  ➗
  Prefixab ` heavy_dollar_sign  💲
  Prefixab ` heavy_exclamation_mark  ❗
  Prefixab ` heavy_heart_exclamation_mark_ornament  ❣
  Prefixab ` heavy_minus_sign  ➖
  Prefixab ` heavy_multiplication_x  ✖
  Prefixab ` heavy_plus_sign  ➕
  Prefixab ` hedgehog  🦔
  Prefixab ` helicopter  🚁
  Prefixab ` helmet_with_white_cross  ⛑
  Prefixab ` herb  🌿
  Prefixab ` hibiscus  🌺
  Prefixab ` high_brightness  🔆
  Prefixab ` high_heel  👠
  Prefixab ` hocho  🔪
  Prefixab ` hole  🕳
  Prefixab ` honey_pot  🍯
  Prefixab ` honeybee  🐝
  Prefixab ` horse  🐴
  Prefixab ` horse_racing  🏇
  Prefixab ` hospital  🏥
  Prefixab ` hot_pepper  🌶
  Prefixab ` hotdog  🌭
  Prefixab ` hotel  🏨
  Prefixab ` hotsprings  ♨
  Prefixab ` hourglass  ⌛
  Prefixab ` hourglass_flowing_sand  ⏳
  Prefixab ` house  🏠
  Prefixab ` house_buildings  🏘
  Prefixab ` house_with_garden  🏡
  Prefixab ` hugging_face  🤗
  Prefixab ` hushed  😯
  Prefixab ` i_love_you_hand_sign  🤟
  Prefixab ` ice_cream  🍨
  Prefixab ` ice_hockey_stick_and_puck  🏒
  Prefixab ` ice_skate  ⛸
  Prefixab ` icecream  🍦
  Prefixab ` id  🆔
  Prefixab ` ideograph_advantage  🉐
  Prefixab ` imp  👿
  Prefixab ` inbox_tray  📥
  Prefixab ` incoming_envelope  📨
  Prefixab ` information_desk_person  💁
  Prefixab ` information_source  ℹ
  Prefixab ` innocent  😇
  Prefixab ` interrobang  ⁉
  Prefixab ` iphone  📱
  Prefixab ` izakaya_lantern  🏮
  Prefixab ` jack_o_lantern  🎃
  Prefixab ` japan  🗾
  Prefixab ` japanese_castle  🏯
  Prefixab ` japanese_goblin  👺
  Prefixab ` japanese_ogre  👹
  Prefixab ` jeans  👖
  Prefixab ` joy  😂
  Prefixab ` joy_cat  😹
  Prefixab ` joystick  🕹
  Prefixab ` juggling  🤹
  Prefixab ` kaaba  🕋
  Prefixab ` key  🔑
  Prefixab ` keyboard  ⌨
  Prefixab ` keycap_ten  🔟
  Prefixab ` kimono  👘
  Prefixab ` kiss  💋
  Prefixab ` kissing  😗
  Prefixab ` kissing_cat  😽
  Prefixab ` kissing_closed_eyes  😚
  Prefixab ` kissing_heart  😘
  Prefixab ` kissing_smiling_eyes  😙
  Prefixab ` kiwifruit  🥝
  Prefixab ` knife_fork_plate  🍽
  Prefixab ` koala  🐨
  Prefixab ` koko  🈁
  Prefixab ` label  🏷
  Prefixab ` lantern  🏮
  Prefixab ` large_blue_circle  🔵
  Prefixab ` large_blue_diamond  🔷
  Prefixab ` large_orange_diamond  🔶
  Prefixab ` last_quarter_moon  🌗
  Prefixab ` last_quarter_moon_with_face  🌜
  Prefixab ` latin_cross  ✝
  Prefixab ` laughing  😆
  Prefixab ` leaves  🍃
  Prefixab ` ledger  📒
  Prefixab ` left-facing_fist  🤛
  Prefixab ` left_luggage  🛅
  Prefixab ` left_right_arrow  ↔
  Prefixab ` left_speech_bubble  🗨
  Prefixab ` leftwards_arrow_with_hook  ↩
  Prefixab ` lemon  🍋
  Prefixab ` leo  ♌
  Prefixab ` leopard  🐆
  Prefixab ` level_slider  🎚
  Prefixab ` libra  ♎
  Prefixab ` light_rail  🚈
  Prefixab ` lightning  🌩
  Prefixab ` link  🔗
  Prefixab ` linked_paperclips  🖇
  Prefixab ` lion_face  🦁
  Prefixab ` lips  👄
  Prefixab ` lipstick  💄
  Prefixab ` lizard  🦎
  Prefixab ` lock  🔒
  Prefixab ` lock_with_ink_pen  🔏
  Prefixab ` lollipop  🍭
  Prefixab ` loop  ➿
  Prefixab ` loud_sound  🔊
  Prefixab ` loudspeaker  📢
  Prefixab ` love_hotel  🏩
  Prefixab ` love_letter  💌
  Prefixab ` low_brightness  🔅
  Prefixab ` lower_left_ballpoint_pen  🖊
  Prefixab ` lower_left_crayon  🖍
  Prefixab ` lower_left_fountain_pen  🖋
  Prefixab ` lower_left_paintbrush  🖌
  Prefixab ` lying_face  🤥
  Prefixab ` m  Ⓜ
  Prefixab ` mag  🔍
  Prefixab ` mag_right  🔎
  Prefixab ` mage  🧙
  Prefixab ` mahjong  🀄
  Prefixab ` mailbox  📫
  Prefixab ` mailbox_closed  📪
  Prefixab ` mailbox_with_mail  📬
  Prefixab ` mailbox_with_no_mail  📭
  Prefixab ` male_sign  ♂
  Prefixab ` man  👨
  Prefixab ` man_dancing  🕺
  Prefixab ` man_in_business_suit_levitating  🕴
  Prefixab ` man_in_tuxedo  🤵
  Prefixab ` man_with_gua_pi_mao  👲
  Prefixab ` man_with_turban  👳
  Prefixab ` mans_shoe  👞
  Prefixab ` mantelpiece_clock  🕰
  Prefixab ` maple_leaf  🍁
  Prefixab ` martial_arts_uniform  🥋
  Prefixab ` mask  😷
  Prefixab ` massage  💆
  Prefixab ` meat_on_bone  🍖
  Prefixab ` medal  🎖
  Prefixab ` mega  📣
  Prefixab ` melon  🍈
  Prefixab ` memo  📝
  Prefixab ` menorah_with_nine_branches  🕎
  Prefixab ` mens  🚹
  Prefixab ` merperson  🧜
  Prefixab ` metro  🚇
  Prefixab ` microphone  🎤
  Prefixab ` microscope  🔬
  Prefixab ` middle_finger  🖕
  Prefixab ` milky_way  🌌
  Prefixab ` minibus  🚐
  Prefixab ` minidisc  💽
  Prefixab ` mobile_phone_off  📴
  Prefixab ` money_mouth_face  🤑
  Prefixab ` money_with_wings  💸
  Prefixab ` moneybag  💰
  Prefixab ` monkey  🐒
  Prefixab ` monkey_face  🐵
  Prefixab ` monorail  🚝
  Prefixab ` moon  🌔
  Prefixab ` mortar_board  🎓
  Prefixab ` mosque  🕌
  Prefixab ` mostly_sunny  🌤
  Prefixab ` mother_christmas  🤶
  Prefixab ` motor_boat  🛥
  Prefixab ` motor_scooter  🛵
  Prefixab ` motorway  🛣
  Prefixab ` mount_fuji  🗻
  Prefixab ` mountain  ⛰
  Prefixab ` mountain_bicyclist  🚵
  Prefixab ` mountain_cableway  🚠
  Prefixab ` mountain_railway  🚞
  Prefixab ` mouse  🐭
  Prefixab ` mouse2  🐁
  Prefixab ` movie_camera  🎥
  Prefixab ` moyai  🗿
  Prefixab ` muscle  💪
  Prefixab ` mushroom  🍄
  Prefixab ` musical_keyboard  🎹
  Prefixab ` musical_note  🎵
  Prefixab ` musical_score  🎼
  Prefixab ` mute  🔇
  Prefixab ` nail_care  💅
  Prefixab ` name_badge  📛
  Prefixab ` national_park  🏞
  Prefixab ` nauseated_face  🤢
  Prefixab ` necktie  👔
  Prefixab ` negative_squared_cross_mark  ❎
  Prefixab ` nerd_face  🤓
  Prefixab ` neutral_face  😐
  Prefixab ` new  🆕
  Prefixab ` new_moon  🌑
  Prefixab ` new_moon_with_face  🌚
  Prefixab ` newspaper  📰
  Prefixab ` ng  🆖
  Prefixab ` night_with_stars  🌃
  Prefixab ` nine  9
  Prefixab ` no_bell  🔕
  Prefixab ` no_bicycles  🚳
  Prefixab ` no_entry  ⛔
  Prefixab ` no_entry_sign  🚫
  Prefixab ` no_good  🙅
  Prefixab ` no_mobile_phones  📵
  Prefixab ` no_mouth  😶
  Prefixab ` no_pedestrians  🚷
  Prefixab ` no_smoking  🚭
  Prefixab ` non-potable_water  🚱
  Prefixab ` nose  👃
  Prefixab ` notebook  📓
  Prefixab ` notebook_with_decorative_cover  📔
  Prefixab ` notes  🎶
  Prefixab ` nut_and_bolt  🔩
  Prefixab ` o  ⭕
  Prefixab ` o2  🅾
  Prefixab ` ocean  🌊
  Prefixab ` octagonal_sign  🛑
  Prefixab ` octopus  🐙
  Prefixab ` oden  🍢
  Prefixab ` office  🏢
  Prefixab ` oil_drum  🛢
  Prefixab ` ok  🆗
  Prefixab ` ok_hand  👌
  Prefixab ` ok_woman  🙆
  Prefixab ` old_key  🗝
  Prefixab ` older_adult  🧓
  Prefixab ` older_man  👴
  Prefixab ` older_woman  👵
  Prefixab ` om_symbol  🕉
  Prefixab ` on  🔛
  Prefixab ` oncoming_automobile  🚘
  Prefixab ` oncoming_bus  🚍
  Prefixab ` oncoming_police_car  🚔
  Prefixab ` oncoming_taxi  🚖
  Prefixab ` open_book  📖
  Prefixab ` open_file_folder  📂
  Prefixab ` open_hands  👐
  Prefixab ` open_mouth  😮
  Prefixab ` ophiuchus  ⛎
  Prefixab ` orange_book  📙
  Prefixab ` orange_heart  🧡
  Prefixab ` orthodox_cross  ☦
  Prefixab ` outbox_tray  📤
  Prefixab ` owl  🦉
  Prefixab ` ox  🐂
  Prefixab ` package  📦
  Prefixab ` page_facing_up  📄
  Prefixab ` page_with_curl  📃
  Prefixab ` pager  📟
  Prefixab ` palm_tree  🌴
  Prefixab ` palms_up_together  🤲
  Prefixab ` pancakes  🥞
  Prefixab ` panda_face  🐼
  Prefixab ` paperclip  📎
  Prefixab ` parking  🅿
  Prefixab ` part_alternation_mark  〽
  Prefixab ` partly_sunny  ⛅
  Prefixab ` partly_sunny_rain  🌦
  Prefixab ` passenger_ship  🛳
  Prefixab ` passport_control  🛂
  Prefixab ` paw_prints  🐾
  Prefixab ` peace_symbol  ☮
  Prefixab ` peach  🍑
  Prefixab ` peanuts  🥜
  Prefixab ` pear  🍐
  Prefixab ` pencil  📝
  Prefixab ` pencil2  ✏
  Prefixab ` penguin  🐧
  Prefixab ` pensive  😔
  Prefixab ` performing_arts  🎭
  Prefixab ` persevere  😣
  Prefixab ` person_climbing  🧗
  Prefixab ` person_doing_cartwheel  🤸
  Prefixab ` person_frowning  🙍
  Prefixab ` person_in_lotus_position  🧘
  Prefixab ` person_in_steamy_room  🧖
  Prefixab ` person_with_ball  ⛹
  Prefixab ` person_with_blond_hair  👱
  Prefixab ` person_with_headscarf  🧕
  Prefixab ` person_with_pouting_face  🙎
  Prefixab ` phone  ☎
  Prefixab ` pick  ⛏
  Prefixab ` pie  🥧
  Prefixab ` pig  🐷
  Prefixab ` pig2  🐖
  Prefixab ` pig_nose  🐽
  Prefixab ` pill  💊
  Prefixab ` pineapple  🍍
  Prefixab ` pisces  ♓
  Prefixab ` pizza  🍕
  Prefixab ` place_of_worship  🛐
  Prefixab ` point_down  👇
  Prefixab ` point_left  👈
  Prefixab ` point_right  👉
  Prefixab ` point_up  ☝
  Prefixab ` point_up_2  👆
  Prefixab ` police_car  🚓
  Prefixab ` poodle  🐩
  Prefixab ` poop  💩
  Prefixab ` popcorn  🍿
  Prefixab ` post_office  🏣
  Prefixab ` postal_horn  📯
  Prefixab ` postbox  📮
  Prefixab ` potable_water  🚰
  Prefixab ` potato  🥔
  Prefixab ` pouch  👝
  Prefixab ` poultry_leg  🍗
  Prefixab ` pound  💷
  Prefixab ` pouting_cat  😾
  Prefixab ` pray  🙏
  Prefixab ` prayer_beads  📿
  Prefixab ` pregnant_woman  🤰
  Prefixab ` pretzel  🥨
  Prefixab ` prince  🤴
  Prefixab ` princess  👸
  Prefixab ` printer  🖨
  Prefixab ` punch  👊
  Prefixab ` purple_heart  💜
  Prefixab ` purse  👛
  Prefixab ` pushpin  📌
  Prefixab ` put_litter_in_its_place  🚮
  Prefixab ` question  ❓
  Prefixab ` rabbit  🐰
  Prefixab ` rabbit2  🐇
  Prefixab ` racehorse  🐎
  Prefixab ` racing_car  🏎
  Prefixab ` racing_motorcycle  🏍
  Prefixab ` radio  📻
  Prefixab ` radio_button  🔘
  Prefixab ` radioactive_sign  ☢
  Prefixab ` rage  😡
  Prefixab ` railway_car  🚃
  Prefixab ` railway_track  🛤
  Prefixab ` rain_cloud  🌧
  Prefixab ` rainbow  🌈
  Prefixab ` raised_back_of_hand  🤚
  Prefixab ` raised_hand  ✋
  Prefixab ` raised_hand_with_fingers_splayed  🖐
  Prefixab ` raised_hands  🙌
  Prefixab ` raising_hand  🙋
  Prefixab ` ram  🐏
  Prefixab ` ramen  🍜
  Prefixab ` rat  🐀
  Prefixab ` recycle  ♻
  Prefixab ` red_car  🚗
  Prefixab ` red_circle  🔴
  Prefixab ` registered  ®
  Prefixab ` relaxed  ☺
  Prefixab ` relieved  😌
  Prefixab ` reminder_ribbon  🎗
  Prefixab ` repeat  🔁
  Prefixab ` repeat_one  🔂
  Prefixab ` restroom  🚻
  Prefixab ` revolving_hearts  💞
  Prefixab ` rewind  ⏪
  Prefixab ` rhinoceros  🦏
  Prefixab ` ribbon  🎀
  Prefixab ` rice  🍚
  Prefixab ` rice_ball  🍙
  Prefixab ` rice_cracker  🍘
  Prefixab ` rice_scene  🎑
  Prefixab ` right-facing_fist  🤜
  Prefixab ` right_anger_bubble  🗯
  Prefixab ` ring  💍
  Prefixab ` robot_face  🤖
  Prefixab ` rocket  🚀
  Prefixab ` rolled_up_newspaper  🗞
  Prefixab ` roller_coaster  🎢
  Prefixab ` rolling_on_the_floor_laughing  🤣
  Prefixab ` rooster  🐓
  Prefixab ` rose  🌹
  Prefixab ` rosette  🏵
  Prefixab ` rotating_light  🚨
  Prefixab ` round_pushpin  📍
  Prefixab ` rowboat  🚣
  Prefixab ` rugby_football  🏉
  Prefixab ` runner  🏃
  Prefixab ` running  🏃
  Prefixab ` running_shirt_with_sash  🎽
  Prefixab ` sa  🈂
  Prefixab ` sagittarius  ♐
  Prefixab ` sailboat  ⛵
  Prefixab ` sake  🍶
  Prefixab ` sandal  👡
  Prefixab ` sandwich  🥪
  Prefixab ` santa  🎅
  Prefixab ` satellite  📡
  Prefixab ` satellite_antenna  📡
  Prefixab ` satisfied  😆
  Prefixab ` sauropod  🦕
  Prefixab ` saxophone  🎷
  Prefixab ` scales  ⚖
  Prefixab ` scarf  🧣
  Prefixab ` school  🏫
  Prefixab ` school_satchel  🎒
  Prefixab ` scissors  ✂
  Prefixab ` scooter  🛴
  Prefixab ` scorpion  🦂
  Prefixab ` scorpius  ♏
  Prefixab ` scream  😱
  Prefixab ` scream_cat  🙀
  Prefixab ` scroll  📜
  Prefixab ` seat  💺
  Prefixab ` second_place_medal  🥈
  Prefixab ` secret  ㊙
  Prefixab ` see_no_evil  🙈
  Prefixab ` seedling  🌱
  Prefixab ` selfie  🤳
  Prefixab ` serious_face_with_symbols_covering_mouth  🤬
  Prefixab ` shallow_pan_of_food  🥘
  Prefixab ` shamrock  ☘
  Prefixab ` shark  🦈
  Prefixab ` shaved_ice  🍧
  Prefixab ` sheep  🐑
  Prefixab ` shell  🐚
  Prefixab ` shield  🛡
  Prefixab ` shinto_shrine  ⛩
  Prefixab ` ship  🚢
  Prefixab ` shirt  👕
  Prefixab ` shit  💩
  Prefixab ` shocked_face_with_exploding_head  🤯
  Prefixab ` shoe  👞
  Prefixab ` shopping_bags  🛍
  Prefixab ` shopping_trolley  🛒
  Prefixab ` shower  🚿
  Prefixab ` shrimp  🦐
  Prefixab ` shrug  🤷
  Prefixab ` signal_strength  📶
  Prefixab ` six  6
  Prefixab ` six_pointed_star  🔯
  Prefixab ` ski  🎿
  Prefixab ` skier  ⛷
  Prefixab ` skull  💀
  Prefixab ` skull_and_crossbones  ☠
  Prefixab ` sled  🛷
  Prefixab ` sleeping  😴
  Prefixab ` sleeping_accommodation  🛌
  Prefixab ` sleepy  😪
  Prefixab ` sleuth_or_spy  🕵
  Prefixab ` slightly_frowning_face  🙁
  Prefixab ` slightly_smiling_face  🙂
  Prefixab ` slot_machine  🎰
  Prefixab ` small_airplane  🛩
  Prefixab ` small_blue_diamond  🔹
  Prefixab ` small_orange_diamond  🔸
  Prefixab ` small_red_triangle  🔺
  Prefixab ` small_red_triangle_down  🔻
  Prefixab ` smile  😄
  Prefixab ` smile_cat  😸
  Prefixab ` smiley  😃
  Prefixab ` smiley_cat  😺
  Prefixab ` smiling_face_with_smiling_eyes_and_hand_covering_mouth  🤭
  Prefixab ` smiling_imp  😈
  Prefixab ` smirk  😏
  Prefixab ` smirk_cat  😼
  Prefixab ` smoking  🚬
  Prefixab ` snail  🐌
  Prefixab ` snake  🐍
  Prefixab ` sneezing_face  🤧
  Prefixab ` snow_capped_mountain  🏔
  Prefixab ` snow_cloud  🌨
  Prefixab ` snowboarder  🏂
  Prefixab ` snowflake  ❄
  Prefixab ` snowman  ⛄
  Prefixab ` snowman_without_snow  ⛄
  Prefixab ` sob  😭
  Prefixab ` soccer  ⚽
  Prefixab ` socks  🧦
  Prefixab ` soon  🔜
  Prefixab ` sos  🆘
  Prefixab ` sound  🔉
  Prefixab ` space_invader  👾
  Prefixab ` spades  ♠
  Prefixab ` spaghetti  🍝
  Prefixab ` sparkle  ❇
  Prefixab ` sparkler  🎇
  Prefixab ` sparkles  ✨
  Prefixab ` sparkling_heart  💖
  Prefixab ` speak_no_evil  🙊
  Prefixab ` speaker  🔊
  Prefixab ` speaking_head_in_silhouette  🗣
  Prefixab ` speech_balloon  💬
  Prefixab ` speedboat  🚤
  Prefixab ` spider  🕷
  Prefixab ` spider_web  🕸
  Prefixab ` spiral_calendar_pad  🗓
  Prefixab ` spiral_note_pad  🗒
  Prefixab ` spock-hand  🖖
  Prefixab ` spoon  🥄
  Prefixab ` sports_medal  🏅
  Prefixab ` squid  🦑
  Prefixab ` stadium  🏟
  Prefixab ` staff_of_aesculapius  ⚕
  Prefixab ` star  ⭐
  Prefixab ` star2  🌟
  Prefixab ` star_and_crescent  ☪
  Prefixab ` star_of_david  ✡
  Prefixab ` stars  🌃
  Prefixab ` station  🚉
  Prefixab ` statue_of_liberty  🗽
  Prefixab ` steam_locomotive  🚂
  Prefixab ` stew  🍲
  Prefixab ` stopwatch  ⏱
  Prefixab ` straight_ruler  📏
  Prefixab ` strawberry  🍓
  Prefixab ` stuck_out_tongue  😛
  Prefixab ` stuck_out_tongue_closed_eyes  😝
  Prefixab ` stuck_out_tongue_winking_eye  😜
  Prefixab ` studio_microphone  🎙
  Prefixab ` stuffed_flatbread  🥙
  Prefixab ` sun_with_face  🌞
  Prefixab ` sunflower  🌻
  Prefixab ` sunglasses  😎
  Prefixab ` sunny  ☀
  Prefixab ` sunrise  🌅
  Prefixab ` sunrise_over_mountains  🌄
  Prefixab ` surfer  🏄
  Prefixab ` sushi  🍣
  Prefixab ` suspension_railway  🚟
  Prefixab ` sweat  😓
  Prefixab ` sweat_drops  💦
  Prefixab ` sweat_smile  😅
  Prefixab ` sweet_potato  🍠
  Prefixab ` swimmer  🏊
  Prefixab ` symbols  🔣
  Prefixab ` synagogue  🕍
  Prefixab ` syringe  💉
  Prefixab ` t-rex  🦖
  Prefixab ` table_tennis_paddle_and_ball  🏓
  Prefixab ` taco  🌮
  Prefixab ` tada  🎉
  Prefixab ` takeout_box  🥡
  Prefixab ` tanabata_tree  🎋
  Prefixab ` tangerine  🍊
  Prefixab ` taurus  ♉
  Prefixab ` taxi  🚕
  Prefixab ` tea  🍵
  Prefixab ` telephone  ☎
  Prefixab ` telephone_receiver  📞
  Prefixab ` telescope  🔭
  Prefixab ` tennis  🎾
  Prefixab ` tent  ⛺
  Prefixab ` the_horns  🤘
  Prefixab ` thermometer  🌡
  Prefixab ` thinking_face  🤔
  Prefixab ` third_place_medal  🥉
  Prefixab ` thought_balloon  💭
  Prefixab ` three  3
  Prefixab ` three_button_mouse  🖱
  Prefixab ` thumbsdown  👎
  Prefixab ` thumbsup  👍
  Prefixab ` thunder_cloud_and_rain  ⛈
  Prefixab ` ticket  🎫
  Prefixab ` tiger  🐯
  Prefixab ` tiger2  🐅
  Prefixab ` timer_clock  ⏲
  Prefixab ` tired_face  😫
  Prefixab ` tm  ™
  Prefixab ` toilet  🚽
  Prefixab ` tokyo_tower  🗼
  Prefixab ` tomato  🍅
  Prefixab ` tongue  👅
  Prefixab ` top  🔝
  Prefixab ` tophat  🎩
  Prefixab ` tornado  🌪
  Prefixab ` trackball  🖲
  Prefixab ` tractor  🚜
  Prefixab ` traffic_light  🚥
  Prefixab ` train  🚃
  Prefixab ` train2  🚆
  Prefixab ` tram  🚊
  Prefixab ` triangular_flag_on_post  🚩
  Prefixab ` triangular_ruler  📐
  Prefixab ` trident  🔱
  Prefixab ` triumph  😤
  Prefixab ` trolleybus  🚎
  Prefixab ` trophy  🏆
  Prefixab ` tropical_drink  🍹
  Prefixab ` tropical_fish  🐠
  Prefixab ` truck  🚚
  Prefixab ` trumpet  🎺
  Prefixab ` tshirt  👕
  Prefixab ` tulip  🌷
  Prefixab ` tumbler_glass  🥃
  Prefixab ` turkey  🦃
  Prefixab ` turtle  🐢
  Prefixab ` tv  📺
  Prefixab ` twisted_rightwards_arrows  🔀
  Prefixab ` two  2
  Prefixab ` two_hearts  💕
  Prefixab ` two_men_holding_hands  👬
  Prefixab ` two_women_holding_hands  👭
  Prefixab ` u5272  🈹
  Prefixab ` u5408  🈴
  Prefixab ` u55b6  🈺
  Prefixab ` u6307  🈯
  Prefixab ` u6708  🈷
  Prefixab ` u6709  🈶
  Prefixab ` u6e80  🈵
  Prefixab ` u7121  🈚
  Prefixab ` u7533  🈸
  Prefixab ` u7981  🈲
  Prefixab ` u7a7a  🈳
  Prefixab ` umbrella  ☔
  Prefixab ` umbrella_on_ground  ⛱
  Prefixab ` umbrella_with_rain_drops  ☔
  Prefixab ` unamused  😒
  Prefixab ` underage  🔞
  Prefixab ` unicorn_face  🦄
  Prefixab ` unlock  🔓
  Prefixab ` up  🆙
  Prefixab ` upside_down_face  🙃
  Prefixab ` v  ✌
  Prefixab ` vampire  🧛
  Prefixab ` vertical_traffic_light  🚦
  Prefixab ` vhs  📼
  Prefixab ` vibration_mode  📳
  Prefixab ` video_camera  📹
  Prefixab ` video_game  🎮
  Prefixab ` violin  🎻
  Prefixab ` virgo  ♍
  Prefixab ` volcano  🌋
  Prefixab ` volleyball  🏐
  Prefixab ` vs  🆚
  Prefixab ` walking  🚶
  Prefixab ` waning_crescent_moon  🌘
  Prefixab ` waning_gibbous_moon  🌖
  Prefixab ` warning  ⚠
  Prefixab ` wastebasket  🗑
  Prefixab ` watch  ⌚
  Prefixab ` water_buffalo  🐃
  Prefixab ` water_polo  🤽
  Prefixab ` watermelon  🍉
  Prefixab ` wave  👋
  Prefixab ` waving_black_flag  🏴
  Prefixab ` waving_white_flag  🏳
  Prefixab ` wavy_dash  〰
  Prefixab ` waxing_crescent_moon  🌒
  Prefixab ` waxing_gibbous_moon  🌔
  Prefixab ` wc  🚾
  Prefixab ` weary  😩
  Prefixab ` wedding  💒
  Prefixab ` weight_lifter  🏋
  Prefixab ` whale  🐳
  Prefixab ` whale2  🐋
  Prefixab ` wheel_of_dharma  ☸
  Prefixab ` wheelchair  ♿
  Prefixab ` white_check_mark  ✅
  Prefixab ` white_circle  ⚪
  Prefixab ` white_flower  💮
  Prefixab ` white_frowning_face  ☹
  Prefixab ` white_large_square  ⬜
  Prefixab ` white_medium_small_square  ◽
  Prefixab ` white_medium_square  ◻
  Prefixab ` white_small_square  ▫
  Prefixab ` white_square_button  🔳
  Prefixab ` wilted_flower  🥀
  Prefixab ` wind_blowing_face  🌬
  Prefixab ` wind_chime  🎐
  Prefixab ` wine_glass  🍷
  Prefixab ` wink  😉
  Prefixab ` wolf  🐺
  Prefixab ` woman  👩
  Prefixab ` womans_clothes  👚
  Prefixab ` womans_hat  👒
  Prefixab ` womens  🚺
  Prefixab ` world_map  🗺
  Prefixab ` worried  😟
  Prefixab ` wrench  🔧
  Prefixab ` wrestlers  🤼
  Prefixab ` writing_hand  ✍
  Prefixab ` x  ❌
  Prefixab ` yellow_heart  💛
  Prefixab ` yen  💴
  Prefixab ` yin_yang  ☯
  Prefixab ` yum  😋
  Prefixab ` zap  ⚡
  Prefixab ` zebra_face  🦓
  Prefixab ` zero  0
  Prefixab ` zipper_mouth_face  🤐
  Prefixab ` zombie  🧟
  Prefixab ` zzz  💤
  " }}}
endfunction
command! Unicoder call s:setup_abbreviations()
