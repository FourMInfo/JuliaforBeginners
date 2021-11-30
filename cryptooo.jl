# Here Engheim  makes use of multiple dispatch so its not
# exactly idiomatic OOP, where the methods are associated with the struct
# Tou can't do "real" OOP in Julia and that is perfectly alright.
# https://docs.julialang.org/en/v1/manual/types/#Composite-Types-1
# https://discourse.julialang.org/t/is-julias-way-of-oop-superior-to-c-python-why-julia-doesnt-use-class-based-oop/52058
# https://arstechnica.com/science/2020/10/the-unreasonable-effectiveness-of-the-julia-programming-language/

abstract type Cipher end

function encrypt(cipher::Cipher, char::Char)
    error("Implement encrypt(::", typeof(cipher), ", char)")
end

function decrypt(cipher::Cipher, char::Char)
    error("Implement decrypt(::", typeof(cipher), ", char)")
end

# once you define the encrypt/decrypt pair for the cipher
# these functions handle strings for you
function encrypt(cipher::Cipher, message::AbstractString)
#    map(ch -> encrypt(cipher, ch), message)
    map(message) do ch
        encrypt(cipher, ch)
    end
end

function decrypt(cipher::Cipher, ciphertext::AbstractString)
#    map(ch -> decrypt(cipher, ch), ciphertext)
    map(ciphertext) do ch
        decrypt(cipher, ch)
    end
end

# Caeser cipher implementation - same as before, except shift is in strucct

struct CaesarCipher <: Cipher
  shift::Int
end

const n = length('A':'Z')

function encrypt(cipher::CaesarCipher, ch::Char)
    ch in 'A':'Z' ? 'A' + mod((ch - 'A') + cipher.shift, n) :
    ch in 'a':'z' ? 'a' + mod((ch - 'a') + cipher.shift, n) :
    #= otherwise =# ch
end

function decrypt(cipher::CaesarCipher, ch::Char)
    ch in 'A':'Z' ? 'A' + mod((ch - 'A') - cipher.shift, n) :
    ch in 'a':'z' ? 'a' + mod((ch - 'a') - cipher.shift, n) :
    #= otherwise =# ch
end

# Substitution cipher

# Engheim did it this way, but then you have to figure out the substitute yourself
# struct SubstitutionCipher <: Cipher
#   substitute::Dict{Char, Char}
#   alphabet::Dict{Char, Char}

#   function SubstitutionCipher(substitute)
#     sub   = Dict(zip('A':'Z', collect(substitute)))
#     alpha = Dict(zip(collect(substitute), 'A':'Z'))
#     new(sub, alpha)
#   end
#end
# function encrypt(cipher::SubstitutionCipher, ch::Char)
#   get(cipher.substitute, ch, ch)
# end

# function decrypt(cipher::SubstitutionCipher, ch::Char)
#     get(cipher.alphabet, ch, ch)
# end

# this alternate way creates and stores the shuffle for you
using Random
struct SubstitutionCipher <: Cipher
    upshuf::Array{Char}
    lowshuf::Array{Char}
    updict::Dict{Char, Char}
    lowdict::Dict{Char, Char}
    rupdict::Dict{Char, Char}
    rlowdict::Dict{Char, Char}

    function SubstitutionCipher()
        # not sure you have to save ths shuffle since you can get them out of the dict
        # still its convenient
        upshuf = shuffle('A':'Z')
        lowshuf = shuffle('a':'z')
        updict = Dict(zip('A':'Z', upshuf))
        lowdict = Dict(zip('a':'z', lowshuf))
        rupdict = Dict(values(updict) .=> keys(updict))
        rlowdict = Dict(values(lowdict) .=> keys(lowdict))
        new(upshuf, lowshuf, updict, lowdict, rupdict, rlowdict)
    end
end

function encrypt(cipher::SubstitutionCipher, ch::Char)
    ch in 'A':'Z' ? get(cipher.updict, ch, ch) :
    ch in 'a':'z' ? get(cipher.lowdict, ch, ch) :
    #= otherwise =# ch
end

function decrypt(cipher::SubstitutionCipher, ch::Char)
    ch in 'A':'Z' ? get(cipher.rupdict, ch, ch) :
    ch in 'a':'z' ? get(cipher.rlowdict, ch, ch) :
    #= otherwise =# ch
end

# example
# julia> cipher = SubstitutionCipher()
# SubstitutionCipher(['U', 'V', 'J', 'L', 'C', 'F', 'D', 'P', 'N', 'X'  …  'Z', 'O', 'M', 'B', 'A', 'I', 'Q', 'Y', 'W', 'T'], ['s', 'm', 'q', 'b', 'u', 'o', 'y', 'g', 'x', 'e'  …  'h', 'j', 'c', 'a', 'w', 'd', 't', 'f', 'k', 'n'], Dict('E' => 'C', 'Z' => 'T', 'X' => 'Y', 'B' => 'V', 'C' => 'J', 'D' => 'L', 'A' => 'U', 'R' => 'O', 'G' => 'D', 'F' => 'F'…), Dict('n' => 'r', 'f' => 'o', 'w' => 't', 'd' => 'b', 'e' => 'u', 'o' => 'p', 'h' => 'g', 'j' => 'e', 'i' => 'x', 'k' => 'i'…), Dict('E' => 'O', 'Z' => 'Q', 'X' => 'J', 'C' => 'E', 'B' => 'T', 'D' => 'G', 'A' => 'U', 'R' => 'K', 'G' => 'N', 'O' => 'R'…), Dict('n' => 'z', 'f' => 'x', 'w' => 'u', 'd' => 'v', 'e' => 'j', 'o' => 'f', 'j' => 'r', 'h' => 'q', 'i' => 'k', 'r' => 'n'…))

# julia> encrypt(cipher, 'I')
# 'N': ASCII/Unicode U+004E (category Lu: Letter, uppercase)

# julia> decrypt(cipher, 'N')
# 'I': ASCII/Unicode U+0049 (category Lu: Letter, uppercase)

# julia> encrypt(cipher, 'i')
# 'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

# julia> decrypt(cipher, 'x')
# 'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)

# julia> encrypt(cipher, '!')
# '!': ASCII/Unicode U+0021 (category Po: Punctuation, other)

# julia> encrypt(cipher, "This is the message!")
# "Bgxc xc agu luccsyu!"

# julia> decrypt(cipher, "Bgxc xc agu luccsyu!")
# "This is the message!"

# Cipher agnostic password keeping service
mutable struct Vault
    passwords::Dict{String, String}
    cipher::Cipher
end

function Vault(cipher::Cipher)
    Vault(Dict{String, String}(), cipher)
end

function addlogin!(vault::Vault, login::AbstractString, password::AbstractString)
    vault.passwords[login] = encrypt(vault.cipher, password)
end

function getpassword(vault::Vault, login::AbstractString)
    decrypt(vault.cipher, vault.passwords[login])
end

# example
# julia> vault = Vault(CaesarCipher(23))
# Vault(Dict{String, String}(), CaesarCipher(23))

# julia> addlogin!(vault, "google", "BING")
# "YFKD"

# julia> addlogin!(vault, "amazon", "SECRET")
# "PBZOBQ"

# julia> getpassword(vault, "google")
# "BING"

# julia> getpassword(vault, "amazon")
# "SECRET"

# julia> cipher = SubstitutionCipher()
# SubstitutionCipher(['G', 'M', 'L', 'V', 'A', 'N', 'D', 'S', 'E', 'C'  …  'I', 'K', 'O', 'H', 'B', 'X', 'J', 'T', 'W', 'Z'], ['n', 'a', 'i', 'z', 'o', 'l', 'v', 'g', 'h', 'k'  …  'b', 'u', 'q', 'f', 'e', 'p', 'r', 'w', 'm', 'y'], Dict('E' => 'A', 'Z' => 'Z', 'X' => 'T', 'B' => 'M', 'C' => 'L', 'D' => 'V', 'A' => 'G', 'R' => 'K', 'G' => 'D', 'F' => 'N'…), Dict('n' => 'x', 'f' => 'l', 'w' => 'r', 'd' => 'z', 'e' => 'o', 'o' => 'd', 'h' => 'g', 'j' => 'k', 'i' => 'h', 'k' => 's'…), Dict('E' => 'I', 'Z' => 'Z', 'X' => 'V', 'C' => 'J', 'B' => 'U', 'D' => 'G', 'A' => 'E', 'R' => 'N', 'G' => 'A', 'N' => 'F'…), Dict('n' => 'a', 'f' => 't', 'w' => 'x', 'd' => 'o', 'e' => 'u', 'o' => 'e', 'h' => 'i', 's' => 'k', 'i' => 'c', 'r' => 'w'…))

# julia> vault2 = Vault(cipher)
# Vault(Dict{String, String}(), SubstitutionCipher(['G', 'M', 'L', 'V', 'A', 'N', 'D', 'S', 'E', 'C'  …  'I', 'K', 'O', 'H', 'B', 'X', 'J', 'T', 'W', 'Z'], ['n', 'a', 'i', 'z', 'o', 'l', 'v', 'g', 'h', 'k'  …  'b', 'u', 'q', 'f', 'e', 'p', 'r', 'w', 'm', 'y'], Dict('E' => 'A', 'Z' => 'Z', 'X' => 'T', 'B' => 'M', 'C' => 'L', 'D' => 'V', 'A' => 'G', 'R' => 'K', 'G' => 'D', 'F' => 'N'…), Dict('n' => 'x', 'f' => 'l', 'w' => 'r', 'd' => 'z', 'e' => 'o', 'o' => 'd', 'h' => 'g', 'j' => 'k', 'i' => 'h', 'k' => 's'…), Dict('E' => 'I', 'Z' => 'Z', 'X' => 'V', 'C' => 'J', 'B' => 'U', 'D' => 'G', 'A' => 'E', 'R' => 'N', 'G' => 'A', 'N' => 'F'…), Dict('n' => 'a', 'f' => 't', 'w' => 'x', 'd' => 'o', 'e' => 'u', 'o' => 'e', 'h' => 'i', 's' => 'k', 'i' => 'c', 'r' => 'w'…)))

# julia> addlogin!(vault2, "amazon", "SECRET")
# "OALKAH"

# julia> addlogin!(vault2, "apple", "JONAGOLD")
# "CPRGDPYV"

# julia> getpassword(vault2, "amazon")
# "SECRET"

# julia> getpassword(vault2, "apple")
# "JONAGOLD"