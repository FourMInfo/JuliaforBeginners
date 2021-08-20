# Hebrew char set
map(Char, 1488:1514)
ncodeunits('ש')
isascii('ש')
 codepoint('ש')

 snake2camel_case(s::AbstractString) = join(map(uppercasefirst, split(s, '_')))

 function snake2camel_case()
    s =snake2camel_case(clipboard())
    clipboard(s)
    s
 end

function camel2snake_case(s::AbstractString)
    words = String[]
    i = 1
    for j in findall(isuppercase, s)
        push!(words, lowercase(s[i:j-1]))
        i = j
    end
    push!(words, lowercase(s[i:end]))
    join(words, "_")
 end
