mutable struct Tank
   dry_mass::Float64    # excluding propellant
   total_mass::Float64  # including propellant
   propellant::Float64  # propellant mass left

   "Create a full tank"
   function Tank(dry_mass::Number, total_mass::Number)
      new(dry_mass, total_mass, total_mass - dry_mass)
   end
end

mass(tank::Tank) = tank.dry_mass + tank.propellant

abstract type Payload end

struct Capsule <: Payload
   mass::Float64
end

struct SpaceProbe <: Payload
   mass::Float64
end

struct Satellite <: Payload
   mass::Float64
end

mass(probe::SpaceProbe) = probe.mass
mass(capsule::Capsule) = capsule.mass
mass(satellite::Satellite) = satellite.mass

abstract type Engine end

struct SingleEngine <: Engine
   thrust::Float64  # Newton
   Isp::Float64     # Specific Impulse
   mass::Float64    # Kg
end

# constructor. Can use Engine since its an abstract type without its own constructor
function Engine(thrust::Number, Isp::Number, mass::Number)
    SingleEngine(thrust, Isp, mass)
end

struct EngineCluster <: Engine
   engine::SingleEngine
   count::Int8
end

thrust(engine::SingleEngine)   = engine.thrust
thrust(cluster::EngineCluster) = thrust(cluster.engine) * cluster.count

Isp(engine::SingleEngine)   = engine.Isp
Isp(cluster::EngineCluster) = Isp(cluster.engine)

mass(engine::SingleEngine)  = engine.mass
mass(cluster::EngineCluster) = mass(cluster.engine) * cluster.count

mutable struct Rocket <: Payload
   payload::Payload
   tank::Tank
   engine::Engine
end

function mass(r::Rocket)
   mass(r.payload) + mass(r.tank) + mass(r.engine)
end

g₀ = 9.80665 # m/s^2 acceleration of gravity on earth
mass_flow(thrust::Number, Isp::Number) = thrust / (Isp * g₀)


# update propellant depletion over time
function update!(r::Rocket, Δt::Number)
   mflow = mass_flow(thrust(r.engine), Isp(r.engine))
   r.tank.propellant -= min(mflow * Δt, r.tank.propellant)
end

#Example

second_stage = Rocket(SpaceProbe(22.8e6), 
                     Tank(4e3, 111.5e3), 
                     Engine(845e3, 348, 470)
                     )

first_stage = Rocket(second_stage, 
                     Tank(22e3, 433e3), 
                     EngineCluster(Engine(845e3, 282, 470), 9))
