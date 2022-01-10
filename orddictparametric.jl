mutable struct OrdDict{K,V} <: AbstractDict{K,V}
    items::Vector{Pair{K, V}}
end

# constructors
OrdDict{K,V}() where {K,V} = OrdDict(Pair{K, V}[])
OrdDict(items...) = OrdDict(collect(items))

import Base: getindex, setindex!, get, delete!,
    length, iterate,
    getproperty, setproperty!,
    haskey, isempty,
    union,
    copy, push!

# iteration definitions
length(a::OrdDict)     = length(a.items)
isempty(a::OrdDict)    = isempty(a.items)
iterate(a::OrdDict)    = iterate(a.items)
iterate(a::OrdDict, i) = iterate(a.items, i)

# example inferred type
# julia> pairs = ["two" => 2, "four" => 4]
# 2-element Vector{Pair{String, Int64}}:
#   "two" => 2
#  "four" => 4

# julia> dict = OrdDict(pairs)
# OrdDict{String, Int64} with 2 entries:
#   "two"  => 2
#   "four" => 4

# example of dictionary behavior
# julia> item = OrdDict(:row=> "1", :column=> "2")
# OrdDict{Symbol, String} with 2 entries:
#   :row    => "1"
#   :column => "2"

# julia> for (k,v) in item
#            println("key: ", k, " value: ", v)
#        end
# key: row value: 1
# key: column value: 2

# # Engheim forgot to assign the collection to a variable
# julia> map(first, item)
# ERROR: map is not defined on dictionaries
# Stacktrace:
#  [1] error(s::String)
#    @ Base ./error.jl:33
#  [2] map(f::Function, #unused#::OrdDict{Symbol, String})
#    @ Base ./abstractarray.jl:2880
#  [3] top-level scope
#    @ REPL[8]:1

# julia> items = collect(item)
# 2-element Vector{Pair{Symbol, String}}:
#     :row => "1"
#  :column => "2"

# julia> map(first, items)
# 2-element Vector{Symbol}:
#  :row
#  :column

# julia> map(last, items)
# 2-element Vector{String}:
#  "1"
#  "2"

# need to add parametric type to method signature to match struct
function getindex(a::OrdDict{K, V}, key::K) where {K, V}
    for item in a.items
        if first(item) == key
            return last(item)
        end
    end
    throw(KeyError(key))
end

# alternative multiple dispatch implementation by number - same as original
getindex(a::OrdDict, index::Integer) = a.items[index]

# need to add parametric type to method signature to match struct
function setindex!(a::OrdDict{K, V}, value::V, key::K) where {K, V}
    for (i, item) in enumerate(a.items)
        if first(item) == key
            a.items[i] = key => value
            return
        end
    end
    push!(a.items, key => value)
end

# need to add parametric type to method signature to match struct
function push!(a::OrdDict{K, V}, x::Pair{K, V}) where {K, V}
   push!(a.items, x)
end
# need this for setproperty! be;ow
push!(a::OrdDict, x::Pair{Symbol, String}) = push!(a.items, x)


function haskey(a::OrdDict{K, V}, key::K) where {K, V}
    for item in a.items
        if first(item) == key
            return true
        end
    end
    false
end

function delete!(a::OrdDict{K, V}, key::K) where {K, V}
    for (i, item) in enumerate(a.items)
        if first(item) == key
            deleteat!(a.items, i)
        end
    end
    a
end

# make it act like a dictionary
# need to keep the OrdDict.items to behave as usual
# only works if explicity in method signature make Key type symbol, since original expects value of type symbol
function getproperty(a::OrdDict, key::Symbol)
    if key == :items
        getfield(a, :items)
    else
        a[key]
    end
end

# value can be of any type
function setproperty!(a::OrdDict, key::Symbol, value)
    if key == :items
        setfield!(a, :item, value)
    else
        a[key] = value
    end
end

# use example in OrdDict
# julia> d = OrdDict(:one => "1", :two => "2")
# OrdDict{Symbol, String} with 2 entries:
#   :one => "1"
#   :two => "2"

# julia> d[:three] = "three"
# "three"

# julia> d.three
# "three"

# julia> d.four = "4"
# "4"

# julia> d.items
# 4-element Vector{Pair{Symbol, String}}:
#    :one => "1"
#    :two => "2"
#  :three => "three"
#   :four => "4"

# julia> d[:two]
# "2"

# Example where value is Integer
# julia> d = OrdDict(:one => 1, :two => 2)
# OrdDict{Symbol, Int64} with 2 entries:
#   :one => 1
#   :two => 2

# julia> d[:three] = 3
# 3

# julia> d[:two]
# 2

# julia> d.items
# 3-element Vector{Pair{Symbol, Int64}}:
#    :one => 1
#    :two => 2
#  :three => 3