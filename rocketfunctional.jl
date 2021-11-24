include("rocketparts.jl")

# this is dumb to do this way, since both parameters
# are required by the inner constructor
function Tank(;dry_mass::Number, total_mass::Number)
    Tank(dry_mass, total_mass)
end
# Example
# t = Tank(dry_mass = 10.0)
# ERROR: UndefKeywordError: keyword argument total_mass not assigned
# Stacktrace:
#  [1] top-level scope
#    @ REPL[2]:1

# julia> t = Tank(dry_mass = 10.0, total_mass = 20.0) 
# Tank(10.0, 20.0, 10.0)

# also only useful as an example. Earlier he used multiple dispatch to 
# allow for a default value
Rocket(;payload::Payload = nopayload, tank::Tank, engine::Engine) = Rocket(payload, tank, engine)

# As engheim notes we need to use collect, because the splat operator
# returns a tuple and the constructor requires an array of rockets
SpaceVehicle(rockets...) = SpaceVehicle(collect(rockets))

function Engine(;thrust::Number, Isp::Number, 
                 mass::Number=0, count::Integer=1)
    # add other checks engheim suggests
    if thrust < 1
        msg =  "thrust must be >= 0"
        throw(DomainError(thrust, msg))
    end
    if Isp < 1
        msg =  "Isp must be >= 0"
        throw(DomainError(Isp, msg))
    end
    if mass < 1
        msg =  "mass must be >= 0"
        throw(DomainError(mass, msg))
    end
    engine = Engine(thrust, Isp, mass)
    if count > 1
        EngineCluster(engine, count)
    elseif count < 1
        msg =  "number of rocket engines must be > 0"
        throw(DomainError(count, msg))
    else
        engine
    end
end
