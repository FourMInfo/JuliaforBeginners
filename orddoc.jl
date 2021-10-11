import Base: getindex, setindex!, get, delete!,
    length, iterate,
    getproperty, setproperty!,
    haskey, isempty,
    union,
    copy

mutable struct OrdDict <: AbstractDict{Symbol,String}
    items::Vector{Pair{Symbol, String}}
end
   
OrdDict()  = OrdDict(Pair{Symbol, String}[])
OrdDict(items...) = OrdDict(collect(items))

# iteration definitions
length(a::OrdDict)     = length(a.items)
isempty(a::OrdDict)    = isempty(a.items)
iterate(a::OrdDict)    = iterate(a.items)
iterate(a::OrdDict, i) = iterate(a.items, i)

# getindex needed for dictionary-like key lookup
function getindex(a::OrdDict, key::Symbol)
    for item in a.items
        if first(item) == key
            return last(item)
        end
    end
    throw(KeyError(key))
end

# alternative multiple dispatch implementation by number
getindex(a::OrdDict, index::Integer) = a.items[index]

function setindex!(a::OrdDict, value::AbstractString, key::Symbol)
    for (i, item) in enumerate(a.items)
        if first(item) == key
            a.items[i] = key => value
            return
        end
    end
    push!(a.items, key => value)
end

push!(a::OrdDict, x::Pair{Symbol, String}) = push!(a.items, x)


function haskey(a::OrdDict, key::Symbol)
    for item in a.items
        if first(item) == key
            return true
        end
    end
    false
end

function delete!(a::OrdDict, key::Symbol)
    for (i, item) in enumerate(a.items)
        if first(item) == key
            deleteat!(a.items, i)
        end
    end
    a
end

# make it act like a dictionary
# need to keep the OrdDict.items to behave as usual
function getproperty(a::OrdDict, key::Symbol)
    if key == :items
        getfield(a, :items)
    else
        a[key]
    end
end

function setproperty!(a::OrdDict, key::Symbol, value::AbstractString)
    if key == :items
        setfield!(a, :item, value)
    else
        a[key] = value
    end
end

# julia> d = OrdDict(:one => "1", :two => "2")
# OrdDict with 2 entries:
#   :one => "1"
#   :two => "2"

# julia> d.one
# "1"

# julia> d.items
# 2-element Vector{Pair{Symbol, String}}:
#  :one => "1"
#  :two => "2"

# julia> d.two
# "2"

# julia> d.three = "3"
# "3"

# julia> d.three
# "3"

# julia> d.items
# 3-element Vector{Pair{Symbol, String}}:
#    :one => "1"
#    :two => "2"
#  :three => "3"


# julia> for (k,v) in d
#            println("key: ", k, " value: ", v)
#        end
# key: one value: 1
# key: two value: 2
# key: three value: 3