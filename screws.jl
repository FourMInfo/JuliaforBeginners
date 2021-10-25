@enum HeadType rounded flat headless tslot
@enum DriveStyle hex phillips slotted torx
@enum Material aluminium brass steel plastic wood

struct Screw
    prodnum::Int
    headtype::HeadType
    drivestyle::DriveStyle
    material::Material
end

#list enum instances
instances(HeadType)
instances(DriveStyle)
instances(Material)

# build randdom inventory
function make_screw(prodnum)
    headtype = rand(instances(HeadType))
    drivestyle = rand(instances(DriveStyle))
    material = rand(instances(Material))
    
    Screw(prodnum, headtype, drivestyle, material)
end

screws = map(make_screw, 100:150)

# search functions with multiple dispatch and closures
function isround(screw)
    screw.headtype == rounded
end

function isround(screw, material)
    screw.headtype == rounded  &&
    screw.material == material
end

function isnonplastic(screw)
    screw.material != plastic
end

function issteel(screw)
    screw.material == steel
end

function ishex(screw)
    screw.drivestyle == hex
end

function isnonplastic(screw, headtype)
    screw.material != plastic &&
    screw.headtype == headtype
end

# closures - see below how to use inside filter instead of pre-defining
isroundaluminium = screw -> isround(screw, aluminium)
isroundsteel = screw -> isround(screw, steel)
isroundbrass = screw -> isround(screw, brass)
isroundplastic = screw -> isround(screw, plastic)
isroundwood = screw -> isround(screw, wood)

isnonplasticrounded = screw -> isnonplastic(screw, rounded)
isnonplasticflat = screw -> isnonplastic(screw, flat)
isnonplasticheadless = screw -> isnonplastic(screw, headless)
isnonplastictslot = screw -> isnonplastic(screw, tslot)


# queries - with closure either predefined or inside the filter
#filter(isround, screws)
#filter(isroundaluminium, screws)
#filter(screw -> isround(screw, aluminium), screws)
#filter(isroundsteel, screws)
#filter(isroundbrass, screws)
#filter(isroundplastic, screws)
#filter(isroundwood, screws)
#filter(isnonplastic, screws)
#filter(isnonplasticrounded, screws)
#filter(screw -> isnonplastic(screw, rounded), screws)
#filter(isnonplasticflat, screws)
#filter(isnonplasticheadless, screws)
#filter(isnonplastictslot, screws)

# queries with sets
#steel_screws = Set(filter(issteel, screws))
#hex_screws = Set(filter(ishex, screws))     

# Dictionary solution
screwdict = Dict(screw.prodnum => screw for screw in screws)
#screwdict[137]

prodnums = keys(screwdict)

function isbrass(prodnum)
    screw = screwdict[prodnum]
    screw.material == brass
end
brass_screws = Set(filter(isbrass, prodnums))

# alternate function to use with closure
function ismaterial(prodnum, material)
    screw = screwdict[prodnum]
    screw.material == material
end

function istorx(prodnum)
    screw = screwdict[prodnum]
    screw.drivestyle == torx
end

function isdrivestyle(prodnum, drivestyle)
    screw = screwdict[prodnum]
    screw.drivestyle == drivestyle
end

brass_screws = Set(filter(isbrass, prodnums))
steel_screws = Set(filter(prodnum ->ismaterial(prodnum,steel), prodnums))
torx_screws = Set(filter(istorx, prodnums))
hex_screws = Set(filter(prodnum ->isdrivestyle(prodnum,hex), prodnums))

# Set queries
#brass_screws ∩ torx_screws
#steel_screws ∩ hex_screws
#brass_screws ∩ hex_screws
#steel_screws ∩ torx_screws
#[screwdict[pn] for pn in steel_screws ∩ torx_screws]
