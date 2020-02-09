using Literate

for x in ["src/ch1-computer-arithmetic.jl"]
    # Literate.markdown(x, "./markdown"; documenter=true)
    Literate.notebook(x, "./notebook"; documenter=true)
end