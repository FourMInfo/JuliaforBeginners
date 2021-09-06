# bring in the previous definitions
include("rocketparts.jl")
# Space Vehicle Collection
struct NoPayload <: Payload
end

mass(payload::NoPayload) = 0.0

Rocket(tank::Tank, engine::Engine) = Rocket(NoPayload(), tank, engine)

mutable struct SpaceVehicle
    active_stage::Payload
end

# Define empty case
SpaceVehicle() = SpaceVehicle(NoPayload())

# Cumbersome first attempt (code in book makes no sense)
# function stage_separate!(ship::SpaceVehicle)
#    stage = ship.active_stage
#    if stage isa Rocket
#       ship.active_stage = stage.payload
#       # these original two lines actually make no sense. 
#       #stage.payload = NoPayload()
#       #payload = NoPayload()
#       # After the stage separate what should be returned is the payload. 
#        # For the example below we return as a ship so we can iterate
#       SpaceVehicle(stage.payload)
#    else
#       nothing
#    end
# end

# Example
# uncomment to see how first version works
# merlin = Engine(845e3, 282, 470)
# tank = Tank(4e3, 111.5e3)
# r2 = Rocket(SpaceProbe(22e3), tank, merlin)
# r1 = Rocket(r2, tank, EngineCluster(merlin, 9))
# ship = SpaceVehicle(r1)

# This is the result you want to see after modification of Engheim's code
# julia> include("rocketcoll.jl")
# SpaceVehicle(Rocket(Rocket(SpaceProbe(22000.0), Tank(4000.0, 111500.0, 107500.0), SingleEngine(845000.0, 282.0, 470.0)), Tank(4000.0, 111500.0, 107500.0), EngineCluster(SingleEngine(845000.0, 282.0, 470.0), 9)))

# julia> post = stage_separate!(ship)
# SpaceVehicle(Rocket(SpaceProbe(22000.0), Tank(4000.0, 111500.0, 107500.0), SingleEngine(845000.0, 282.0, 470.0)))

# julia> postpost = stage_separate!(post)
# SpaceVehicle(SpaceProbe(22000.0))

# julia> postpostpost = stage_separate!(postpost)

# julia> 

# Second attempt to work with push and pop
function stage_separate!(ship::SpaceVehicle)
   stage = ship.active_stage
   if stage isa Rocket
      ship.active_stage = stage.payload
      stage.payload
   else
      nothing
   end
end

import Base: popfirst!, pushfirst!

popfirst!(ship::SpaceVehicle) = stage_separate!(ship)

function pushfirst!(ship::SpaceVehicle, rockets...)
    for r in reverse(rockets)
      # the assumption is that only the last rocket can and must have a payload
      # so for all other rockets, the payload becomes the next stage rocket
      # you need the if condition so that the final payload isn't erased (as it is in the book's
      # code - see discussion in example below)
      if r.payload isa NoPayload
        r.payload = ship.active_stage
      end
      ship.active_stage = r
    end
    ship
end

function SpaceVehicle(rockets::Array{Rocket})
    ship = SpaceVehicle()
    pushfirst!(ship, rockets...)
    ship
end

# Example
# note the results in the book make no sense because you lose the SpaceProbe payload
# Notice result on p266 does not match result on p262. 
# The inner rocket should have spaceprobe as load, but Engheim's code erases it!
# to fix this we add the if statement in the code above 
merlin = Engine(845e3, 282, 470)
tank = Tank(4e3, 111.5e3)
r1 = Rocket(tank, EngineCluster(merlin, 9))
r2 = Rocket(SpaceProbe(22e3), tank, merlin)
ship = SpaceVehicle([r1,r2])

# import iterate interface and add required methods
import Base: iterate

# define single parameter methods
iterate(payload::Payload) = payload, nothing
iterate(r::Rocket) = r, r.payload
iterate(ship::SpaceVehicle) = iterate(ship.active_stage)
# define tuple method
function iterate(::Union{Rocket, SpaceVehicle}, state)
    if state == nothing || state isa NoPayload
        nothing
    else
        iterate(state)
    end
end

# test iteration
for r in ship
  println(mass(r))
end

# optional methods
import Base: IteratorSize

IteratorSize(::SpaceVehicle) = Base.SizeUnknown()
IteratorSize(::Rocket) = Base.SizeUnknown()
IteratorSize(::Payload) = Base.SizeUnknown()

# test map
map(mass, ship)

# set element type for Collection
# import is critical to get desired result
import Base: eltype

eltype(::Type{SpaceVehicle}) = Payload
eltype(::Type{Rocket}) = Payload
#eltype(::Type{Payload}) = Payload

collect(ship)