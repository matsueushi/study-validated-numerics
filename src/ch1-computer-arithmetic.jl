# # Chapter 1, Computer Arithmetic

# ## 1.1 Positional Systems
# $\beta \in \mathbb{Z}, \beta \ge 2$ : Integer base
# 
# For $\sigma \in \{-1, 1\}$, $b_i \in \{ 0, 1, \ldots, \beta-1\}$,
# 
# \begin{align*}
# (-1)^\sigma (b_n b_{n-1} \cdots b_0 . b_{-1} b_{-2} \cdots)_\beta 
# &:= (-1)^\sigma \sum_{i=-\infty}^n b_i \beta^i  \\ 
# &= (-1)^\sigma (b_n \beta^n + b_{n-1} \beta^{n-1} + \cdots + b_0 + b_{-1} \beta^{-1} + b_{-2} \beta^{-2} + \cdots)
# \end{align*}
# 
# Condition (a): $0 \le b_i \le \beta_i - 1$ for all $i$
# 
# Condition (b): $0 \le b_i \le \beta_i - 2$ for infinitely many $i$

# Prop. $\forall x \in \mathbb{R}, x \neq 0, x$ has a unique representation above.

# ## 1.2 Floating Point Numbers

#-
## Normalized range
for T in [Float16, Float32, Float64]
    println("Normalized range of $(T) is [", nextfloat(T(-Inf)), ", ", floatmax(T), "]")
end

#- 
## tenary shift map
using Printf

tenary_shift(x) = mod(3x, 1)

let x = 0.1 
    for i in 0:53
        @printf("x(%d) = %0.17f\n", i, x)
        x = tenary_shift(x)
    end
end