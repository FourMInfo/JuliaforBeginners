# although you can create and manage your own *long-term*
# development packages the way Engheim suggests, the Julia documentation
# suggests a different and better solution as a best practice:
# https://docs.julialang.org/en/v1/manual/workflow-tips/#Revise-based-workflows
# In your repl:
# pkg > add PkgTemplates
# julia> using PkgTemplates
# julia> t = Template(user=",your Github username>")
# julia> t("Foobar")
# As the documentation indicates this stores your project in a directory
# ~/.julia/dev. You can always symlink that directory somewhere else if you
# can't/don't want to store your code in your home directory. Or you can
# move your generated package directory and symlink it inside dev.
# The package template does lots of heavy lifting for you, including e.g.
# creating the git repository for the package and much more (see commits
# although for obvious reasons didnt add the .git directory)
# Also, it seems that adding directories to the LOAD_PATH env variable
# is not a best practice. So how do you get the Julia REPL to recognize your
# packages in the dev directory? Simple:
# (@v1.7) pkg> dev Foobar
# When you have questions you should definitely checkout Julia's friendly
# discourse. That's how I found out the above:
# https://discourse.julialang.org/t/best-practice-for-generating-long-term-packages/72853
# One last point. Engheim seems to imply that if you add your directory to the
# LOAD_PATH, then when you do:
# (@v1.7) pkg> activate "Foobar"
# it will somehow know you are taling about *your* Foobar. My testing indicates
# that generates a Foobar package inside your current directory. Hence what
# you actually need to do is provide the full path (no bash shortcuts allowed,
# even though the response uses one!):
# (@v1.7) pkg> activate "/Users/aronet/.julia/dev/Foobar"
#  Activating project at `~/.julia/dev/Foobar`

module Foobar

# Write your package code here.
export greet

using Dates

greet() = print("Hello World, it's a beautiful ", dayname(today()))


end
