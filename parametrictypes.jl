# example with constraint in struct
# struct Vector2D{T<:Number}
#    x::T
#    y::T
# end

# function dot(u::Vector2D{T}, v::Vector2D{T}) where T
#     u.x*v.x + u.y*v.y
# end

# function cross(u::Vector2D{T}, v::Vector2D{T}) where T
#     u.x*v.y - u.y*v.x
# end

# julia> a = Vector2D(1, 2)
# Vector2D{Int64}(1, 2)

# julia> b = Vector2D(3, 4)
# Vector2D{Int64}(3, 4)

# julia> c =Vector2D{Char}('A', 'B')
# ERROR: TypeError: in Vector2D, in T, expected T<:Number, got Type{Char}
# Stacktrace:
#  [1] top-level scope
#    @ REPL[11]:1

# julia> dot(a,b)
# 11

# julia> cross(a,b)
# -2

# dot(a,c)

# same example with simpler method signature 
# in this version  u and v can be of different Number subtype and still works
# struct Vector2D{T<:Number}
#    x::T
#    y::T
# end

# function dot(u::Vector2D, v::Vector2D)
#     u.x*v.x + u.y*v.y
# end

# function cross(u::Vector2D, v::Vector2D)
#     u.x*v.y - u.y*v.x
# end

# julia> a = Vector2D(1, 2)
# Vector2D{Int64}(1, 2)

# julia> b = Vector2D(3.0, 4.0)
# Vector2D{Float64}(3.0, 4.0)

# julia> c =Vector2D{Char}('A', 'B')
# ERROR: TypeError: in Vector2D, in T, expected T<:Number, got Type{Char}
# Stacktrace:
#  [1] top-level scope
#    @ REPL[7]:1

# julia> dot(a,b)
# 11.0

# julia> cross(a,b)
# -2.0


# example with constraint in method - allows non Number Vecttor2
# but methods are type protected
# struct Vector2D{T}
#    x::T
#    y::T
# end

# function dot(u::Vector2D{T}, v::Vector2D{T}) where T <: Number
#     u.x*v.x + u.y*v.y
# end

# function cross(u::Vector2D{T}, v::Vector2D{T}) where T <: Number
#     u.x*v.y - u.y*v.x
# end

# julia> a = Vector2D(1, 2)
# Vector2D{Int64}(1, 2)

# julia> b = Vector2D(3, 4)
# Vector2D{Int64}(3, 4)

# julia> c =Vector2D{Char}('A', 'B')
# Vector2D{Char}('A', 'B')

# julia> a = Vector2D(1, 2)
# Vector2D{Int64}(1, 2)

# julia> b = Vector2D(3, 4)
# Vector2D{Int64}(3, 4)

# julia> c =Vector2D{Char}('A', 'B')
# Vector2D{Char}('A', 'B')

# julia> dot(a,b)
# 11

# julia> cross(a,b)
# -2

# julia> dot(a,c)
# ERROR: MethodError: no method matching dot(::Vector2D{Int64}, ::Vector2D{Char})
# Closest candidates are:
#   dot(::Vector2D{T}, ::Vector2D{T}) where T<:Number at REPL[4]:1
# Stacktrace:
#  [1] top-level scope
#    @ REPL[14]:1

# julia> cross(a,c)
# ERROR: MethodError: no method matching cross(::Vector2D{Int64}, ::Vector2D{Char})
# Closest candidates are:
#   cross(::Vector2D{T}, ::Vector2D{T}) where T<:Number at REPL[5]:1
# Stacktrace:
#  [1] top-level scope
#    @ REPL[15]:1
