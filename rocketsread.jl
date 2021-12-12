include("rocketparts.jl")

function load_engines(path::AbstractString)
    # since we have them we shoud use both the name and company as dictionary key
    rocket_engines = Dict{Tuple{String, String}, SingleEngine}()

    # As Engheim explains, leveraging the fact that open can take a function closure,
    # and then automatically close the file, belows is best way to open file, slurp it in,
    # and then have it automatically closed
    lines = open(readlines, path)
    for line in lines[2:end]
        parts = split(line, ',')
        name, company = parts[1:2]
        # we have to rename the variables, because they are defined as functions 
        # in the included file. Engheim is propbaly using a different version of SingleEngine
        basemass, basethrust, throttle, baseIsp = 
                  parse.(Float64, parts[3:end])
        # the multipliers are not used or defined anywhere so give errors (in 
        # function explanation Engheim leaves them out :))
        # engine = Engine(basethrust * thrust_multiplier,
        #                 baseIsp, 
        #                 basemass * mass_multiplier)
        engine = Engine(basethrust,
                        baseIsp, 
                        basemass)

        rocket_engines[(name,company)] = engine
    end

    rocket_engines
end

# Example
# 
# julia> include("rocketsread.jl")
# load_engines (generic function with 1 method)

# julia> load_engines("data/rocket-engines.csv")
# Dict{Tuple{String, String}, SingleEngine} with 8 entries:
#   ("LV-T30", "Kerbal")            => SingleEngine(205.16, 265.0, 1.25)
#   ("BE-3PM ", "Blue Origin")      => SingleEngine(490.0, 310.0, 0.25)
#   ("LV-T45 ", "Kerbal")           => SingleEngine(167.97, 250.0, 1.5)
#   ("48-7S", "Kerbal")             => SingleEngine(16.88, 270.0, 0.1)
#   ("Merlin 1D", "SpaceX")         => SingleEngine(845.0, 282.0, 0.47)
#   ("RD-180", "NPO Energomash")    => SingleEngine(3830.0, 311.0, 5.48)
#   ("Rutherford", "Rocket Lab")    => SingleEngine(18.0, 303.0, 0.035)
#   ("RS-25", "Aerojet Rocketdyne") => SingleEngine(1860.0, 366.0, 3.527)

