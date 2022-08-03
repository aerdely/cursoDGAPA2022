## Minimización: Estimation of Distribution Algorithms (EDAs)

using Distributions, Plots, LaTeXStrings

include("EDA.jl")

@doc EDA


# Ejemplo 1: mín f(x) = (x - 5)⁴ - 16(x - 5)² + 5(x - 5) + 120

begin
    f(x) = (x[1] - 5)^4 - 16(x[1] - 5)^2 + 5(x[1] - 5) + 120
    sol = EDA(f, [0], [9])
end

begin # gráfica
    x = collect(range(0, 9, length = 1_000))
    plot(x, f.(x), legend = false, lw = 3, xlabel = L"x", ylabel = L"f(x)")
    scatter!([sol[1]], [sol[2]])
end


## Ejemplo 2: mín g(x) = -x*(x ≤ 0) + (x + 1)*(x > 0)

begin # gráfica
    x = collect(range(-1, 1, length = 1_000))
    scatter(x, g.(x), markersize = 1.0, legend = false, xlabel = L"x", ylabel = L"g(x)")
end

begin
    g(x) = -x[1]*(x[1] ≤ 0) + (x[1] + 1)*(x[1] > 0)
    sol = EDA(g, [-1], [1])
end


# Ejemplo 3: mín f(x,y) = |x - 5| + |y + 2|

begin
    f(z) = abs(z[1] - 5) + abs(z[2] + 2)
    sol = EDA(f, [-10, -10], [10, 10])
end

sol = EDA(f, [-10, -10], [10, 10], iEnteros = [1, 2]) # solo valores enteros


# Ejemplo 4: Estimación por máxima verosimilitud

begin
    X = Normal(-2, 5)
    rX = rand(X, 1_000)
    dnorm(x, μ, σ) = pdf(Normal(μ, max(σ, 0.00001)), x)
    logV(p) = -sum(log.(dnorm.(rX, p[1], p[2])))
    EDA(logV, [-10, 0], [10, 10])
end
