### Inferencia no paramétrica mediante remuestreo con reemplazo (bootstrap)

"""
    bootstrap(estadístico::Function, xobs::Vector; nB = 10_000, prob = 0.95)

Estimación no paramétrica de las distribución de probabilidad de un `estadístico` aplicable aplicable
a una muestra aleatoria observada `xobs`. El número de remuestreos bootstrap se puede modificar
especificando `nB` (10,000 por default) así como la probabilidad `prob` de la estimación por intervalo 
(0.85 por default). Entrega una tupla con los siguientes campos:

- `puntual` = estimación puntual del estadístico
- `intervlo` = estimación por intervalo del estadística con probabilidad `prob`
- `valor` = valor observado del estadístico de acuerdo con la muestra `xobs`
- `sims` = vector de simulaciones bootstrap del Estadístico

> Dependencias: requiere haber ejecutado primero `using Statistics`

## Ejemplo
```
xobs = randn(100) # muestra aleatoria Normal(0,1) tamaño 100
T(x) = sum(x) / length(x) # media muestral
b = bootstrap(T, xobs, nB = 20_000, prob = 0.99)
b.intervalo
```
"""
function bootstrap(estadístico::Function, xobs::Vector; nB = 10_000, prob = 0.95)
    # Dependencia: paquete `Statistics`
    n = length(xobs)
    T = estadístico
    Tobs = T(xobs)
    Tsim = zeros(nB)
    for j ∈ 1:nB
        muestra = rand(xobs, n) # pseudo-muestra bootstrap
        Tsim[j] = T(muestra)
    end
    estim_puntual = mean(Tsim)
    estim_intervalo = quantile(Tsim, [(1 - prob)/2, (1 + prob)/2])
    estim = (puntual = estim_puntual, intervalo = estim_intervalo, valor = Tobs, sims = Tsim)
    return estim
end
