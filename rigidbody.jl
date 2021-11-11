mutable struct RigidBody
    # where rocket currently is
    position::Vector{Float64}  
    # direction and speed of motion
    velocity::Vector{Float64}
    # sum of all forces working on rocket
    force::Vector{Float64}
    # angle rocket is pointing and dirction of thrust
    orientation::Float64
    # changes as fuel burns and stages ejected
    mass::Float64
end

# constructor with simplifying assumptions
function RigidBody(mass::Real, force::Real)
    p = [0, 0]
    v = [0, 0]
    F = [force, 0]
    θ = 0

    RigidBody(p, v, F, θ, mass)
end

# convenience functions
force(body::RigidBody) = body.force
mass(body::RigidBody)  = body.mass
acceleration(body::RigidBody) = force(body) / mass(body)

# explicit euler method numerical approxemation to an integral
function integrate!(body::RigidBody, Δt::Number)
    body.position += body.velocity * Δt
    body.velocity += acceleration(body) * Δt
    body
end