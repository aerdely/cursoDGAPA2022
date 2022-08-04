### Approximate Bayesian Computation (ABC)

"""
    Fn(x::Vector{<:Real}, xobs::Matrix{<:Real})::Float64

Función de distribución empírica multivariada evaluada en el vector `x`
utilizando la muestra aleatoria observada en la matriz `xobs`.
Se debe cumplir que `length(x) == size(xobs)[2]` porque cada fila de 
la matriz `xobs` es una observación del vector aleatorio.

## Ejemplo
```
Fn([0.0, 0.0], randn(10_000, 2))
```
"""
function Fn(x::Vector{<:Real}, xobs::Matrix{<:Real})::Float64
    n = size(xobs)[1]
    s = 0
    for k ∈ 1:n
        s += 1 * all(xobs[k, :] .≤ x)
    end
    return s / n
end


"""
    function ABC(xobs::Matrix{<:Real}, simulador::Function, intervalos::Matrix{<:Real}; estadístico = false, iEnteros = Int[], nsim = 100_000, nselec = 300)::Matrix{Float64}

Simulación a posteriori del vector de parámetros de una distribución de probabilidad, a partir de una muestra
aleatoria observada y un método **ABC** (**A**pproximate **B**ayesian **C**omputation).

- `xobs` = matriz con la muestra aleatoria observada, con size(xobs)[1] igual al tamaño de muestra y size(xobs)[2] igual a la dimensión del vector aleatorio.
- `simulador(n, p)` = función que simula muestra aleatoria de tamaño `n` a partir de una distribución de probabilidad con vector de parámetros `p` entregando una matriz de n filas y número de columnas igual a la dimensión del vector aleatorio de dicha distribución.
- `intervalos` = matriz de dimΘ × 2 donde cada fila representa el intervalo de búsqueda para cada parámetro.
- `estadístico` = función que genera vector de transformación de `xobs` a utilizar. Si `false` entonce utiliza `Fn` (función de distribución empírica).
- `iEnteros` = posiciones en el vector de parámetros que solo admiten valores enteros (ninguna por default).
- `nsim` = número de simulaciones exploratorias (a priori) sobre los intervalos de búsqueda.
- `nselec` = número de simulaciones exploratorias a seleccionar de entre las `nsim`.

> Dependencia: función `Fn`

## Ejemplo

```
# pendiente
```
"""
function ABC(xobs::Matrix{<:Real}, simulador::Function, intervalos::Matrix{<:Real}; estadístico = false, iEnteros = Int[], nsim = 100_000, nselec = 300)::Matrix{Float64}
    dimΘ = size(intervalos)[1] # dimensión del espacio paramétrico (número de parámetros)
    println("Intervalos de búsqueda:")
    for p ∈ 1:dimΘ
        println("parámetro $p : [ $(intervalos[p, 1]) , $(intervalos[p, 2]) ]")
    end
    println("Calculando...")
    runif(a, b, n) = a .+ (b - a) .* rand(n) # simulador de distribución Uniforme(a,b)
    Θ = zeros(nsim, dimΘ)
    for j ∈ 1:dimΘ
        if j ∈ iEnteros
            Θ[:, j] = rand(Int(intervalos[j, 1]):Int(intervalos[j, 2]), nsim)
        else
            Θ[:, j] = runif(intervalos[j, 1], intervalos[j, 2], nsim)
        end
    end
    nobs = size(xobs)[1] # tamaño de la muestra
    dist = zeros(nsim)
    δ(x, y) = √(sum((x .- y) .^ 2)) # distancia euclidiana
    if estadístico == false # se utilizará el estadístico por default: Fn
        FnObs = zeros(nobs)
        for i ∈ 1:nobs
            FnObs[i] = Fn(xobs[i, :], xobs)
        end
        for i ∈ 1:nsim
            print("iteración ", i, " de ", nsim, "\r")
            FnSim = zeros(nobs)
            xsim = simulador(nobs, Θ[i, :])
            for j ∈ 1:nobs
                FnSim[j] = Fn(xobs[j, :], xsim)
            end
            dist[i] = δ(FnObs, FnSim)
        end
    else #  se utilizará el estadístico proporcionado por el usuario
        Tobs = estadístico(xobs)
        for i ∈ 1:nsim
            print("iteración ", i, " de ", nsim, "\r")
            xsim = simulador(nobs, Θ[i, :])
            Tsim = estadístico(xsim)
            dist[i] = δ(Tobs, Tsim)
        end
    end
    println("\n", "Fin.")
    iSelec = partialsortperm(dist, 1:nselec)
    ΘSelec = Θ[iSelec, :]
    return ΘSelec
end

println("Fn   EDA")
