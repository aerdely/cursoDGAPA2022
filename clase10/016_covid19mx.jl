### Modelo compartimental para COVID-19 en México
### Parte 2 de 2: Modelizar los datos

using CSV, DataFrames, Dates, Plots

begin
    covid = DataFrame(CSV.File("serieHist.csv"))
    display(describe(covid))
    covid
end


## Función auxiliar: promedio móvil

"""
    promóvil(v::Vector{<:Real}, d = 7)

Vector del promedio móvil de bloques de `d` posiciones consecutivas del vector `v`.

## Ejemplo
```
promóvil([1,2,3,4,5], 3)
```
"""
function promóvil(v::Vector{<:Real}, d = 7)
    n = length(v)
    pm = zeros(n - d + 1)
    for i ∈ d:n
        pm[i - d + 1] = sum(v[(i - d + 1):i]) / d
    end
    return pm
end


## Variables

begin
    n = nrow(covid)
    t = covid.fecha
    ΔP = covid.nuevos # nuevos positivos por fecha de inicio de síntomas
    P = cumsum(ΔP) # positivos acumulados
    I = covid.activos # infecciones activas
    ΔI = zeros(Int, n) 
    ΔI[2:n] = diff(I) # variación diaria de infecciones activas
    ΔM = covid.muertos # muertos por fecha de defunción
    M = cumsum(ΔM) # muertos acumulados
    S = covid.susceptibles # población susceptible
    ΔS = zeros(Int, n) 
    ΔS[2:n] = diff(S) # variación diaria de la población susceptible
    R = covid.recuperados # total de casos recuperados acumulados (vivos o muertos)
    ΔR = zeros(Int, n) # incremento diario de casos recuperados
    ΔR[2:n] = diff(R) # incremento diario de casos recuperados
end;


## Serie histórica de parámetros y sus variaciones

begin
    γ = zeros(n) # tasa de recuperación
    δ = zeros(n) # IFR = Infection Fatality Rate
    β = zeros(n) # tasa de contagio
    ρ = zeros(n) # Número efectivo de reproducción
    γ[2:n] = ΔR[2:n] ./ I[1:(n-1)]
    δ[2:n] = ΔM[2:n] ./ ΔR[2:n]
    β[2:n] = (ΔI[2:n] .+ ΔR[2:n]) ./ (S[1:(n-1)] .* I[1:(n-1)])
    ρ[2:n] = 1 .+ ΔI[2:n] ./ ΔR[2:n]
    Δγ = zeros(n)
    Δδ = zeros(n)
    Δβ = zeros(n)
    Δρ = zeros(n)
    Δγ[2:n] = diff(γ) # variación diaria
    Δδ[2:n] = diff(δ) # variación diaria
    Δβ[2:n] = diff(β) # variación diaria
    Δρ[2:n] = diff(ρ) # variación diaria
end;


## Intervalos de tiempo a analizar
begin
    nsem = 20 # número de semanas hacia atrás a partir de última fecha de datos
    inicio = n - nsem*7 + 1
    fin = n - 1*7 # omitir últimas 1 semanas por fecha de inicio de síntomas
    finDef = n - 2*7 # omitir últimas 2 semanas por fecha de defunción
    if inicio < fin
        intervalo = collect(inicio:fin)
        println("Intervalo del ", t[inicio], " al ", t[fin], " = ", t[fin] - t[inicio] + Day(1))
    else
        intervalo = Int[]
        println("Intervalo vacío")
    end
    if inicio < finDef 
        intervaloDef = collect(inicio:finDef)
        println("Intervalo defunciones del ", t[inicio], " al ", t[finDef], " = ", t[finDef] - t[inicio] + Day(1))
    else
        intervaloDef = Int[]
        println("Intervalo defunciones vacío")
    end
end;


## Graficar Intervalos

mkdir("gráficas")
carpeta = pwd() * "\\gráficas\\"

# Nuevos positivos
begin
    x = t[intervalo]
    y = Int.(round.(ΔP[intervalo]))
    plot(x, y, legend = false, color = :orange, lw = 3)
    hline!([0], lw = 0.1, color = :lightgray)
    title!(string(y[end]) * " nuevos casos estimados")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("Número de personas")
    savefig(carpeta * "10positivos.png")
end

# Infecciones activas
begin
    x = t[intervalo]
    y = Int.(round.(I[intervalo]))
    plot(x, y, legend = false, color = :red, lw = 3)
    hline!([0], lw = 0.1, color = :lightgray)
    title!(string(y[end]) * " infecciones activas estimadas")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("Número de personas")
    savefig(carpeta * "11infectados.png")
end

# Nuevos muertos
begin
    x = t[intervaloDef]
    y = Int.(round.(ΔM[intervaloDef]))
    plot(x, y, legend = false, color = :purple, lw = 3)
    hline!([0], lw = 0.1, color = :lightgray)
    title!(string(y[end]) * " nuevas defunciones estimadas")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[finDef]) * " @ArturoErdely")
    yaxis!("Número de personas")
    savefig(carpeta * "12muertos.png")
end

# β
begin
    x = t[intervalo]
    y = β[intervalo]
    plot(x, y, legend = false, color = :red, lw = 3)
    plot!(x[7:end], promóvil(y), color = :aqua, lw = 2)
    title!("Tasa de contagio")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("β")
    savefig(carpeta * "13beta.png")
end

# Δβ
begin
    x = t[intervalo]
    y = Δβ[intervalo]
    plot(x, y, legend = false, color = :red, lw = 3)
    plot!(x[7:end], promóvil(y), color = :aqua, lw = 2)
    title!("Variación tasa de contagio")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("Δβ")
    savefig(carpeta * "14betaVar.png")
end

# γ
begin
    x = t[intervalo]
    y = γ[intervalo]
    plot(x, y, legend = false, color = :green, lw = 3)
    plot!(x[7:end], promóvil(y), color = :aqua, lw = 2) 
    title!("Tasa de recuperación")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("γ")
    savefig(carpeta * "15gamma.png")
end

# Δγ
begin
    x = t[intervalo]
    y = Δγ[intervalo]
    plot(x, y, legend = false, color = :green, lw = 3)
    plot!(x[7:end], promóvil(y), color = :aqua, lw = 2)
    title!("Variación tasa de recuperación")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("Δγ")
    savefig(carpeta * "16gammaVar.png")
end

# δ
begin
    x = t[intervaloDef]
    y = 100 .* δ[intervaloDef]
    plot(x, y, legend = false, color = :purple, lw = 3)
    plot!(x[7:end], promóvil(y), color = :aqua, lw = 2)
    title!("Infection Fatality Rate (IFR)")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("δ  en %")
    savefig(carpeta * "17delta.png")
end

# Δδ
begin
    x = t[intervaloDef]
    y = Δδ[intervaloDef]
    plot(x, y, legend = false, color = :purple, lw = 3)
    plot!(x[7:end], promóvil(y), color = :aqua, lw = 2)
    title!("Variación IFR")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("Δδ  en %")
    savefig(carpeta * "18deltaVar.png")
end

# ρ
begin
    x = t[intervalo]
    y = ρ[intervalo]
    pm = promóvil(y)
    plot(x, y, legend = false, color = :blue, lw = 3)
    plot!(x[7:end], pm, color = :aqua, lw = 2)
    hline!([0.0], lw = 0.1, color = :lightgray)
    hline!([1.0], lw = 2, color = :red)
    title!("Número efectivo de reprodución  Rt = " * string(round(pm[end], digits = 2)))
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("ρ")
    savefig(carpeta * "19rho.png")
end

# Δρ
begin
    x = t[intervalo]
    y = Δρ[intervalo]
    plot(x, y, legend = false, color = :blue, lw = 3)
    plot!(x[7:end], promóvil(y), color = :aqua, lw = 2)
    title!("Variación número efectivo de reproducción")
    xaxis!("COVID19mx del " * string(t[inicio]) * " al " * string(t[fin]) * " @ArturoErdely")
    yaxis!("Δρ")
    savefig(carpeta * "20rhoVar.png")
end
