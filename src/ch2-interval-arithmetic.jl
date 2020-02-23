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

Interval(lo::Real, hi::Real) = Interval(Float64(lo, RoundDown), Float64(hi, RoundUp))
Interval(x::Real) = Interval(x, x)

function Base.show(io::IO, a::Interval{T}) where T<:SysFloat
    print(io, "Interval{$(T)}(", @sprintf("%17.17f", a.lo), ", ", @sprintf("%17.17f", a.hi), ")")
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
    Interval(lo, hi)
end

Base.:+(a::Real, b::Interval) = Interval(a) + b
Base.:+(a::Interval, b::Real) = a + Interval(b)

Base.:+(a::Interval) = a

#-
Interval(1, 2) + Interval(3, 4)

#-
Interval(1, 2) + Interval(3, 3)

#-
Interval(1, 2) + 3

#-
3 + Interval(1, 2)

# Define other unary and binary functions

#-
function Base.:-(a::Interval, b::Interval)
    lo = sub_round(a.lo, b.hi, RoundDown)
    hi = sub_round(a.hi, b.lo, RoundUp)
    Interval(lo, hi)
end

Base.:-(a::Real, b::Interval) = Interval(a) - b
Base.:-(a::Interval, b::Real) = a - Interval(b)

Base.:-(a::Interval) = 0 - a


function Base.:*(a::Interval, b::Interval)
    lo = min(mul_round(a.lo, b.lo, RoundDown),
             mul_round(a.lo, b.hi, RoundDown),
             mul_round(a.hi, b.lo, RoundDown),
             mul_round(a.hi, b.hi, RoundDown))
    hi = max(mul_round(a.lo, b.lo, RoundUp),
             mul_round(a.lo, b.hi, RoundUp),
             mul_round(a.hi, b.lo, RoundUp),
             mul_round(a.hi, b.hi, RoundUp))
    Interval(lo, hi)
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
    Interval(lo, hi)
end

Base.:/(a::Real, b::Interval) = Interval(a) / b
Base.:/(a::Interval, b::Real) = a / Interval(b)

# Unary

#-
+a

#-
-a

# Binary

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

# Sub-distributivity

#-
Interval(1//10)

#-
a = Interval(-1, 1)
b = Interval(-1, 0)
c = Interval(3, 4)

#-
a * (b + c)

#-
a * b + a * c

# Defial equal

#-
import Base.==

==(a::Interval, b::Interval) = a.lo == b.lo && a.hi == b.hi

#-
a = Interval(1, 10)
b = Interval(-2, 3)
c = Interval(3, 5)

a == a

#-
a == b

#-
a == c

#-
a != a

#-
a != b

#-
a != c

# Inclusion

#-
Base.issubset(a::Interval, b::Interval) = b.lo <= a.lo && a.hi <= b.hi
Base.:⊊(a::Interval, b::Interval) = a ⊆ b && a != b

#-
a ⊆ a

#-
a ⊆ b

#-
b ⊆ a

#-
a ⊊ c

#-
c ⊊ a

#-
a ⊊ a

#-
a ⊇ a

#-
a ⊇ c 

#-
a ⊋ a

#-
a ⊋ c