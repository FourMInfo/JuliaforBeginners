# First build the animals directory - mistake included to show how easy to fix
# julia> mkpath("data/animals/invertebrates/arthropods/crustaceans")
# "data/animals/invertebrates/arthropods/crustaceans"

# julia> mkpath("data/animals/invertebrates/arthropods/insects")
# "data/animals/invertebrates/arthropods/insects"

# julia> mkpath("data/animals/invertebrates/flatworms")
# "data/animals/invertebrates/flatworms"

# julia> mkpath("data/animals/invertebrates/molluscs")
# "data/animals/invertebrates/molluscs"

# julia> mkpath("data/animals/invertebrates/amphibians")
# "data/animals/invertebrates/amphibians"

# julia> rm("data/animals/invertebrates/amphibians")

# julia> mkpath("data/animals/vertebrates/amphibians")
# "data/animals/vertebrates/amphibians"

# julia> mkpath("data/animals/vertebrates/birds")
# "data/animals/vertebrates/birds"

# julia> mkpath("data/animals/vertebrates/fish")
# "data/animals/vertebrates/fish"

# julia> mkpath("data/animals/vertebrates/mammals")
# "data/animals/vertebrates/mammals"

# julia> for (root, dirs, files) in walkdir(an)
#            println("Directories in $root")
#            for dir in dirs
#                println(joinpath(root, dir)) # path to directories
#            end
#            println("Files in $root")
#            for file in files
#                println(joinpath(root, file)) # path to files
#            end
#        end
# Directories in data/animals
# data/animals/invertebrates
# data/animals/vertebrates
# Files in data/animals
# Directories in data/animals/invertebrates
# data/animals/invertebrates/arthropods
# data/animals/invertebrates/flatworms
# data/animals/invertebrates/molluscs
# Files in data/animals/invertebrates
# Directories in data/animals/invertebrates/arthropods
# data/animals/invertebrates/arthropods/crustaceans
# data/animals/invertebrates/arthropods/insects
# Files in data/animals/invertebrates/arthropods
# Directories in data/animals/invertebrates/arthropods/crustaceans
# Files in data/animals/invertebrates/arthropods/crustaceans
# Directories in data/animals/invertebrates/arthropods/insects
# Files in data/animals/invertebrates/arthropods/insects
# Directories in data/animals/invertebrates/flatworms
# Files in data/animals/invertebrates/flatworms
# Directories in data/animals/invertebrates/molluscs
# Files in data/animals/invertebrates/molluscs
# Directories in data/animals/vertebrates
# data/animals/vertebrates/amphibians
# data/animals/vertebrates/birds
# data/animals/vertebrates/fish
# data/animals/vertebrates/mammals
# Files in data/animals/vertebrates
# Directories in data/animals/vertebrates/amphibians
# Files in data/animals/vertebrates/amphibians
# Directories in data/animals/vertebrates/birds
# Files in data/animals/vertebrates/birds
# Directories in data/animals/vertebrates/fish
# Files in data/animals/vertebrates/fish
# Directories in data/animals/vertebrates/mammals
# Files in data/animals/vertebrates/mammals

# Now create the file hierarchy
# julia> ver = "data/animals/vertebrates"
# "data/animals/vertebrates"

# julia> cd(joinpath(ver,"amphibians")) do
#          foreach(touch, ["frog", "salamander"])
#        end

# julia> cd(joinpath(ver,"birds")) do
#          foreach(touch, ["crow", "mockingjay","seagull"])
#        end

# julia> cd(joinpath(ver,"mammals")) do
#          foreach(touch, ["cow", "human"])
#        end

# julia> for (root, dirs, files) in walkdir(an)
#            println("Directories in $root")
#            for dir in dirs
#                println(joinpath(root, dir)) # path to directories
#            end
#            println("Files in $root")
#            for file in files
#                println(joinpath(root, file)) # path to files
#            end
#        end
# Directories in data/animals
# data/animals/invertebrates
# data/animals/vertebrates
# Files in data/animals
# Directories in data/animals/invertebrates
# data/animals/invertebrates/arthropods
# data/animals/invertebrates/flatworms
# data/animals/invertebrates/molluscs
# Files in data/animals/invertebrates
# Directories in data/animals/invertebrates/arthropods
# data/animals/invertebrates/arthropods/crustaceans
# data/animals/invertebrates/arthropods/insects
# Files in data/animals/invertebrates/arthropods
# Directories in data/animals/invertebrates/arthropods/crustaceans
# Files in data/animals/invertebrates/arthropods/crustaceans
# Directories in data/animals/invertebrates/arthropods/insects
# Files in data/animals/invertebrates/arthropods/insects
# Directories in data/animals/invertebrates/flatworms
# Files in data/animals/invertebrates/flatworms
# Directories in data/animals/invertebrates/molluscs
# Files in data/animals/invertebrates/molluscs
# Directories in data/animals/vertebrates
# data/animals/vertebrates/amphibians
# data/animals/vertebrates/birds
# data/animals/vertebrates/fish
# data/animals/vertebrates/mammals
# Files in data/animals/vertebrates
# Directories in data/animals/vertebrates/amphibians
# Files in data/animals/vertebrates/amphibians
# data/animals/vertebrates/amphibians/frog
# data/animals/vertebrates/amphibians/salamander
# Directories in data/animals/vertebrates/birds
# Files in data/animals/vertebrates/birds
# data/animals/vertebrates/birds/crow
# data/animals/vertebrates/birds/mockingjay
# data/animals/vertebrates/birds/seagull
# Directories in data/animals/vertebrates/fish
# Files in data/animals/vertebrates/fish
# Directories in data/animals/vertebrates/mammals
# Files in data/animals/vertebrates/mammals
# data/animals/vertebrates/mammals/cow
# data/animals/vertebrates/mammals/human

# It seems Engheim implements visit files so as not to get into the deatails of walkdir
# however walkdir serves this exect purpose and can do the same ans so much more
# function visitfiles(fn, root::AbstractString)
#     if isfile(root)
#         fn(root)
#         return
#     end
    
#     cd(root) do
#         for file in readdir()
#             visitfiles(fn, file)
#         end
#     end
# end

# Example

# julia> visitfiles(an) do file
#     println(joinpath(pwd(), file))
# end
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/amphibians/frog
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/amphibians/salamander
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/birds/crow
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/birds/mockingjay
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/birds/seagull
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/mammals/cow
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/mammals/human

# julia> for (root, dirs, files) in walkdir(an)
#            for file in files
#                println(joinpath(pwd(), joinpath(root,file))) # path to files
#            end
#        end
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/amphibians/frog
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/amphibians/salamander
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/birds/crow
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/birds/mockingjay
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/birds/seagull
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/mammals/cow
# /Users/aronet/Code/FourM/Study/Julia/JuliaforBeginners/data/animals/vertebrates/mammals/human
function replace_animal(animal::AbstractString)
    rm(animal)
    mkdir(animal)
    cd(animal) do
        foreach(touch, ["description.txt", "looks.jpg"])
    end
end

# Example
# julia> for (root, dirs, files) in walkdir(an)
#            for file in files
#                replace_animal(joinpath(pwd(), joinpath(root,file)))
#            end
#        end

# julia> for (root, dirs, files) in walkdir(an)
#            println("Directories in $root")
#            for dir in dirs
#                println(joinpath(root, dir)) # path to directories
#            end
#            println("Files in $root")
#            for file in files
#                println(joinpath(root, file)) # path to files
#            end
#        end
# Directories in data/animals
# data/animals/invertebrates
# data/animals/vertebrates
# Files in data/animals
# Directories in data/animals/invertebrates
# data/animals/invertebrates/arthropods
# data/animals/invertebrates/flatworms
# data/animals/invertebrates/molluscs
# Files in data/animals/invertebrates
# Directories in data/animals/invertebrates/arthropods
# data/animals/invertebrates/arthropods/crustaceans
# data/animals/invertebrates/arthropods/insects
# Files in data/animals/invertebrates/arthropods
# Directories in data/animals/invertebrates/arthropods/crustaceans
# Files in data/animals/invertebrates/arthropods/crustaceans
# Directories in data/animals/invertebrates/arthropods/insects
# Files in data/animals/invertebrates/arthropods/insects
# Directories in data/animals/invertebrates/flatworms
# Files in data/animals/invertebrates/flatworms
# Directories in data/animals/invertebrates/molluscs
# Files in data/animals/invertebrates/molluscs
# Directories in data/animals/vertebrates
# data/animals/vertebrates/amphibians
# data/animals/vertebrates/birds
# data/animals/vertebrates/fish
# data/animals/vertebrates/mammals
# Files in data/animals/vertebrates
# Directories in data/animals/vertebrates/amphibians
# data/animals/vertebrates/amphibians/frog
# data/animals/vertebrates/amphibians/salamander
# Files in data/animals/vertebrates/amphibians
# Directories in data/animals/vertebrates/amphibians/frog
# Files in data/animals/vertebrates/amphibians/frog
# data/animals/vertebrates/amphibians/frog/description.txt
# data/animals/vertebrates/amphibians/frog/looks.jpg
# Directories in data/animals/vertebrates/amphibians/salamander
# Files in data/animals/vertebrates/amphibians/salamander
# data/animals/vertebrates/amphibians/salamander/description.txt
# data/animals/vertebrates/amphibians/salamander/looks.jpg
# Directories in data/animals/vertebrates/birds
# data/animals/vertebrates/birds/crow
# data/animals/vertebrates/birds/mockingjay
# data/animals/vertebrates/birds/seagull
# Files in data/animals/vertebrates/birds
# Directories in data/animals/vertebrates/birds/crow
# Files in data/animals/vertebrates/birds/crow
# data/animals/vertebrates/birds/crow/description.txt
# data/animals/vertebrates/birds/crow/looks.jpg
# Directories in data/animals/vertebrates/birds/mockingjay
# Files in data/animals/vertebrates/birds/mockingjay
# data/animals/vertebrates/birds/mockingjay/description.txt
# data/animals/vertebrates/birds/mockingjay/looks.jpg
# Directories in data/animals/vertebrates/birds/seagull
# Files in data/animals/vertebrates/birds/seagull
# data/animals/vertebrates/birds/seagull/description.txt
# data/animals/vertebrates/birds/seagull/looks.jpg
# Directories in data/animals/vertebrates/fish
# Files in data/animals/vertebrates/fish
# Directories in data/animals/vertebrates/mammals
# data/animals/vertebrates/mammals/cow
# data/animals/vertebrates/mammals/human
# Files in data/animals/vertebrates/mammals
# Directories in data/animals/vertebrates/mammals/cow
# Files in data/animals/vertebrates/mammals/cow
# data/animals/vertebrates/mammals/cow/description.txt
# data/animals/vertebrates/mammals/cow/looks.jpg
# Directories in data/animals/vertebrates/mammals/human
# Files in data/animals/vertebrates/mammals/human
# data/animals/vertebrates/mammals/human/description.txt
data/animals/vertebrates/mammals/human/looks.jpg