# Original: src/notebooks.jl of https://github.com/MikeInnes/diff-zoo
# Copyright (c) 2019 Mike J Innes
# Released under the MIT license
# https://opensource.org/licenses/mit-license.php

root = joinpath(@__DIR__, "..")
using Pkg; Pkg.activate(root)
using Literate

src = joinpath(root, "src")
out = joinpath(root, "notebook")

for x in ["ch1-computer-arithmetic.jl"]
    # Literate.markdown(x, "./markdown"; documenter=true)
    Literate.notebook(joinpath(src, x), out; documenter=true)
end