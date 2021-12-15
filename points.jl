struct Point
  x::Float64
  y::Float64
end

import Base: show
# vanilla version
show(io::IO, p::Point) = print(io, "($(p.x), $(p.y))")

# json vewersion
function show(io::IO, ::MIME"text/json", p::Point)
    print(io, "{x = $(p.x), y = $(p.y)}")
end

# plain text version
function show(io::IO, ::MIME"text/plain", p::Point)
    # extended version with compact option
    if get(io, :compact, true)
        print(io, "($(p.x), $(p.y))")
    else
        print(io, "Point($(p.x), $(p.y))")
    end
end

# XML version
function show(io::IO, ::MIME"text/xml", p::Point)
    println(io, "<point>")
    println(io, "\t<x>$(p.x)</x>")
    println(io, "\t<y>$(p.y)</y>")
    println(io, "</point>")        
end

# Example
# julia> p = Point(10, 3)
# Point(10.0, 3.0)

# julia> p
# Point(10.0, 3.0)

# julia> display("text/json", p)
# {x = 10.0, y = 3.0}
# julia> display("text/xml", p)
# <point>
#         <x>10.0</x>
#         <y>3.0</y>
# </point>

# julia> display("text/plain", p)
# Point(10.0, 3.0)

# julia> repr("text/json", p)
# "{x = 10.0, y = 3.0}"

# Compact Example
# julia> io = IOContext(stdout, :compact => false)
# IOContext(Base.TTY(RawFD(15) open, 0 bytes waiting))

# julia> show(io, "text/plain", p)
# Point(10.0, 3.0)
# julia> p
# (10.0, 3.0)

# julia> io = IOContext(stdout, :compact => true)
# IOContext(Base.TTY(RawFD(15) open, 0 bytes waiting))

# julia> show(io, "text/plain", p)
# (10.0, 3.0)
# julia> p
# (10.0, 3.0)