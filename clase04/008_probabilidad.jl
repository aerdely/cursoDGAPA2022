### Probabilidad

# Require haber instalado previamente los paquetes `Plots` y `Distributions`

# El paquete `Random` no requiere instalación
# porque forma parte de la biblioteca estándar de Julia

using Random, Distributions, Plots


## Generador pseudo-aleatorio de números tipo Float en [0,1[
#  la función `rand` no requiere el paquete Random

r = rand(1_000) # vector con distribución uniforme en [0,1[
sum(r) / length(r) # aproximadamente 0.5

r = rand(2, 3) # matriz 2 × 3

r = rand(2, 3, 4) # arreglo 2 × 3 × 4

# Semilla aleatoria
rand(3)
rand(3)
Random.seed!(1234)
r = rand(3)
rand(3)
Random.seed!(1234)
s = rand(3)
r == s


## Muestreo probabilístico con reemplazo

# generar tabla de frecuencias absolutas y relativas de la colección x
function conteo(x) 
    valor = unique(x) # valores distintos de x
    try 
        sort!(valor) # intenta ordenar valores
    catch
        @warn "Conjunto no ordenable" # avisa si no se pudo
    end 
    nv = length(valor)
    frecuencia = zeros(Int, nv)
    nx = length(x)
    for i ∈ 1:nv # calcular frecuencia absoluta de los distintos valores de x
        for j ∈ 1:nx
            if valor[i] == x[j]
                frecuencia[i] += 1
            end
        end
        # o bien: frecuencia[i] = length(findall(z -> (z == valor[i]), x))
    end
    proporción = frecuencia ./ nx
    T = Matrix{Any}(undef, nv, 3)
    T[:, 1] = valor
    T[:, 2] = frecuencia
    T[:, 3] = proporción
    return (tabla = T, cols = ("valor", "frecuencia", "proporción"))
end

# Ejemplo
enteros = collect(1:10)
r = rand(enteros, 10_000) # muestra con reemplazo
c = conteo(r)
c.cols
c.tabla
sum(c.tabla[:, 2]), sum(c.tabla[:, 3])

# Ejemplo
letras = 'A' .+ collect(0:4)
r = rand(letras, 10_000)
c = conteo(r)
c.cols
c.tabla
sum(c.tabla[:, 2]), sum(c.tabla[:, 3])

# Ejemplo
frase = "Hola mundo"
r = rand(frase, 100_000)
c = conteo(r)
c.cols
c.tabla
sum(c.tabla[:, 2]), sum(c.tabla[:, 3])

# Ejemplo
loquesea = [[1 2 3; 4 5 6], rand(5), "Hola amigos", x -> x^2]
loquesea[2]
loquesea[4]
loquesea[4](5)
r = rand(loquesea, 1_000)
c = conteo(r)
c.cols
c.tabla
sum(c.tabla[:, 2]), sum(c.tabla[:, 3])

# cadenas aleatorias de caracteres
r = randstring("ACGT", 10_000)
c = conteo(r)
c.cols
c.tabla
sum(c.tabla[:, 2]), sum(c.tabla[:, 3])

r = randstring('a':'z', 10)


## Muestreo probabilístico sin reemplazo

# permutaciones aleatorias de números enteros positivos
randperm(10)

# permutaciones aleatorias de colecciones arbitrarias
A = collect('A':'E')
shuffle(A)
A # pero el conjunto A permanece como fue definido
shuffle!(A) # se modifica A con el resultado de shuffle
A

# muestra sin reemplazo de tamaño m a partir de n elementos (m ≤ n)
function sinreemplazo(A::Array, m::Integer)
    if m > length(A)
        error("m debe ser igual o menor que el número de elementos de A")
        return nothing
    else
        return shuffle(A)[1:m]
    end
end

msr = sinreemplazo(collect('A':'Z'), 10)
allunique(msr)

sinreemplazo(collect('A':'Z'), 10.0) # error porque 10.0 es Float no Int 

sinreemplazo(collect('A':'Z'), 100) # error porque m > length(A)


## Distribuciones de probabilidad que no requieren paquete alguno
#  rand:  Uniforme[0,1[
#  randn: Normal(0,1)

media(x) = sum(x) / length(x)
varianza(x) = sum((x .- media(x)) .^ 2) / (length(x) - 1)

U = rand(10_000) # Uniforme[0,1[
minimum(U) # muy cercano a 0.0 por la derecha
maximum(U) # muy cercano a 1.0 por la izquierda
extrema(U) # tupla de mínimo y máximo 
media(U) # media muestral aproximadamente de 0.5
varianza(U) # varianza muestral de aproximadamente 1/12
1/12

N = randn(10_000) # Normal(0,1)
n = length(N) # tamaño
media(N) # media muestral aprox 0.0
varianza(N) # varianza muestra aprox 1.0


## Distribuciones de probabilidad que agrega el paquete `Random`
#  bitrand: Booleana con probabilidad 1/2 de 0 o 1
#  randexp: Exponencial(1)

B = bitrand(10_000) # Booleana con probabilidad 1/2 de 0 o 1 
c = conteo(B)
c.cols
c.tabla
sum(c.tabla[:, 2]), sum(c.tabla[:, 3])

E = randexp(10_000) # Exponencial(1)
media(E) # media muestral aprox 1.0
varianza(E) # varianza muestra aprox 1.0


## Paquete `Distributions` (requiere instalación previa)
#  manual: https://juliastats.org/Distributions.jl/stable/ 

# Definición y manipulación de distribuciones de probabilidad

Z = Normal()
typeof(Z)

X = Normal(-3, 5)

mean(X) # media teórica
rX = rand(X, 10_000)
media(rX) # media muestral
mean(rX)
media(X) # error

var(X) # varianza teórica
var(rX)
varianza(rX) # varianza muestral

std(X) # desviación estándar teórica
√(varianza(rX)) # desviación estándar muestral | \sqrt + [tab]

median(X) # mediana teórica
cdf(X, median(X)) # comprobando
sum(sort(rX)[5_000:5001]) / 2 # mediana muestral
median(rX)

quantile(X, 0.90) # cuantil 0.9 teórico
cdf(X, quantile(X, 0.90)) # comprobando
sort(rX)[9_000] # cuantil 0.9 muestral 
quantile(rX, 0.9)

quantile(X, [0.5, 0.9]) # varios cuantiles teóricos

fieldnames(Normal)

X
X.μ
X.σ 
p = params(X)
typeof(p)

maximum(X)
minimum(X)
extrema(X)
modes(X) # vector de todas las modas
mode(X) # la primera moda, de menor a mayor
skewness(X)
kurtosis(X)

# función de densidad de probabilidades
X
pdf(X, -3.0)
pdf.(X, [-3.1, -3.0, -2.9])
begin
    x = collect(-23.0:0.01:17.0)
    plot(x, pdf.(X, x), legend = false, lw = 3)
    xaxis!("x"); yaxis!("densidad  f(x)")
    title!("Normal (μ = $(X.μ), σ = $(X.σ))")
    vline!([-3.0], color = :red)
    annotate!(-3, 0.003, "μ")
end

# función de distribución de probabilidades
begin
    plot(x, cdf.(X, x), legend = false, lw = 3)
    xaxis!("x"); yaxis!("F(x)")
    title!("Normal (μ = $(X.μ), σ = $(X.σ))")
    vline!([-3.0], color = :red)
    hline!([0.5], color = :red)
    annotate!(-3, 0.003, "μ")
end

# Ajuste de un modelo con base en datos (máxima verosimilitud)
G = Gamma(2, 3)
mean(G)
rG = rand(G, 10_000)
ajusteG = fit(Gamma, rG)
typeof(ajusteG)
params(ajusteG) 
rGsim = rand(ajusteG, 10_000)
sort!(rG); sort!(rGsim);

# qq-plot
begin
    scatter(rG, rGsim, legend = false, size = (400, 400))
    xaxis!("datos originales")
    yaxis!("datos simulados")
    title!("Q-Q plot")
    e = max(rG[end], rGsim[end])
    plot!([0, e], [0, e], color = :red)
end


## Ejemplo de modelo multivariado

# Definir Normal bivariada y simular
begin
    μ = [-2.0, 3.0]
    ρ = -0.5
    Σ = [1.0 ρ; ρ 1.0]
    XY = MvNormal(μ, Σ)
    simXY = rand(XY, 30_000)    
end

# Estimación puntual de parámetros
begin
    x = simXY[1, :]
    y = simXY[2, :]
    param = (
        medias = (mean(x), mean(y)),
        varianzas = (var(x), var(y)),
        corr = cor(x, y)
    )
end

# Estimación puntual por máxima verosimilitud
XYestim = fit(MvNormal, simXY)


# Diagrama de dispersión (scatterplot)
begin
    scatter(x[1:3000], y[1:3000], legend = false, color = :lightgray, size = (500, 500))
    xaxis!("X"); yaxis!("Y")
    vline!([param.medias[1]], color = :navyblue)
    hline!([param.medias[2]], color = :navyblue)
    scatter!([param.medias[1]], [param.medias[2]], color = :red)
end

# Histograma bivariado
begin
    histogram2d(x, y, legend = false)
    histogram2d!(size = (500, 500), xlabel = "X", ylabel = "Y", title = "Histograma 2D")
end


## catálogo de modelos univariados
#  continuos: https://juliastats.org/Distributions.jl/stable/univariate/#Continuous-Distributions
#  discretos: https://juliastats.org/Distributions.jl/stable/univariate/#Discrete-Distributions
#  truncados: https://juliastats.org/Distributions.jl/stable/truncate/ 


## catálogo de modelos multivariados
#  https://juliastats.org/Distributions.jl/stable/multivariate/#Distributions 


## distribuciones de valores extremos: paquete Extremes.jl
#  https://jojal5.github.io/Extremes.jl/dev/ 
