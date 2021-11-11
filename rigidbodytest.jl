include("rigidbody.jl")

using Statistics

mass1 = 1.0  # kg
force1 = 4.0 # Newton
Δt = 0.1

body = RigidBody(mass1, force1)
ts = 0:Δt:200
# calculate the approximation using the integration
approx = Float64[]
for t in ts
    integrate!(body, Δt)
    push!(approx, body.position[1])
end

# analytic calculation using the standard mechanics model equation
# abd where the starting distance and velocity are set to 0
acceleration1 = force1/mass1
distance(t) = 0.5*acceleration1*t^2

# created an array of calculations of expected distance for each point in time
expected = map(distance, ts)

# create an array with the difference between expected and approximate
# the zip maps the diff function to the tuple with multiple iterators
# since the calculation here isn't stateful it can all happen simultaneously
diff(v) = abs(last(v) - first(v))
error = map(diff, zip(expected, approx))

# calculate  the mean of expected and approximate and 
# see how small the difference is
# “julia> mean(error)
# 19.99999999968928

# julia> mean(expected)
# 26673.333333333332

# julia> mean(error)/mean(expected)
# 0.0007498125468516351
