### Control de flujo

## Evaluación condicional
#  if  elseif  else  ifelse

function compara(x, y)
    if x < y
        println("$x < $y")
    elseif x > y
        println("$x > $y")
    else
        println("$x = $y")
    end
    return nothing
end

compara(2, 3)
compara(7, 1)
compara(3, 3)

# operador ternario: P ? Q : R
pr = println
compara2(x, y) = x < y ? pr("$x < $y") : x > y ? pr("$x > $y") : pr("$x = $y")
compara2(2, 3)
compara2(7, 1)
compara2(3, 3)

esmayor(x, y) = ifelse(x > y, "sí", "no")
esmayor(5, 4)
esmayor(2.3, 3.2)


## Evaluación de corto circuito 
# &&  ||  &  |

t(x) = (println(x) ; true)
f(x) = (println(x) ; false)

println(t(1) & t(2))
println(t(1) & f(2))
println(f(1) & t(2))
println(f(1) & f(2))

println(t(1) && t(2))
println(t(1) && f(2))
println(f(1) && t(2))
println(f(1) && f(2))

println(t(1) | t(2))
println(t(1) | f(2))
println(f(1) | t(2))
println(f(1) | f(2))

println(t(1) || t(2))
println(t(1) || f(2))
println(f(1) || t(2))
println(f(1) || f(2))

println(true && 1000)
println(false && 1000)

println(true || 1000)
println(false || 1000)


## Ciclos
#  for  while  continue  break  [Ctrl]+[C]

function sumaPot(p, valores)
    suma = 0
    for n ∈ valores # \in [Tab] o bien `n in valores`
        k = n^p
        print(k, " ")
        suma += k
    end
    println("")
    return suma
end

s = sumaPot(2, [1, 3, 7])

1:100
collect(1:100)
s = sumaPot(3, collect(1:100))

function fibonacci(máximo)
    ant = 0
    sig = 1
    print(ant, " ", sig)
    while sig ≤ máximo
        fib = ant + sig
        ant = sig
        sig = fib
        if fib ≤ máximo
            print(" ", fib)
        end
    end
    println("")
    return nothing # o bien podría omitirse
end

fibonacci(250)

function sumaNo7bye23(n)
    suma = 0
    for i ∈ 1:n
        if i == 7
            continue
        elseif i == 23
            break
        else
            print(i, " ")
            suma += i
        end
    end
    println("")
    return suma
end

sumaNo7bye23(10)

sumaNo7bye23(100)

# [Ctrl]+[C] para interrumpir un ciclo manualmente en tiempo de ejecución


## Entornos global y local

# global

texto = "global"
begin
    println(texto)
    texto = "dentro de begin" # modifica variable en entorno global 
    println(texto)
end
println(texto)

texto = "global"
for i ∈ 1:3
    println(i, "\t", texto) # i es entorno local, no existe en global
end
println(i) # ERROR: UndefVarError: i not defined

texto = "global"
i = 0
for i ∈ 1:3
    texto = "modificado" # modifica variable en entorno global
    println(i, "\t", texto) # i es entorno local, no modifica global 
end
println(texto, "\t", "i = ", i)

# local

texto = "global"
i = 0
for i ∈ 1:3
    local texto = "local" # NO modifica variable en entorno global
    println(i, "\t", texto) # i es entorno local, no modifica global 
end
println(texto, "\t", "i = ", i)

# más ejemplos

for i ∈ 1:1
    z = i
    for j ∈ 1:1
        z = 0
    end
    println(z)
end
println(z) # ERROR

for i ∈ 1:1
    x = i + 1
    for j ∈ 1:1
        local x = 0
    end
    println(x)
end

# let

x = 1
let
    println(x)
    q = x + 5
    println(q)
end
println(q) # UndefVarError: q not defined

x = 1
let
    println(x)
    q = x + 5
    println(q)
    x += 1 # ERROR porque `let` es un entorno local --> usa begin ... end
end
println(x)

x = 1
let
    println(x)
    q = x + 5
    println(q)
    global x += 1 # aquí sí modificas el entorno global
end
println(x)


# for/outer

function f()
    i = 0
    println(i)
    for i ∈ 1:3
        print(i, " ")
    end
    println("\n valor final i = ", i)
    return nothing
end
f()

function g()
    i = 0
    println(i)
    for outer i ∈ 1:3 # forzamos a que i sea entorno global 
        print(i, " ")
    end
    println("\n valor final i = ", i)
    return nothing
end
g()


## Constantes
#  solo para entornos globales, avisa intentos de redefinir

const Φ = (√5 - 1)/2
println(typeof(Φ))
println("Proporción áurea = ", Φ)
Φ = 0.618 # aviso (warning)
println("Proporción áurea = ", Φ)
# pero eso no genera aviso porque es el mismo valor:
Φ = 0.618
