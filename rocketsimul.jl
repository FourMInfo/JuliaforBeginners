# bring in the previous definitions
include("rocketparts.jl")
include("rigidbody.jl")
# this is slightly different implementation than rocketcoll.jl
# so we start from just the parts

# copied code that follows from rocketcoll.jl 
# since we need it and it is not in rocketparts.jl
struct NoPayload <: Payload
end

mass(payload::NoPayload) = 0.0

Rocket(tank::Tank, engine::Engine) = Rocket(NoPayload(), tank, engine)

const nopayload = NoPayload()

# new definition of SpaceVehicle with rigid body and boolean to toggle gravity
mutable struct SpaceVehicle
    active_stage::Payload
    body::RigidBody
    gravity::Bool
end

# new constructor
function SpaceVehicle(rockets::Array{Rocket})
    first_stage = nopayload
    for r in reverse(rockets)
        if first_stage != nopayload
            r.payload = first_stage
        end
        first_stage = r
    end
    body = RigidBody(mass(first_stage), 0.0)
    SpaceVehicle(first_stage, body, true)
end

SpaceVehicle(rockets::Rocket...) = SpaceVehicle(collect(rockets))

# also copied the following from rocketcoll.jl
function stage_separate!(ship::SpaceVehicle)
    stage = ship.active_stage
    if stage isa Rocket
       ship.active_stage = stage.payload
       stage.payload
    else
       nothing
    end
 end
# thrust functions build upon each other
thrust(engine::SingleEngine)   = engine.thrust
thrust(cluster::EngineCluster) = thrust(cluster.engine) * cluster.count
thrust(ship::SpaceVehicle) = thrust(ship.active_stage)
thrust(payload::Payload) = 0.0
thrust(r::Rocket) = thrust(r.engine)

# mass functions also built upon each other. We get mass for 
# higher level objects by getting the mass of lower level objects:
mass(tank::Tank) = tank.dry_mass + tank.propellant
mass(payload::NoPayload) = 0.0
mass(probe::SpaceProbe) = probe.mass
mass(capsule::Capsule) = capsule.mass
mass(satellite::Satellite) = satellite.mass

function mass(r::Rocket)
    mass(r.payload) + mass(r.tank) + mass(r.engine)
end

mass(ship::SpaceVehicle) = mass(ship.active_stage)

# The launch! function relies on knowing how much propellant is left 
# to decide whether stage separation needs to be performed.
propellant(non_rocket) = 0.0
propellant(r::Rocket)          = r.tank.propellant
propellant(r::SpaceVehicle)    = propellant(r.active_stage)
# code used for the actual simulation

# the rotation function we defined in linearalgebra.jl 
# copied it here so as not to include all the other baggage
function rotation(deg::Real)
    rad = deg2rad(deg)
    cosθ = cos(rad)
    sinθ = sin(rad)
    
    [cosθ -sinθ;
     sinθ  cosθ] 
  end

  const earth_radius = 6.38e6
  const earth_mass   = 5.98e24
  const gravitation_constant = 6.673e-11

# Engheim has the annoying habit of using new things without explainging
# No problem that he wants to encourage you to look stuff up, but at least
# provide the link!
# Here is documentation on doc strings in Julia: https://docs.julialang.org/en/v1/manual/documentation/
"""
   earth_gravity(d)
The acceleration of gravity distance `d` 
from earth surface. Should be `g₀` when `d == 0`.
"""
function earth_gravity(d::Real)
    (gravitation_constant * earth_mass)/(earth_radius + d)^2
end

function gravity_force(body::RigidBody)
  _, elevation = body.position
  [-earth_gravity(elevation) * body.mass, 0]
end

# note Engheim's signature which differentiates this update from the one called inside
# I used a different function name to make it less confusing# 
#function update!(ship::SpaceVehicle, Δt::Number)
function simupdate!(ship::SpaceVehicle, Δt::Number)
    stage = ship.active_stage
    body  = ship.body

    # call the update function defined in rocketparts.jl
    update!(stage, Δt)

    # Engheim correctly points out it is better to copy the ship data to the rigid body
    # instead of including the ship in hte rigidbody for separation of concerns
    # rigidbody.jl is a separate module so can be reused elsewhere 
    body.mass   = mass(ship)
    # Engheim: "We multiply a vector representing the force produced by the rocket engine 
    # with a rotation matrix. This matrix is setup to rotate the force to the same 
    # direction as the one the ship is pointing.”
    body.force  = rotation(body.orientation) * [thrust(ship), 0.0]
    # add the force of gravity if it is toggled as true
    if ship.gravity
        body.force += gravity_force(body)
    end

    integrate!(body, Δt)
end

# simulation code
# max duration is to ensure no infinite loops
function launch!(ship::SpaceVehicle, Δt::Number; max_duration::Number = 5000)
    t = 0 # start time
    while ship.active_stage isa Rocket
        while propellant(ship) > 0 && t <= max_duration
            simupdate!(ship, Δt)
            t += Δt
        end
        stage_separate!(ship)

        # Current stage cannot get us higher
        if thrust(ship) <= 0
            return ship
        end
    end
    ship    
end

# helper functions
pos(ship::SpaceVehicle) = ship.body.position
velocity(ship::SpaceVehicle) = ship.body.velocity

# Example run
# merlin  = Engine(845e3, 282, 470)
# cluster = EngineCluster(merlin, 9)

# firststage  = Rocket(Tank(23.1e3, 418.8e3), cluster)
# secondstage = Rocket(SpaceProbe(22e3), 
#                      Tank(4e3, 111.5e3),
#                      Engine(934e3, 348, 470))
                            
# ship = SpaceVehicle(firststage, secondstage)
# Δt = 0.1
# launch!(ship, Δt)
# yay! it works
# julia> velocity(ship)
# 2-element Vector{Float64}:
#  3703.572857010847
#     0.0

# julia> pos(ship)
# 2-element Vector{Float64}:
#  937346.6102144092
#       0.0