# # Chapter 2. Interval Arithmetic
# ## 2.4. Floating Point Interval Arithmetic
# ### 2.4.1. A ~~MATLAB~~ Julia Implementation of Interval Arithmetic

#-
using FastRounding
const SysFloat = Union{Float32, Float64} # same as FastRounding

#-
struct Interval{T<:SysFloat}
    lo::T
    hi::T
    function Interval(lo::T, hi::T) where T<:SysFloat
        lo <= hi ? new{T}(lo, hi) : throw(ArgumentError("The endpoints do not define an interval."))
    end
end

Interval(x::SysFloat) = Interval(x, x)

function Base.show(io::IO, a::Interval{T}) where T<:SysFloat
    print(io, "Interval{$(T)}(", a.lo, ", ", a.hi, ")") # TODO
end

#-
Interval(1.0, 2.0)

#-
Interval(1f0, 2f0)

#-
Interval(1.0)

#-
Interval(1.0, 1.0)

#-
## NG
## Interval(2.0, 1.0)

# Define sum of two intervals.

#- 
function Base.:+(a::Interval{T}, b::Interval{T}) where T<:SysFloat
    lo = add_round(a.lo, b.lo, RoundDown)
    hi = add_round(a.hi, b.hi, RoundUp)
    return Interval(lo, hi)
end

#-
Interval(0.1, 0.2) + Interval(0.3, 0.4)