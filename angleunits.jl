abstract type Angle end

struct Radian <: Angle
    radians::Float64
end

struct DMS <: Angle
    seconds::Int
end

begin
    Degree(degrees::Integer) = Minute(degrees * 60)
    Degree(deg::Integer, min::Integer) = Degree(deg) + Minute(min)
    Degree(deg::Integer, min::Integer, secs::Integer) = Degree(deg, min) + Second(secs)

    function Minute(minutes::Integer)
        DMS(minutes * 60)
    end

    function Second(seconds::Integer)
        DMS(seconds)
    end 

    import Base: -, +, show, convert, *, /, promote_rule
    +(Θ::DMS, α::DMS) = DMS(Θ.seconds + α.seconds)      
    -(Θ::DMS, α::DMS) = DMS(Θ.seconds - α.seconds)

    +(Θ::Radian, α::Radian) = Radian(Θ.radians + α.radians)
    -(Θ::Radian, α::Radian) = Radian(Θ.radians - α.radians)

    function degrees(dms::DMS)
        minutes = dms.seconds ÷ 60
        minutes ÷ 60
    end

    function minutes(dms::DMS)
        minutes = dms.seconds ÷ 60
        minutes % 60
    end

    seconds(dms::DMS) = dms.seconds % 60

    function show(io::IO, dms::DMS)
    print(io, degrees(dms), "° ", minutes(dms), "' ", seconds(dms), "''")
    end

    function show(io::IO, rad::Radian)
    print(io, rad.radians, "rad")
    end

    # convert constructors
    Radian(dms::DMS) = Radian(deg2rad(dms.seconds/3600))
    DMS(rad::Radian) = DMS(floor(Int, rad2deg(rad.radians) * 3600))

    convert(::Type{Radian},  dms::DMS)    = Radian(dms)
    convert(::Type{DMS},     rad::Radian) = DMS(rad)

    sin(rad::Radian) = Base.sin(rad.radians)
    cos(rad::Radian) = Base.cos(rad.radians)

    sin(dms::DMS) = sin(Radian(dms))
    cos(dms::DMS) = cos(Radian(dms))

    *(coeff::Number, dms::DMS) = DMS(coeff * dms.seconds)
    *(dms::DMS, coeff::Number) = coeff * dms
    /(dms::DMS, denom::Number) = DMS(dms.seconds/denom)

    *(coeff::Number, rad::Radian) = Radian(coeff * rad.radians)
    *(rad::Radian, coeff::Number) = coeff * rad
    /(rad::Radian, denom::Number) = Radian(rad.radians/denom)

    const ° = Degree(1)
    const rad = Radian(1)

    Base.promote_rule(::Type{Radian}, ::Type{DMS}) = Radian
end
# Examples
# α = Degree(90, 30, 45)
# β = α + Degree(89, 29, 15)
# sin(Degree(90))
# sin(Radian(π/2))
# sin(90°)
# sin(1.5rad)

# Problem
# While this works:
# +(promote(90°,3.14rad/2)...)
# 3.140796326794897rad
# Doing this
# 90°+ 3.14rad/2
# gives this error
# ERROR: MethodError: no method matching +(::DMS, ::Radian)
# Closest candidates are:
#   +(::Any, ::Any, ::Any, ::Any...) at operators.jl:560
#   +(::DMS, ::DMS) at REPL[10]:1
#   +(::Radian, ::Radian) at REPL[12]:1
# Stacktrace:
#  [1] top-level scope
#    @ REPL[38]:1
