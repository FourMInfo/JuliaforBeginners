using Logging

import Logging: handle_message, shouldlog, min_enabled_level

struct TrivialLogger <: AbstractLogger 
    io::IO
    min_level::LogLevel
end

function TrivialLogger(
    io::IO=stderr, 
    level=Logging.Info)
    
    TrivialLogger(io, level)
end

function min_enabled_level(log::TrivialLogger)
    log.min_level
end

function shouldlog(
    logger::TrivialLogger, 
    level, _module, group, id)
    true
end

function handle_message(
    logger::TrivialLogger,
    level::LogLevel,
    message::AbstractString,
    _module::Module,
    group::Symbol,
    id::Symbol,
    file::AbstractString, 
    line; kwargs...)

    io = logger.io
    println(io, message)
    
    for (key, value) in kwargs
        println(io, "   ", key, " = ", value)
    end
end

# Trivial example
# julia> x = 12
# 12

# julia> msg = "world"
# "world"

# julia> open("log.txt", "w+") do io
#     logger = TrivialLogger(io, Logging.Info)
#     with_logger(logger) do
#         @info "hello" msg x
#     end
#  end

# julia> readlines("log.txt")
# 3-element Vector{String}:
# "hello"
# "   msg = world"
# "   x = 12"
