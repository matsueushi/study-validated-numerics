# # Chapter 2. Interval Arithmetic
# ## 2.4. Floating Point Interval Arithmetic
# ### 2.4.1. A ~~MATLAB~~ Julia Implementation of Interval Arithmetic

#-
using FastRounding
using Printf

const SysFloat = Union{Float32, Float64} # same as FastRounding

#-
struct Interval{T<:SysFloat}
    lo::T
    hi::T
    function Interval(lo::T, hi::T) where T<:SysFloat
        lo <= hi ? new{T}(lo, hi) : throw(ArgumentError("The endpoints do not define an interval."))
    end
end

Interval(a::Real, b::Real) = Interval(Float64(a, RoundDown), Float64(b, RoundUp))
Interval(x::Real) = Interval(x, x)

function Base.show(io::IO, a::Interval{T}) where T<:SysFloat
    print(io, "Interval{$(T)}(", @sprintf("%17.17f", a.lo), ", ", @sprintf("%17.17f", a.hi), ")") # TODO
end

#-
a = Interval(3, 4)

#-
b = Interval(2, 5)

#-
c = Interval(1)

#-
Interval(3.0f0, 4.0f0)

#-
Interval(1//10)

#-
Interval(π)

#-
## NG
## Interval(2.0, 1.0)

# Define sum of two intervals.

#- 
function Base.:+(a::Interval, b::Interval)
    lo = add_round(a.lo, b.lo, RoundDown)
    hi = add_round(a.hi, b.hi, RoundUp)
    return Interval(lo, hi)
end

Base.:+(a::Real, b::Interval) = Interval(a) + b
Base.:+(a::Interval, b::Real) = a + Interval(b)

#-
Interval(1, 2) + Interval(3, 4)

#-
Interval(1, 2) + Interval(3, 3)

#-
Interval(1, 2) + 3

#-
3 + Interval(1, 2)

# -, *, /

#-
function Base.:-(a::Interval, b::Interval)
    lo = sub_round(a.lo, b.hi, RoundDown)
    hi = sub_round(a.hi, b.lo, RoundUp)
    return Interval(lo, hi)
end

Base.:-(a::Real, b::Interval) = Interval(a) - b
Base.:-(a::Interval, b::Real) = a - Interval(b)


function Base.:*(a::Interval, b::Interval)
    lo = min(mul_round(a.lo, b.lo, RoundDown),
             mul_round(a.lo, b.hi, RoundDown),
             mul_round(a.hi, b.lo, RoundDown),
             mul_round(a.hi, b.hi, RoundDown))
    hi = max(mul_round(a.lo, b.lo, RoundUp),
             mul_round(a.lo, b.hi, RoundUp),
             mul_round(a.hi, b.lo, RoundUp),
             mul_round(a.hi, b.hi, RoundUp))
    return Interval(lo, hi)
end

Base.:*(a::Real, b::Interval) = Interval(a) * b
Base.:*(a::Interval, b::Real) = a * Interval(b)


function Base.:/(a::Interval, b::Interval)
    if (b.lo <= 0.0) & (0.0 <= b.hi)
        throw(ArgumentError("Denominator straddles zero."))
    end

    lo = min(div_round(a.lo, b.lo, RoundDown),
             div_round(a.lo, b.hi, RoundDown),
             div_round(a.hi, b.lo, RoundDown),
             div_round(a.hi, b.hi, RoundDown))
    hi = max(div_round(a.lo, b.lo, RoundUp),
             div_round(a.lo, b.hi, RoundUp),
             div_round(a.hi, b.lo, RoundUp),
             div_round(a.hi, b.hi, RoundUp))
    return Interval(lo, hi)
end

Base.:/(a::Real, b::Interval) = Interval(a) / b
Base.:/(a::Interval, b::Real) = a / Interval(b)

#-
a + b

#-
a - b

#-
a * b

#-
a / b

#-
Interval(1/10)

#-
Interval(1)/10

#-
Interval(1//10)

#-
c = Interval(0.25, 0.50)

#-
a * (b + c)

#-
a * b + a * c