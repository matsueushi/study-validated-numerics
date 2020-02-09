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
# Condition (a): $0 \le b_i \le \beta - 1$ for all $i$.
# 
# Condition (b): $0 \le b_i \le \beta - 2$ for infinitely many $i$.

# Prop. For all nonzero $x \in \mathbb{R}$ has a unique representation above.
#
# Proof. (Uniqueness) Let $x = (-1)^\sigma \sum_{i=-\infty}^n b_i \beta^i = (-1)^{\sigma^\prime} \sum_{i=-\infty}^{n^\prime} b^\prime_i \beta^i$. 
# We can assume $\sigma = \sigma^\prime = 1$ and $n \ge n^\prime$. Set $b_i = 0$ for $b_i^\prime = 0$ for $n < i \le n^\prime$.
# By (b) we have $|b_n - b^\prime_n|\beta^n =  |b_n \beta^n - b^\prime_n\beta^n| \le \sum_{i=-\infty}^{n-1}|b_i^\prime - b_i|\beta^i < 
# \sum_{i=-\infty}^{n-1}(\beta-1)\beta^i = (\beta - 1)\beta^{n-1}\frac{1}{1-1/\beta} = \beta^n$.
# Since $b_n, b_n^\prime \in \mathbb{Z}$ and $|b_n - b_n^\prime| < 1 $, we get $b_n = b_n^\prime$.
# It is clear that $x - b_n$ also satisfies the conditions (a) and (b), we conclude $b_{n-1} = b_{n-1}^\prime$.
# By continuing this process, we see $b_i = b_i^\prime$ for all $i$.
#
# (Existance) Without loss of generality, we can assume $x > 0$.
# By dividing $x$ by some $\beta^i$, it suffices to show when $0 < x \le 1$. 
# The existance is trivial if $x = 1$. We recursively construct for all $n > 0$, 
# an expression $x_n^\prime = \Sigma_{i=1}^n b_{-i}\beta^{-i}$ such that $0 \le x - x_n^\prime < \beta^{-n}$.
# Let $b_{-1}$ be the integer $i \in [0, \beta - 1]$ such that $x \in [i \beta^{-1}, (i+1) \beta^{-1})$.
# It is clear that $0 \le x - x_1^\prime < \beta^{-1}$. 
# Reaplacing $x$ by $(x - x_1^\prime)/\beta$ and follow the same procesure, we can find $b_{-2}$. 
# Continuing this process, we obtain a sequence $b_{-i}$. 
# If this sequance violates the condition (b), there exists $m$ such that $b_{-i} = \beta - 1$ for all $i > m$.
# By constuction, $x - x_{m-1}^\prime < \beta^{-m}$ but $x - x_{m-1}^\prime = \Sigma_{i=m}^{\infty} (\beta-1)\beta^{-i} = \beta^{-m}$, it leads a contradiction. 

# ## 1.2 Floating Point Numbers
# \begin{align*}
# &\mathbb{F}_\beta = \{ (-1)^\sigma m \times \beta^e \mid m = (b_0 . b_{-1} b_{-2} \cdots)_\beta, m \text{ satisfies (a) and (b)} \} \\ 
# \supset &\mathbb{F}_{\beta, p} = \{ x \in \mathbb{F}_\beta \mid m = (b_0 . b_{-1} b_{-2} \cdots b_{p-1})_\beta \} \\ 
# \supset &\mathbb{F}_{\beta, p}^{\check{e}, \hat{e}} = \{ x \in \mathbb{F}_{\beta, p} \mid \check{e} \le e \le \hat{e} \} 
# \end{align*}
# $m$ : *mantiss*a of $x$
#
# $e$ : *exponent* of $x$

# Def. We say a floating point number $x = (-1)^\sigma (b_0 . b_{-1} b_{-2} \cdots)_\beta \times \beta^e$ is *normalized* if the leading digit $b_0$ if non-zero.

#-
## Normalized range
for T in [Float16, Float32, Float64]
    println("Normalized range of $(T) is [", nextfloat(T(-Inf)), ", ", floatmax(T), "]")
end

# ## 1.2.1 Subnormal numbers

# ## 1.4. Floating Point Arithmetic

#- 
## tenary shift map
using Printf

tenary_shift(x) = mod(3x, 1)

let x = 0.1 
    for i in 0:52
        @printf("x(%d) = %0.17f\n", i, x)
        x = tenary_shift(x)
    end
end