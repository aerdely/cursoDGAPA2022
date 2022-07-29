### Graficar

# Require haber instalado previamente el paquete `Plots`

using Plots # tarda unos segundos en cargar, es un paquete grande


# El primer gráfico tarda un poquito porque al mismo tiempo
# se precompila el paquete, pero a partir del segundo gráfico
# ya es más veloz:

@time plot([1, 4, 2, 5, 3]) # primera vez

@time plot([5, 1, 4, 2, 3]) # segunda vez en adelante

# JIT = Just in Time compilation

## Funciones de una variable

begin
    x = range(0, 2π, length = 1_000)
    y = sin.(x)
    plot(x, y)
end

plot(x, y, lw = 3, legend = false) # `lw` significa line width

plot(x, y, lw = 3, color = :red, legend = false)

# agregar elementos a la última gráfica: comandos con !

begin
    xaxis!("ángulo en radianes")
    yaxis!("función seno")
    title!("Mi primera gráfica en Julia")
end

begin
    z = cos.(x)
    plot!(x, z, color = :blue, lw = 3)
    yaxis!("funciones seno y coseno")
end

begin
    plot(x, y, lw = 3, color = :orange, label = "seno", xtickfontsize = 4)
    xaxis!("ángulo en radianes")
    yaxis!("seno y coseno")
    title!("Funciones trigonométricas", titlefontsize = 8)
    plot!(x, z, lw = 3, color = :brown, label = "coseno")
end

begin
    plot(x, y, lw = 3, color = :orange, label = "seno", legend = (0.6, 0.9))
    xaxis!("ángulo en radianes")
    yaxis!("seno y coseno")
    title!("Funciones trigonométricas")
    plot!(x, z, lw = 3, color = :brown, label = "coseno")
end

begin
    plot(x, y,
         xlim = (-0.5, 7.0), ylim = (-1.5, 1.5),
         lw = 3,
         color = :orange,
         label = "seno",
         legend = (0.6, 0.9)
    )
    xaxis!("θ = ángulo en radianes")
    yaxis!("seno y coseno de θ")
    title!("Funciones trigonométricas")
    plot!(x, z, lw = 3, color = :brown, label = "coseno")
end

current() # vuelve a crear la última gráfica

plot!(xticks = [0, 1, 2, 4, 6.5], yticks = -1.5:0.25:1.5)


# guardar gráfica en archivos .png y .pdf

savefig("pininos.png")

savefig("pininos.pdf")


# guardar gráfica en memoria

P = current()
typeof(P)
Base.summarysize(P)
P
plot(P) 


# Hasta el momento tenemos la siguiente sintaxis general:
# plot(datos...; parámetros...) # crear una nueva gráfica, recuperable mediante `current()`
# plot!(datos...; parámetros...) # agrega a la última gráfica, es decir `current()`
# plot!(g, datos...; parámetros...) # agrega a la gráfica `g`

begin
    θ = range(-5π, 5π, length = 1_000)
    y = sin.(θ) ./ θ
    plot(θ, y, lw = 3)
end

plot!(title = "ondulaciones", xlabel = "θ", ylabel = "sen θ / θ", legend = false)

plot!(xlims = (-20, 20), ylims = (-0.4, 1.2), xticks = round.(-5π:π:5π, digits = 1), yticks = -0.4:0.2:1.2)


# matriz de gráficas

θ = range(-2π, 2π, length = 1000)
T = [sin.(θ) cos.(θ)]

plot(θ, T, layout = (2, 1), lw = 3, label = ["seno" "coseno"])

rand(10) # genera números pseudo-aleatorios de manera uniforme en el intervalo [0,1[

begin
    n = 1_000
    θ = range(0, 2π, length = n)
    x = sin.(θ)
    ε = rand(n)
    p1 = plot(θ, x, legend = false, lw = 3)
    p2 = scatter(θ, x .+ 0.1*ε, legend = false, markersize = 1)
    p3 = scatter(θ, x .+ ε, legend = false, markersize = 2)
    p4 = scatter(θ, x .+ 2*ε, legend = false, markersize = 3)
    plot(p1, p2, p3, p4, layout = (2, 2))
end 


# unir puntos con líneas

begin
    x = rand(30)
    scatter(x, legend = false) # puntos
end

plot!(x) # agregar líneas

begin
    scatter(x, legend = false, markercolor = :red, markershape = :square)
    plot!(x, color = :green) 
end

# para que no se deforme:

begin
    n = 1_000
    r = fill(1, n) # r = 1 (constante)
    θ = range(0, 2π, length = n)
    x = r .* cos.(θ)
    y = r .* sin.(θ)
    plot(x, y, legend = false, lw = 3, xlabel = "x", ylabel = "y")
    scatter!([x[1]], [y[1]]) # inicio de la gráfica
end

begin
    plot(x, y, legend = false, lw = 3, size = (200, 200), xlabel = "x", ylabel = "y")
    scatter!([x[1]], [y[1]]) # inicio de la gráfica
end

begin
    plot(x, y, legend = false, lw = 3, size = (400, 400), xlabel = "x", ylabel = "y")
    scatter!([x[1]], [y[1]]) # inicio de la gráfica
end



## Catálogo de colores

# http://juliagraphics.github.io/Colors.jl/stable/namedcolors/

colores = sort(collect(keys(Colors.color_names)))


## Gráfica de barras

B = [10, 2, 5, 1, 3]
bar(B)

bar(B, color = :yellow, legend = false)

E = collect('A':'Z')[1:length(B)]
bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas")

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray])

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray], 
    fillalpha = [0.2, 0.4, 0.6, 0.8, 1.0])


## Histograma

x = randn(1_000) # simulación de una distribución Normal(0,1)
histogram(x)

histogram(x, bins = collect(-5.0:0.5:5.0), color = :pink, legend = false)

histogram!(title = "histograma", xlabel = "x", ylabel = "frecuencia")

# re-escalar para que el área total de las barras sume 1
begin
    histogram(x, bins = collect(-5.0:0.5:5.0), color = :pink, label = "observado",
              normalize = true, xlabel = "x", ylabel = "densidad de probabilidades")
    ϕ(z) = exp(-z^2 / 2) / √(2π) # función de densidad de una Normal(0,1)
    y = range(-5.0, 5.0, length = 1_000)
    plot!(y, ϕ.(y), lw = 2, color = :blue, label = "densidad teórica")
end


## Más detalles y opciones con Plots:

#  https://docs.juliaplots.org/stable/ 

# otros paquetes: Gadfly.jl (estilo ggplot2 de R)

# otro prometedor: Makie.jl


