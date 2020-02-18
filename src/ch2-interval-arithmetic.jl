# # Chapter 2. Interval Arithmetic
# ## 2.4. Floating Point Interval Arithmetic
# ### 2.4.1. A ~~MATLAB~~ Julia Implementation of Interval Arithmetic

#-
struct Interval{T<:Real}
    lo::T
    hi::T
    function Interval(lo::T, hi::T) where T<:Real
        lo <= hi ? new{T}(lo, hi) : throw(ArgumentError("The endpoints do not define an interval."))
    end
end

Interval(x::Real) = Interval(x, x)

#-
Interval(1.0, 2.0)

#-
Interval(1f0, 2f0)

#-
Interval(1, 2)

#-
Interval(1.0)

#-
Interval(1.0, 1.0)

#-
## NG
## Interval(2.0, 1.0)
