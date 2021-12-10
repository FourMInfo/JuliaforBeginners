# although you can create and manage your own *long-term* development packages
# the way Engheim suggests i.e. using your own directory, the Julia documentation
# suggests a different and better solution as a best practice:
# https://docs.julialang.org/en/v1/manual/workflow-tips/#Revise-based-workflows
# In your repl:
# pkg > add PkgTemplates
# julia> using PkgTemplates
# if your Github user is defined in git global config, you don't have to add the parameter.
# julia> t = Template(user=",your Github username>")
# julia> t("Foobar")
# As the documentation indicates this stores your project in a directory ~/.julia/dev.
# Engheim points out his reason for preferring his own directory:
# "Should your Julia installation get messed up and you want to start from scratch, 
# it is tempting to erase the whole ~/.julia, but this can have catastrophic results 
# if you got the habit of putting your personal projects in there.”
# However if you are in the habit of religiously pushing code to Github et al (as you should) 
# there is no reason this should be catastrophic. Just check out the repository again. 
# Another concern might be a disk size limit on the home directory. Whatever the case, you can always symlink 
# ~/.julia/dev to another directory if you can't/don't want to store your code in your home directory.
# Or you can move your generated package directory and symlink it inside dev. Finally you can create 
# a non hidden symlink to the dev directory, to easily access your packages from the Finder et al.
# NB: Engheim does discuss PkgTemplates later in the context of publishing on JuliaHub
# but it seems simple enough and useful for all projects.
# The package template does lots of heavy lifting for you, including e.g.
# creating the git repository for the package and much more (cf. the Foobarfolder in this
# repository, although for obvious reasons didnt add the .git directory)
# see PkgTemplate doco for more info:
# https://invenia.github.io/PkgTemplates.jl/stable/
# Also, it seems that adding directories to the LOAD_PATH env variable
# is not a best practice. So how do you get the Julia REPL to recognize your
# packages in the dev directory? Simple:
# (@v1.7) pkg> dev Foobar
# When you have questions you should definitely checkout Julia's friendly
# discourse. That's how I found out the above:
# https://discourse.julialang.org/t/best-practice-for-generating-long-term-packages/72853
# You can learn all about dev in the Pk doco. The whole document is worth reading:
# https://pkgdocs.julialang.org/v1/managing-packages/#developing
# One last point. Engheim seems to imply that if you add your directory to the
# LOAD_PATH, then when you do:
# (@v1.7) pkg> activate "Foobar"
# it will somehow know you are taling about *your* Foobar. My testing indicates
# that generates a Foobar package inside your current directory. Hence what
# you actually need to do is provide the full path (no bash shortcuts allowed,
# even though the response uses one!):
# (@v1.7) pkg> activate "/Users/aronet/.julia/dev/Foobar"
#  Activating project at `~/.julia/dev/Foobar`
# I mounted the ~/.julia/dev/Foobar directory into this Github repository using
# bindfs. First install macfuse as a brew cask. Then download source of bindfs
# and build and install using gmake (brew version of make). Then mkdir the mount
# directory (in this case "Foobar") and then run
# bindfs <fully qualified source directory> <fully qualified target directory>

module Foobar

# Write your package code here.
export greet

using Dates

greet() = print("Hello Earth, it's a beautiful ", dayname(today()))


end
# Revise example
# add "Revise" to current Julia version env. Fet there by running activate unmodified
# (JuliaforBeginners) pkg> activate
#   Activating project at `~/.julia/environments/v1.7`

# (@v1.7) pkg> add Revise
#     Updating registry at `~/.julia/registries/General.toml`
#    Resolving package versions...
#    Installed LoweredCodeUtils ─ v2.1.2
#    Installed CodeTracking ───── v1.0.6
#    Installed JuliaInterpreter ─ v0.8.21
#    Installed Revise ─────────── v3.2.0
#     Updating `~/.julia/environments/v1.7/Project.toml`
#   [295af30f] + Revise v3.2.0
#     Updating `~/.julia/environments/v1.7/Manifest.toml`
#   [da1fd8a2] + CodeTracking v1.0.6
#   [aa1ae85d] + JuliaInterpreter v0.8.21
#   [6f1432cf] + LoweredCodeUtils v2.1.2
#   [ae029012] + Requires v1.1.3
#   [295af30f] + Revise v3.2.0
#   [7b1f6079] + FileWatching
# Precompiling project...
#   6 dependencies successfully precompiled in 9 seconds (19 already precompiled)

# (@v1.7) pkg> activate "/Users/aronet/.julia/dev/Foobar"
#   Activating project at `~/.julia/dev/Foobar`

# julia> using Revise

# julia> using Foobar

# julia> greet()
# Hello World, it's a beautiful Friday
# modify the code and rerun function
# julia> greet()
# Hello Earth, it's a beautiful Friday