### Funciones

f(x,y) = x + y
f(2,3)

function g(x,y)
    x + y
end
g(3,4)

h = (x,y) -> x+y
h(4,5)


## Uso de `return`

function f(x,y)
    x + y
    x * y
end
f(2,3)

function f(x,y)
    x + y
    return x * y
end
f(2,3)

function f(x,y)
    return x + y
    x * y
end
f(2,3)

function divide(x, y)
    if y ≠ 0 # `≠` se obtiene mediante \ne + [Tab], es equivalente a `y != 0`
        return x / y
    elseif x ≠ 0
        println("Números reales extendidos")
        return x / y
    else
        return "0/0 no está definido"
    end
end
divide(2,3)
divide(2,0)
divide(0,0)


## Asignar resultado de una función

a = divide(2,0)
a

function f(x, y)
    println(x + y)
end
b = f(2,3)
b
typeof(b)

function g(x,y)
    println(x + y)
    return nothing
end
c = g(5,6)
c
typeof(c)


## Tuplas

# Las tuplas son n-adas (ordenadas) que una vez definidas no pueden modificarse parcialmente,
# a diferencia de los vectores (pero tienen la ventaja de facilitar cálculos más rápidos)

x = (0.0, "hola", 6*7)
x[2]
x[2:3]
x[[1,3]]
x[1] = 2.3 # ERROR porque una vez creada la tupla no puede modificarse

# tuplas con nombres
Alicia = (edad = 28, estatura = 1.72, covid = false)
Alicia.estatura

# funciones de respuesta múltiple

f(x, y) = (x + y, x - y)
z = f(2, 3)
z

function g(x, y)
    s = x + y
    p = x * y
    return (suma = s, producto = p)
end
z = g(2, 3)
z.suma
z[1]
z.producto
z[2]


## Argumentos opcionales

function f(x, y = 10, z = 100)
    return x + y + z
end
methods(f)
f(3)
f(3, 4)
f(3, 4, 5)


## Argumentos por nombre

function g(x, y; a = 10, b)
    return a*x + b*y
end
methods(g)
g(2, 3, b = 100)
g(2, 3, b = 100, a = 1000)


## Vectorizar funciones

f(x) = x^2 + 1
v = [1, 2, 3, 4, 5]
f(v) # ERROR
v
f.(v)
broadcast(f, v)
map(f, v)
v .^ 2
# ver ayuda para `^`
3 ^ 2
^(3, 2)


## funciones anónimas

(x -> x^3)(2)
v
(x -> x^3).(v)
broadcast(x -> x^3, v)
map(x -> x^3, v)


## Entorno local / global

varinfo()
r = 100

function f(x)
    r = 1 # local
    return x + r
end
function g(x)
    return x + r # usa r del entorno global
end
f(5)
r
g(5)

function w(x)
    global r = 80 # modifica r en entorno global 
    return x + r
end
w(5)
r
