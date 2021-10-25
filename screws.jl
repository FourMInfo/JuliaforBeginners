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

function isnonplastic(screw, headtype)
    screw.material != plastic &&
    screw.headtype == headtype
end

# closures
isroundaluminium = screw -> isround(screw, aluminium)
isroundsteel = screw -> isround(screw, steel)
isroundbrass = screw -> isround(screw, brass)
isroundplastic = screw -> isround(screw, plastic)
isroundwood = screw -> isround(screw, wood)

isnonplasticrounded = screw -> isnonplastic(screw, rounded)
isnonplasticflat = screw -> isnonplastic(screw, flat)
isnonplasticheadless = screw -> isnonplastic(screw, headless)
isnonplastictslot = screw -> isnonplastic(screw, tslot)


# queries - closure either predefined or inside the filter
#filter(isround, screws)
#filter(isroundaluminium, screws)
#filter(screw -> isround(screw, aluminium), screws)
#filter(isroundsteel, screws)
#filter(isroundbrass, screws)
#filter(isroundplastic, screws)
#filter(isroundwood, screws)
#filter(isnonplastic, screws)
#filter(isnonplasticrounded, screws)
#filter(isnonplasticflat, screws)
#filter(isnonplasticheadless, screws)
#filter(isnonplastictslot, screws)

