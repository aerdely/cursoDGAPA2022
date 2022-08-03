### Tarea 1  

# Escribir código en Julia que facilite trabajar con la distribución de
# probabilidad Kumaraswamy y que NO tenga dependencia con paquete alguno.
# En particular que sea posible calcular valores de su función de densidad,
# función de distribución, función de cuantiles, simular una muestra aleatoria,
# calcular valores teóricos de su media, mediana y varianza, e incluir ejemplos
# que se puedan ejecutar. Deberá entregar un archivo con el código en julia con
# extensión .jl y utilizar las iniciales de su nombre completo en minúsculas como
# nombre del archivo. Por ejemplo, en mi caso Arturo Erdely Ruiz entregaría el
# archivo aer.jl

# https://en.wikipedia.org/wiki/Kumaraswamy_distribution 

begin
    using SpecialFunctions # para utilzar la función beta
    using Plots # para ilustrar con aguas gráficas
end


## Documentar una función u otro tipo de objeto

"""
    funcioncita(a, b)

No sirve de mucho, solo suma `a` con `b` y agrega `1`.

> Es solo para ejemplificar:

- Que se puede documentar un función
- O de hecho cualquier otro tipo de objeto

## Ejemplo
```
funcioncita(2, 3)
# Es lo mismo que:
2 + 3 + 1
```
"""
function funcioncita(a, b)
    # Vamos a empezar...
    return a + b + 1 # este es el resultado
end

# Y luego consultarla en el modo ayuda `?` 
# o bien mediante:
@doc funcioncita


"""
    matriz2x3

Matriz de 2 × 3 rellenada con números aleatorios.
"""
matriz2x3 = rand(2, 3)


## Distribución Kumaraswamy

"""
    Kumaraswamy(a, b)

Distribución de probabilidad [*Kumaraswamy*](https://en.wikipedia.org/wiki/Kumaraswamy_distribution)
con parámetros `a > 0` y `b > 0`. Por ejemplo, si se define `K = Kumaraswamy(2, 9)` entonces:

- `K.va` = Nombre de la distribución con los parámetros especificados
- `K.a` =  valor del primer parámetro
- `K.b` =  valor del segundo parámetro 
- `K.param` = tupla de los parámetros
- `K.fdp(x)` =  función de densidad evaluada en el valor `x`
- `K.fda(x)` = función de distribución (acumulativa) evaluada en el valor `x`
- `K.ctl(u)` = función de cuantiles evaluada en el valor `0 ≤ u ≤ 1`
- `K.sim(n)` = vector con la simulación una muestra aleatoria de tamaño `n`
- `K.esp` = esperanza teórica
- `K.med` = mediana teórica
- `K.moda` = moda teórica (devuelve valor `NaN` si no existe)
- `K.var` = varianza teórica
- `K.mom(m)` = m-ésimo momento teórico, m ∈ {1,2,3,...}

> Requiere haber instalado y llamado el paquete `SpecialFunctions`

## Ejemplos
```
X = Kumaraswamy(2, 9)
keys(X)
X.med
X.fda(X.med) # comprobando la mediana
X.ctl(0.5) # comprobando el cuantil
xsim = X.sim(1_000); # simular muestra tamaño 1000
sum(xsim) / length(xsim) # media muestral
X.esp # esperanza teórica
X.var # varianza teórica
X.mom(2) - X.mom(1)^2 # varianza teórica en términos de momentos
```
"""
function Kumaraswamy(a, b)
    if min(a, b) ≤ 0
        error("Ambos parámetros deben ser positivos")
    else
        # Estilo R
        dkuma(x) = a * b * (x^(a - 1)) * (1 - x^a)^(b - 1) * (0 < x < 1)
        pkuma(x) = (1 - (1 - x^a)^b)*(0 < x < 1) + 1*(x ≥ 1)
        qkuma(u) = (1 - (1 - u)^(1 / b))^(1 / a)
        rkuma(n) = qkuma.(rand(n))
        # fin estilo R 
        mediana = (1 - 2^(-1/b))^(1/a)
        if a ≥ 1 && b ≥ 1 && (a,b) ≠ (1,1)
            moda = ((a - 1) / (a*b - 1))^(1 / a)
        else
            moda = NaN
        end
        momento(k) = b * beta(1 + k/a, b) # `beta` función del paquete `SpecialFunctions`
        esperanza = momento(1)
        varianza = momento(2) - esperanza^2
        return (va = "Kumaraswamy(a = $a, b = $b)",
            a = a, b = b, param = (a, b),
            fdp = dkuma, fda = pkuma, ctl = qkuma, sim = rkuma,
            esp = esperanza, med = mediana, moda = moda,
            var = varianza, mom = momento
        )
    end
end

# Entrar al modo ayuda `?` y escribir: Kumaraswamy
# o bien:
@doc Kumaraswamy


X = Kumaraswamy(-1,2) # Error
X

X = Kumaraswamy(2, 9)
typeof(X)
keys(X)
X.va
X[:va]

X.a
X.b
X.param

X.med # mediana teórica
X.fda(X.med) # comprobando la mediana
X.ctl(0.5) # comprobando el cuantil 0.5

"""
    media(x::Vector)

Media muestral calculada a partir de un vector `x` de números.

## Ejemplo
```
media([1, 2, 3, 4])
```
"""
media(x::Vector) = sum(x) / length(x)

typeof(X)

"""
    media(X::NamedTuple)

Media (o esperanza) teórica de una variable aleatoria `X` expresada bajo el estándar **Erdely**.

## Ejemplo

```
X = Kumaraswamy(2, 9) # definir variable aleatoria
xsim = X.sim(1_000) # simular muestra
media(xsim) # media muestral
media(X) # media teórica
```
"""
media(X::NamedTuple) = X.esp


"""
    mediana(x::Vector)

Mediana muestral calculada a partir de un vector `x` de números.

## Ejemplos
```
mediana([1, 2, 3, 4])
mediana([1, 2, 3, 4, 5])
```
"""
function mediana(x::Vector)
    xord = sort(x)
    n = length(x)
    if iseven(n)
        med = (xord[n÷2] + xord[n÷2 + 1]) / 2
    else
        med = xord[(n+1)÷2]
    end
    return med
end

"""
    mediana(X::NamedTuple)

Mediana teórica de una variable aleatoria `X` expresada bajo el estándar **Erdely**.

## Ejemplo

```
X = Kumaraswamy(2, 9) # definir variable aleatoria
xsim = X.sim(1_000) # simular muestra
mediana(xsim) # media muestral
mediana(X) # media teórica
```
"""
mediana(X::NamedTuple) = X.med

methods(media)
methods(mediana)

# Entrar al modo ayuda `?` y consultar las funciones `media` y `mediana`


xsim = X.sim(10_000)
media(xsim) # media muestral
media(X) # media teórica
mediana(xsim) # mediana muestral
mediana(X) # mediana teórica

# Histograma de valores simulados junto con densidad teórica
begin
    xx = collect(range(0.0, 1.0, length = 1_000))
    histogram(xsim, normalize = true, color =:yellow, label = "muestra simulada")
    xaxis!("x"); yaxis!("densidad")
    plot!(xx, X.fdp.(xx), lw = 3, color = :red, label = "densidad teórica")
    moda = round(X.moda, digits = 4)
    vline!([moda], color = :blue, lw = 2, label = "moda = $moda")
end

# Similar a lo anterior pero en este caso la moda no existe
Y = Kumaraswamy(0.5, 0.5)
Y.moda
begin
    ysim = Y.sim(10_000)
    yy = collect(range(0.01, 0.99, length = 1_000))
    histogram(ysim, normalize = true, color =:yellow, label = "muestra simulada", legend = :top)
    xaxis!("y"); yaxis!("densidad")
    plot!(yy, Y.fdp.(yy), lw = 3, color = :red, label = "densidad teórica")
end
