# column
unit_cost_c = [6 4 3 2 1]
# row
amount_r = [2, 3, 4, 6, 12]

# row * column adds up to a sum
unit_cost_c * amount_r

using LinearAlgebra
# define as row
unit_cost = [6, 4, 3, 2, 1]
# diagnol matrix times a vector gives a vector
Diagonal(unit_cost) * amount_r

#this obviously gives same answer as row 7 since transpose makes it a column
transpose(unit_cost) * amount_r

# matrix with different orders in eacch column
amounts =  [6 1 10;
            4 1 10;
            3 1 10;
            2 1 10;
            1 1 10]

# get the summed cost for each column order
transpose(unit_cost) * amounts

# first row calculates sum based on unit costs (as before) 
# second row calculates average number of units (divide by 5 and sum)
operations =   [6.0 4.0 3.0 2.0 1.0;
                0.2 0.2 0.2 0.2 0.2]
operations * amounts

# identity operation
Diagonal([1,1,1]) * [8,12,3]
# I does it better
I*[8,12,3]
I*[8,12,3,5]

# reverse operation - since this is part of base not sure why Engheim doesnt mention simple operator
R =  [0 0 1;
      0 1 0;
      1 0 0]

R * [8, 12, 3]
reverse([8, 12, 3])
# can also reverse a row
reverse([8 12 3])
# you can use multiplication on the matrix
2I*[8, 12, 3]
# more examples
z = [1 2 3;
     4 5 6;
     7 8 9]

I*z
2*z
reverse(z)
2*reverse(z)
# be careful with inverse
#inv(z) # commented out see below
# this gives you a singular exception. If you take the determinant you see it is ) which explains why
det(z)
# a simple change solves the problem
zf = [1 2 3;
      4 5 6;
      7 8 10]
det(zf)
inv(zf)
# rounding error for floating point doesnt create perfect identity
If = zf * inv(zf)
# but its close enough
I ≈ If  # yields true

# Back to Engheim
A =   [1  1 -2;
       1 -1 -1;
       1  1  3]

B = [3, 0, 12]

X = inv(A)*B

A*X
B
A*X ≈ B  # yields true

# concatenation
C = [1 3 5]
D = [7 9 11]
E = [1, 3, 5]
F = [7, 9, 11]
G = [1 3 5; 2 4 6]
H = [7 9 11; 8 10 12]

# horizontal - dims indiccate which dimention 
hcat(C, D)
cat(C, D, dims=2)
hcat(E, F)
cat(E, F, dims=2)
hcat(G, H)
cat(G, H, dims=2)
hcat(G, 2G, 3G, 4G)


# vertical
vcat(C, D)
cat(C, D, dims=1)
vcat(E, F)
cat(E, F, dims=1)
vcat(G, H)
cat(G, H, dims=1)
vcat(C, D, C, D)

# creating matrices
zeros(Int8, 3, 4)
ones(Int8, 3, 4)
rand(Int8, 3, 4)
zeros(Float64, 3, 4)
ones(Float64, 3, 4)
rand(Float64, 3, 4)
fill(12, 3, 4)  #Int64
fill(12.0, 3, 4) #Float64
fill(1//2, 3, 4) #Rational{Int64}
fill(0x4, 3, 4) #Int8

# in the example on page 249 for vector addition this is what you are really seeing:
u = [4,2]  # from the origin [0,0]
v = [-1,1] # from the starting point [4,2]
u + v 
# yields:
# 2-element Vector{Int64}:
# 3
# 3
# scalar addition needs to be done per element
u .+ 1
# yields:
# 2-element Vector{Int64}:
# 5
# 3
# assignment of vectors
w = v
w == v # true
w[1] = 1 # change w
w == v # true
v[2] = 2 # change v
w == v # true
# element wise assignment has different result in that w is NOT pointing to unit
# w .= u is equivalent to w[1] = 4 and w[2] = 2 which obviously has no impact on u
w .= u
w == v # true
w == u # true temporarily
v == u # true temporarily
# but
w[1] = 1 # change w
w == v # true
w == u # false
v == u # false
# subtraction
v = [-1, 1]
# next two give same result. This also shows multiplying vector by scaler works as expected
u + (-v)
u - v
# vector rotation
x = [3, 4]
xm = 3*[1, 0] + 4*[0, 1]
x == xm # true
# rotate x 90 degrees
xmr = 3*[0, 1] + 4*[-1, 0]
# do it as matrix multiplication - NB: Engheim got the matrix wrong 
# [0,1] and [-1, 0] are columns not rows so the matrix looks like A below
A = [ 0 -1;
      1 0]
# a vector is a column not a row
# multiply each row in the vector x times a column in A and add the two vectors together (as in xmr)
# 3 is first row times [0, 1] + 4 is second row * [-1,0] giving vector (column) [-4, 3]
A*x == xmr # true


#rotation(degrees)
#Create a rotation matrix for rotating a 2D vector `deg` degrees.

function rotation(deg::Real)
  rad = deg2rad(deg)
  cosθ = cos(rad)
  sinθ = sin(rad)
  
  [cosθ -sinθ;
   sinθ  cosθ] 
end

# create a Matrix for rotating a vector 90 degrees
M = rotation(90)

# create a saaple [x,y] vector and rotate 90 degrees
v = [3, 4]
M*v
v2 = [3, 3]
M*v2
v3 = [3, 0]
M*v3
v4 = [0, 3]
M*v4

# # Dot Product
# # important you add "using LinearAlgebra" before running the following
# a = [2, 3]
# b = [3, 1]

# # to get the dot product character type "a \cdot[tab] b" (i.e. thit the tab key)
# a ⋅ b
# transpose(a)*b
# dot(a, b)

# # Work equations
# r = [3, 1]
# # the norm is the sqrt of r ⋅ r which gives the length of the vector r
# # u is a unit vector with same direction as r (divide r by its lenght 
# # to get a vector lenght 1 with same direction as r)
# u = r / norm(r)
# # in the graph in the book Engheim shifts teh vector from the 0origin
# F = [2, 3]
# # the work
# F ⋅ u
# # from this equality “𝐅 ⋅ 𝐮 = |𝐅| cos θ " we can calulate the angle θ
# θ = acos(F ⋅ u/norm(F))
# # check the equality
# F ⋅ u == norm(F) * cos(θ)
# # substitute back the defintion of u
# F ⋅ (r/norm(r)) == norm(F) * cos(θ)
# # multiply norm(r) to both sides of the equation (there are rounding errors)
# F ⋅ r ≈ norm(F) * norm(r) * cos(θ)
# # Cross product
# u = [6, 0, 0]
# v = [3, 4, 0]
# # ⨯ is \times
# w = u ⨯ v