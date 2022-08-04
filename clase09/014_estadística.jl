### Inferencia no paramétrica mediante remuestreo con reemplazo (bootstrap)

using Distributions, Statistics

include("bootstrap.jl")


### Ejemplo: m.a X1,...,Xn ~ Normal(μ, σ) 


## a) Estadístico: media muestral ~ Normal(μ, σ / √n)

begin
    n = 100
    p = 0.99
    μ = 3; σ = 2
    X = Normal(μ, σ)
    media_muestral = Normal(μ, σ / √n)
    media_muestral_intervalo = quantile(media_muestral, [(1-p)/2, (1+p)/2])
    xobs = rand(X, n)
    estim_bootstrap = bootstrap(mean, xobs, prob = p)
end;

# estimación no paramétrica (sin conocer la distribución)
estim_bootstrap.puntual, estim_bootstrap.intervalo

# estimación paramétrica (cuando conoces la distribución)
media_muestral_intervalo


## b) Estadístico: varianza muestral S² =>  (n-1)S²/σ² ∼ χ²(n-1)  Ji-cuadrada

begin
    Ji2 = Chisq(n-1)
    q = quantile(Ji2, [(1-p)/2, (1+p)/2])
    varianza_muestral_intervalo = [q[1]*(σ^2)/(n-1), q[2]*(σ^2)/(n-1)]
    estim_bootstrap = bootstrap(var, xobs, prob = p)
end;

# estimación no paramétrica (sin conocer la distribución)
estim_bootstrap.puntual, estim_bootstrap.intervalo

# estimación paramétrica (cuando conoces la distribución)
varianza_muestral_intervalo


## c) Estadístico: coeficiente de variación σ / μ

begin
    T(x) = std(x) / mean(x)
    estim_bootstrap_icv = bootstrap(T, xobs, prob = p)
end;

# estimación no paramétrica (sin conocer la distribución)
estim_bootstrap_icv.puntual, estim_bootstrap_icv.intervalo

# aproximación paramétrica vía simulación
begin
    icv = zeros(10_000)    
    for i ∈ 1:10_000
        rX = rand(X, 10_000)
        icv[i] = T(rX)
    end
    icv_muestral_intervalo = quantile(icv, [(1-p)/2, (1+p)/2])
end
