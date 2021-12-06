# Engheim's "functional" approach is mostly about using closures
# But just because he doesnt want to use struct based types, doesn't mean you have to not
# use multiple dispatch, which he does in his supposedly oo solution
# here is a cleaner functional implementation which preserves the use of closures

# Since the alphabet we are using is hardcoded in the function, the length can be hardcoded as well
# no need for a const
function encrypt(ch::Char, shift::Int)
    ch in 'A':'Z' ? 'A' + mod((ch - 'A') + shift, 26) :
    ch in 'a':'z' ? 'a' + mod((ch - 'a') + shift, 26) :
    #= otherwise =# ch
end

# if we dont plan to allow single char encyption we dont need this funcion
function decrypt(ch::Char, shift::Int)
    # we reuse Engheim's nice trick
    encrypt(ch,-shift)
end

# once you define the encrypt/decrypt pair for the cipher
# these functions handle strings for you
function encrypt(shift::Int)
    message -> map(message) do ch
        encrypt(ch, shift)
    end
end
    
function decrypt(shift::Int)
    message -> map(message) do ch
        encrypt(ch, -shift)
    end
end

# Example
# As Engheim notes the mdisadvantage of using a closure in this case:
# “You don’t have any guarantees that the decryption function is using the same shift 
# value as the encryption function.” But in a real world application we can define
# a const that preserves this value across associated encrypt/decrypt 
# julia> const s1 = 1
# 1
# There is also an extra step in having to define two closures, whereas in the so-called "OO"
# solution you only have to instanciate the cipher once. In that sense, preserving state in a
# struct does seem a better solution for this case
# julia> cipher = encrypt(s1)
# #5 (generic function with 1 method)

# julia> decipher = decrypt(s1)
# #9 (generic function with 1 method)

# julia> message = "ABC"
# "ABC"

# julia> emessage = cipher(message)
# "BCD"

# julia> decipher(emessage)
# "ABC"

# Substitution cipher
using Random
# Engheim's solution only works because he requires uppercase passwords
# this solution is a bit more complex

# a nice helper function to create the shuffles
function makeshuffle()::Tuple{Dict{Char, Char}, Dict{Char, Char}} 
    lowdict = Dict(zip('a':'z', shuffle('a':'z')))
    updict = Dict(zip('A':'Z', shuffle('A':'Z')))
    return updict, lowdict
end

function encrypt(ch::Char, updict::Dict{Char, Char}, lowdict::Dict{Char, Char})
    ch in 'A':'Z' ? get(updict, ch, ch) :
    ch in 'a':'z' ? get(lowdict, ch, ch) :
    #= otherwise =# ch
end

# Once again this function is not necessary if we don't need single char decryption
function decrypt(ch::Char, rupdict::Dict{Char, Char}, rlowdict::Dict{Char, Char})
    ch in 'A':'Z' ? get(rupdict, ch, ch) :
    ch in 'a':'z' ? get(rlowdict, ch, ch) :
    #= otherwise =# ch
end

# Closures
function encrypt(updict::Dict{Char, Char}, lowdict::Dict{Char, Char})
    message -> map(message) do ch
        encrypt(ch, updict, lowdict)
    end
end

function decrypt(updict::Dict{Char, Char}, lowdict::Dict{Char, Char})
    rupdict = Dict(values(updict) .=> keys(updict))
    rlowdict = Dict(values(lowdict) .=> keys(lowdict))
    message -> map(message) do ch
        encrypt(ch, rupdict, rlowdict)
    end
end

# Example
# julia> dicts = makeshuffle()
# (Dict('E' => 'M', 'Z' => 'A', 'X' => 'O', 'B' => 'F', 'C' => 'L', 'D' => 'K', 'A' => 'Y', 'R' => 'P', 'G' => 'X', 'F' => 'J'…), Dict('n' => 't', 'f' => 'c', 'w' => 's', 'd' => 'k', 'e' => 'd', 'o' => 'w', 'h' => 'i', 'j' => 'b', 'i' => 'v', 'k' => 'm'…))

# julia> cipher = encrypt(dicts[1], dicts[2])
# #41 (generic function with 1 method)

# julia> decipher = decrypt(dicts[1], dicts[2])
# #45 (generic function with 1 method)

# julia> emessage = cipher("Google sucks!")
# "Xwwqhd ueamu!"

# julia> decipher(emessage)
# "Google sucks!"

# Password Keeper
mutable struct Vault
    passwords::Dict{String, String}
    encrypt::Function
    decrypt::Function
end

function Vault(encrypter, decrypter)
    Vault(Dict{String, String}(), encrypter, decrypter)
end

function addlogin!(vault::Vault, login::AbstractString, password::AbstractString)
    vault.passwords[login] = vault.encrypt(password)
end

function getpassword(vault::Vault, login::AbstractString)
    vault.decrypt(vault.passwords[login])
end

# Example
# Caeser
# julia> const s1 = 23
# 23

# julia> vault = Vault(encrypt(s1), decrypt(s1))
# Vault(Dict{String, String}(), var"#1#3"{Int64}(23), var"#5#7"{Int64}(23))

# julia> addlogin!(vault, "google", "BING")
# "YFKD"

# julia> getpassword(vault, "google")
# "BING"

# julia> addlogin!(vault, "amazon", "Secret!")
# "Pbzobq!"

# julia> getpassword(vault, "amazon")
# "Secret!"

# Substitution
# julia> using Random

# julia> dicts = makeshuffle()
# (Dict('E' => 'X', 'Z' => 'A', 'X' => 'C', 'B' => 'W', 'C' => 'P', 'D' => 'U', 'A' => 'K', 'R' => 'G', 'G' => 'S', 'F' => 'Y'…), Dict('n' => 'q', 'f' => 'y', 'w' => 'j', 'd' => 'v', 'e' => 'c', 'o' => 'h', 'h' => 'w', 'j' => 'd', 'i' => 'p', 'k' => 'f'…))

# julia> vaults = Vault(encrypt(dicts[1], dicts[2]), decrypt(dicts[1], dicts[2]))
# Vault(Dict{String, String}(), var"#9#11"{Dict{Char, Char}, Dict{Char, Char}}(Dict('E' => 'X', 'Z' => 'A', 'X' => 'C', 'B' => 'W', 'C' => 'P', 'D' => 'U', 'A' => 'K', 'R' => 'G', 'G' => 'S', 'F' => 'Y'…), Dict('n' => 'q', 'f' => 'y', 'w' => 'j', 'd' => 'v', 'e' => 'c', 'o' => 'h', 'h' => 'w', 'j' => 'd', 'i' => 'p', 'k' => 'f'…)), var"#13#15"{Dict{Char, Char}, Dict{Char, Char}}(Dict('n' => 'l', 'f' => 'k', 'w' => 'h', 'd' => 'j', 'e' => 'p', 'o' => 'q', 'j' => 'w', 'y' => 'f', 'h' => 'o', 'r' => 'r'…), Dict('E' => 'L', 'Z' => 'H', 'X' => 'E', 'C' => 'X', 'B' => 'S', 'D' => 'O', 'A' => 'Z', 'R' => 'P', 'G' => 'R', 'Q' => 'K'…)))

# julia> addlogin!(vaults, "apple", "My Super Secret!")
# "Hk Bxecr Bcsrci!"

# julia> getpassword(vaults, "apple")
# "My Super Secret!"
