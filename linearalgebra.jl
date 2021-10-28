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
Diagonal(unit_cost) * amount

#this obviously gives same answer as row 7 since transpose makes it a column
transpose(unit_cost) * amount

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
inv(z)
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