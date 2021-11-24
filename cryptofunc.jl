
# caeser cipher
const n = length('A':'Z')
# function encrypt(ch::Char, shift::Integer)
#     if ch in 'A':'Z'
#         'A' + mod((ch - 'A') + shift, n)
#     elseif ch in 'a':'z'
#         'a' + mod((ch - 'a') + shift, n)
#     else
#         ch
#     end
# end

# function decrypt(ch::Char, shift::Integer)
#     if ch in 'A':'Z'
#         'A' + mod((ch - 'A') - shift, n)
#     elseif ch in 'a':'z'
#         'a' + mod((ch - 'a') - shift, n)
#     else
#         ch
#     end
# end

# more elegant solution based on discussion here:
# https://discourse.julialang.org/t/a-switch-type-function/13491/15
function encryptc(ch::Char, shift::Integer)
    ch in 'A':'Z' ? 'A' + mod((ch - 'A') + shift, n) :
    ch in 'a':'z' ? 'a' + mod((ch - 'a') + shift, n) :
    #= otherwise =# ch
end

function decryptc(ch::Char, shift::Integer)
    ch in 'A':'Z' ? 'A' + mod((ch - 'A') - shift, n) :
    ch in 'a':'z' ? 'a' + mod((ch - 'a') - shift, n) :
    #= otherwise =# ch
end

# Example
# julia> message = "This is the end of the world!"
# "This is the end of the world"
#
# julia> shift = 3
# 3
#
# julia> emessage = map(message) do char
#     encryptc(char, shift)
# end
# "Wklv lv wkh hqg ri wkh zruog!"

# julia> map(emessage) do char
#     decryptc(char, shift)
# end
# "This is the end of the world!"

# substition cipher
using Random
# Engheim's definition is wrong - he uses 'char' for 'ch'
function encrypts(ch::Char, updict::Dict{Char, Char}, lowdict::Dict{Char, Char})
    ch in 'A':'Z' ? get(updict, ch, ch) :
    ch in 'a':'z' ? get(lowdict, ch, ch) :
    #= otherwise =# ch
end

# Also don't think decrypt is confusing as Engheim claims
function decrypts(ch::Char, rupdict::Dict{Char, Char}, rlowdict::Dict{Char, Char})
    ch in 'A':'Z' ? get(rupdict, ch, ch) :
    ch in 'a':'z' ? get(rlowdict, ch, ch) :
    #= otherwise =# ch
end

# example
# julia> updict = Dict(zip('A':'Z', upshuf))
# Dict{Char, Char} with 26 entries:
#   'E' => 'D'
#   'Z' => 'C'
#   'X' => 'G'
#   'B' => 'U'
#   'C' => 'T'
#   'D' => 'Y'
#   'A' => 'S'
#   'R' => 'F'
#   'G' => 'A'
#   'F' => 'P'
#   'N' => 'Q'
#   'M' => 'M'
#   'K' => 'V'
#   ⋮   => ⋮
#
#   julia> lowdict = Dict(zip('a':'z', lowshuf))
#   Dict{Char, Char} with 26 entries:
#     'n' => 'x'
#     'f' => 'b'
#     'w' => 'y'
#     'd' => 'a'
#     'e' => 'f'
#     'o' => 'l'
#     'h' => 'c'
#     'j' => 'm'
#     'i' => 't'
#     'k' => 'z'
#     'r' => 'v'
#     's' => 'q'
#     't' => 'w'
#     ⋮   => ⋮
#
#   julia> encrypts('a', updict, lowdict)
#   'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)
#
#   julia> encrypts('?', updict, lowdict)
#   '?': ASCII/Unicode U+003F (category Po: Punctuation, other)
# 
#   julia> encrypts('Z', updict, lowdict)
#   'C': ASCII/Unicode U+0043 (category Lu: Letter, uppercase)
#
# The idea for how to reverse the dictionary comes from here:
# https://discourse.julialang.org/t/is-something-like-reversed-dict-findall-x-x-house-cc-is-to-slow/16443/2
# julia> rupdict = Dict(values(updict) .=> keys(updict))
# Dict{Char, Char} with 26 entries:
#   'E' => 'P'
#   'Z' => 'O'
#   'X' => 'Q'
#   'C' => 'Z'
#   'B' => 'Y'
#   'D' => 'E'
#   'A' => 'G'
#   'R' => 'T'
#   'G' => 'X'
#   'F' => 'R'
#   'Q' => 'N'
#   'P' => 'F'
#   'M' => 'M'
#   ⋮   => ⋮
#
# julia> rlowdict = Dict(values(lowdict) .=> keys(lowdict))
# Dict{Char, Char} with 26 entries:
#   'n' => 'g'
#   'f' => 'e'
#   'w' => 't'
#   'd' => 'q'
#   'e' => 'v'
#   'o' => 'm'
#   'h' => 'z'
#   'y' => 'w'
#   'i' => 'a'
#   't' => 'i'
#   's' => 'l'
#   'r' => 'u'
#   'j' => 'x'
#   ⋮   => ⋮
# julia> message = "This is the end of the world!"
# "This is the end of the world!"

# julia> emessage = map(message) do char
#            encrypts(char,updict,lowdict)
#         end
# "Rctq tq wcf fxa lb wcf ylvsa!"

# julia> map(emessage) do char
#            decrypts(char,rupdict,rlowdict)
#         end
# "This is the end of the world!"