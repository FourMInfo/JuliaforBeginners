include("rocketcoll.jl")

# need to import show to extend. Without import we are shadowing show
import Base: show

const tab = "   "

function show(io::IO, r::Rocket, depth::Integer = 0)
    println(io, tab^depth, "Rocket(")
    depth += 1

    show(io, r.tank, depth)
    println(io, ",")
    show(io, r.engine, depth)

    if r.payload != nopayload
        println(io, ",")
        # Engheim left out dealing with non-Rocket Payload
        # recurse if payload is rocket
        if typeof(r.payload) == Rocket
            show(io, r.payload, depth)
        else
            # for "final" payloads just print out
            println(io, tab^depth, "Payload(")
            depth += 1
            println(io, tab^depth, r.payload)        
            depth -= 1
            print(io, tab^depth, ")")   
        end    
    end
    println(io)

    depth -= 1
    print(io, tab^depth, ")")  
end

function show(io::IO, engine::Engine, depth::Integer = 0)
   # TODO: this function only handles SingleEngine not EngineCluster
   println(io, tab^depth, "Engine(")
   depth += 1
   println(io, tab^depth, 
               "thrust = ", 
               thrust(engine), ",")    
   println(io, tab^depth, 
               "Isp    = ", 
               Isp(engine), ",")
   println(io, tab^depth, 
               "mass   = ", 
               mass(engine))
   depth -= 1        
   print(io, tab^depth, ")")
end

function show(io::IO, tank::Tank, depth::Integer = 0)
   println(io, tab^depth, "Tank(")
   depth += 1
   println(io, tab^depth, 
               "dry_mass   = ", 
               tank.dry_mass, ",")
   println(io, tab^depth, 
               "propellant = ", 
               tank.propellant, ",")        
   println(io, tab^depth, 
               "total_mass = ", 
               tank.total_mass, ",")        
   depth -= 1
   print(io, tab^depth, ")")        
end

function show(io::IO, ship::SpaceVehicle)
     println(io, "SpaceVehicle(")
     show(io, ship.active_stage, 1)
     println(io)
     println(io, ")")
end

# Example
# julia> show(ship) 
# You don't actually need the show you can just type
# julia> ship
# SpaceVehicle(
#    Rocket(
#       Tank(
#          dry_mass   = 4000.0,
#          propellant = 107500.0,
#          total_mass = 111500.0,
#       ),
#       Engine(
#          thrust = 7.605e6,
#          Isp    = 282.0,
#          mass   = 4230.0
#       ),
#       Rocket(
#          Tank(
#             dry_mass   = 4000.0,
#             propellant = 107500.0,
#             total_mass = 111500.0,
#          ),
#          Engine(
#             thrust = 845000.0,
#             Isp    = 282.0,
#             mass   = 470.0
#          ),
#          Payload(
#             SpaceProbe(22000.0)
#          )
#       )
#    )
# )