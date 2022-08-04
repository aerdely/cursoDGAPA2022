### Approximate Bayesian Computation (ABC)

using Distributions, Statistics, Plots, StatsBase

include("ABC.jl")


### Ejemplos

## Binomial(m, θ)

begin # simular muestra y definir simulador
    B = Binomial(15, 0.7)
    n = 100
    xobs = zeros(n, 1)
    xobs[:, 1] = rand(B, n)
    function simulador(n, p)
        vsim = zeros(n, 1)
        vsim[:, 1] = rand(Binomial(p[1], p[2]), n)
        return vsim
    end
end;

begin # estimación puntual por método de momentos
    kmom = mean(xobs)^2 / (mean(xobs) - var(xobs, corrected = false))
    pmom = mean(xobs) / kmom
    (kmom, pmom)
end

begin # estadístico = Fn, por default (lento)
    r = ABC(xobs, simulador, [1 100; 0.00001 0.99999], iEnteros = [1], nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # afinar
    intervalos = [minimum(r[:, 1]) maximum(r[:, 1]); minimum(r[:, 2]) maximum(r[:, 2])]
    r = ABC(xobs, simulador, intervalos, iEnteros = [1], nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # estadístico = método de momentos
    function T(x)
        kmom = mean(x)^2 / (mean(x) - var(x, corrected = false))
        pmom = mean(x) / kmom
        (kmom, pmom)
    end
    r = ABC(xobs, simulador, [1 100; 0.00001 0.99999], estadístico = T, iEnteros = [1], nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # afinar
    intervalos = [minimum(r[:, 1]) maximum(r[:, 1]); minimum(r[:, 2]) maximum(r[:, 2])]
    r = ABC(xobs, simulador, intervalos, estadístico = T, iEnteros = [1], nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # estadístico = de orden (suficiente)
    T(x) = sort(vec(x))
    r = ABC(xobs, simulador, [1 100; 0.00001 0.99999], estadístico = T, iEnteros = [1], nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # afinar
    intervalos = [minimum(r[:, 1]) maximum(r[:, 1]); minimum(r[:, 2]) maximum(r[:, 2])]
    r = ABC(xobs, simulador, intervalos, estadístico = T, iEnteros = [1], nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

# gráficas
begin # distribución conjunta a posteriori de (m, θ)
    scatter(r[:, 1], r[:, 2], legend = false, xlabel = "m", ylabel = "θ")
    scatter!([median(r[:, 1])], [median(r[:, 2])], color = :red, markersize = 7)
end
begin # distribución marginal a posteriori de m
    bar(countmap(r[:, 1]), legend = false, title = "m")
    vline!([median(r[:, 1])], color = "red", lw = 3)
end
begin  # distribución marginal a posteriori de θ
    histogram(r[:, 2], legend = false, title = "θ")
    vline!([median(r[:, 2])], color = "red", lw = 2)
end


## Gamma(α, β)

begin # simular muestra y definir simulador
    X = Gamma(2, 5)
    n = 100
    xobs = zeros(n, 1)
    xobs[:, 1] = rand(X, n)
    function simulador(n, p)
        vsim = zeros(n, 1)
        vsim[:, 1] = rand(Gamma(p[1], p[2]), n)
        return vsim
    end
end;

begin # método de momentos
    m1 = mean(xobs)
    m2 = mean(xobs .^ 2)
    (m1^2/(m2 - m1^2),  m2/m1 - m1)
end

begin # estadístico = Fn (default)
    r = ABC(xobs, simulador, [0.0001 100.0; 0.0001 100.0], nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # afinar
    intervalos = [minimum(r[:, 1]) maximum(r[:, 1]); minimum(r[:, 2]) maximum(r[:, 2])]
    r = ABC(xobs, simulador, intervalos, nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # estadístico de momentos
    function T(x)
        m1 = mean(x)
        m2 = mean(x .^ 2)
        (m1^2/(m2 - m1^2),  m2/m1 - m1)
    end
    r = ABC(xobs, simulador, [0.0001 100.0; 0.0001 100.0], estadístico = T, nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # afinar
    intervalos = [minimum(r[:, 1]) maximum(r[:, 1]); minimum(r[:, 2]) maximum(r[:, 2])]
    r = ABC(xobs, simulador, intervalos, estadístico = T, nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # estadístico = de orden (suficiente)
    T(x) = sort(vec(x))
    r = ABC(xobs, simulador, [0.0001 100.0; 0.0001 100.0], estadístico = T, nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end

begin # afinar
    intervalos = [minimum(r[:, 1]) maximum(r[:, 1]); minimum(r[:, 2]) maximum(r[:, 2])]
    r = ABC(xobs, simulador, intervalos, estadístico = T, nsim = 100_000, nselec = 300)
    median(r[:, 1]), median(r[:, 2])
end


begin # distribución a posteriori de ambos parámetros (α, β)
    scatter(r[:, 1], r[:, 2], legend = false, xlabel = "α", ylabel = "β")
    scatter!([median(r[:, 1])], [median(r[:, 2])], color = :red, markersize = 7)
end
begin # distribución marginal a posteriori de α
    histogram(r[:, 1], legend = false, title = "α")
    vline!([median(r[:, 1])], color = :red, lw = 2)
end
begin # distribución marginal a posteriori de β
    histogram(r[:, 2], legend = false, title = "β")
    vline!([median(r[:, 2])], color = "red", lw = 2)
end


## Normal bivariada (μ = [μ1, μ2], Σ = [σ1^2 ρ*σ1*σ2; ρ*σ1*σ2 σ2^2])

begin # simular muestra y definir simulador
    μ1 = 2.0; μ2 = -3.0
    σ1 = 1.5; σ2 = 2.3
    ρ = -0.35
    μ = [μ1, μ2]
    Σ = [σ1^2 ρ*σ1*σ2; ρ*σ1*σ2 σ2^2]
    X = MvNormal(μ, Σ)
    n = 300
    xobs = zeros(n, 2)
    xobs[:, :] = transpose(rand(X, n))
    function simulador(n, p)
        μsim = [p[1], p[2]]
        Σsim = [p[3]^2 p[3]*p[4]*p[5]; p[3]*p[4]*p[5] p[4]^2]
        vsim = zeros(n, 2)
        vsim[:, :] = transpose(rand(MvNormal(μsim, Σsim), n))
        return vsim
    end
end;

begin # estadístico = Fn (default)
    r = ABC(xobs, simulador, [-10 10; -10 10; 0.001 10; 0.001 10; -0.999 0.999], nsim = 10_000, nselec = 300)
    median.([r[:, 1], r[:, 2], r[:, 3], r[:, 4], r[:, 5]]) 
end

begin # afinar
    intervalos = [minimum(r[:, 1]) maximum(r[:, 1]); 
                  minimum(r[:, 2]) maximum(r[:, 2]);
                  minimum(r[:, 3]) maximum(r[:, 3]);
                  minimum(r[:, 4]) maximum(r[:, 4]);
                  minimum(r[:, 5]) maximum(r[:, 5]);
    ]
    r = ABC(xobs, simulador, intervalos, nsim = 10_000, nselec = 300)
    median.([r[:, 1], r[:, 2], r[:, 3], r[:, 4], r[:, 5]])
end

begin # estadísticos: máxima verosimilitud para μ1, μ2, σ1, σ2; de momentos para ρ
    T(x) = (mean(x[:, 1]), mean(x[:, 2]), std(x[:, 1]), std(x[:, 2]), cor(x[:, 1], x[:, 2]))
    r = ABC(xobs, simulador, [-10 10; -10 10; 0.001 10; 0.001 10; -0.999 0.999], estadístico = T, nsim = 100_000, nselec = 300)
    median.([r[:, 1], r[:, 2], r[:, 3], r[:, 4], r[:, 5]])
end

begin # afinar
    intervalos = [minimum(r[:, 1]) maximum(r[:, 1]); 
                  minimum(r[:, 2]) maximum(r[:, 2]);
                  minimum(r[:, 3]) maximum(r[:, 3]);
                  minimum(r[:, 4]) maximum(r[:, 4]);
                  minimum(r[:, 5]) maximum(r[:, 5]);
    ]
    r = ABC(xobs, simulador, intervalos, estadístico = T, nsim = 100_000, nselec = 300)
    median.([r[:, 1], r[:, 2], r[:, 3], r[:, 4], r[:, 5]])
end

begin # distribución marginal a posteriori de μ₁
    histogram(r[:, 1], legend = false, title = "μ₁")
    vline!([median(r[:, 1])], color = :red, lw = 2)
end
begin # distribución marginal a posteriori de μ₂
    histogram(r[:, 2], legend = false, title = "μ₂")
    vline!([median(r[:, 2])], color = :red, lw = 2)
end
begin # distribución marginal a posteriori de σ₁
    histogram(r[:, 3], legend = false, title = "σ₁")
    vline!([median(r[:, 3])], color = "red", lw = 2)
end
begin # distribución marginal a posteriori de σ₂
    histogram(r[:, 4], legend = false, title = "σ₂")
    vline!([median(r[:, 4])], color = "red", lw = 2)
end
begin  # distribución marginal a posteriori de ρ
    histogram(r[:, 5], legend = false, title = "ρ")
    vline!([median(r[:, 5])], color = "red", lw = 2)
end

begin # distribución a posteriori conjunta de (μ₁, μ₂)
    p1 = r[:, 1]
    p2 = r[:, 2]
    scatter(p1, p2, legend = false, xlabel = "μ₁", ylabel = "μ₂")
    scatter!([median(p1)], [median(p2)], color = :red, markersize = 7)
end
begin # distribución a posteriori conjunta de (σ₁, σ₂)
    p1 = r[:, 3]
    p2 = r[:, 4]
    scatter(p1, p2, legend = false, xlabel = "σ₁", ylabel = "σ₂")
    scatter!([median(p1)], [median(p2)], color = :red, markersize = 7)
end
begin # distribución a posteriori conjunta de (|μ₁ - μ₂|, ρ)
    p1 = abs.(r[:, 1] .- r[:, 2])
    p2 = r[:, 5]
    scatter(p1, p2, legend = false, xlabel = "|μ₁ - μ₂|", ylabel = "ρ")
    scatter!([median(p1)], [median(p2)], color = :red, markersize = 7)
end
begin # distribución a posteriori conjunta de (|σ₁ - σ₂|, ρ)
    p1 = abs.(r[:, 3] .- r[:, 4])
    p2 = r[:, 5]
    scatter(p1, p2, legend = false, xlabel = "|σ₁ - σ₂|", ylabel = "ρ")
    scatter!([median(p1)], [median(p2)], color = :red, markersize = 7)
end
