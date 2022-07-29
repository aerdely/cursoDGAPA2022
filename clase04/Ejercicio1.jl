### Ejercicio 1

# Escribir en Julia una función primos(n) que genere todos los
# números primos menores o iguales que n y los entregue en un vector.
# Úsela para generar todos los números primos menores o igual que 100 millones.

# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes 


## Propuesta Arturo

function primosArturo(n)
    A = trues(n)
    i = 2
    while i ≤ √n
        if A[i]
            j = i^2
            while j ≤ n
                A[j] = false
                j += i
            end
        end
        i += 1
    end
    return findall(A .== true)[2:end]
end

println(primosArturo(50))

@time p = primosArturo(100_000_000);

Base.summarysize(p) # tamaño en bytes de memoria
Base.summarysize(p) / 1024^2 # tamaño en megabytes

println(p[1:100])


## Propuesta de Lucio

function primosLucio(n)
    if n < 2
        return nothing
    end
    esprimo = trues(n)
    esprimo[1] = false
    m =round(Int,sqrt(n))
    primos = collect(2:2)
    for i in 2:m 
        if esprimo[i] 
            for j in i:div(n, i)
                esprimo[j*i] = false
            end
        end
    end
    for i in 3:n
        if esprimo[i]
            push!(primos,i)
        end
    end
    return primos
end

println(primosLucio(50))

@time primosLucio(100_000_000);
@time primosArturo(100_000_000);


## Propuesta de Sebastián

function primosSebastián(n::Int)
    primes_list = Int[]
    multiples = Int[]
    for i = 2:n
        if !(in(i, multiples))
            append!(primes_list, i)
            for j=(i*i):i:n
                append!(multiples, j)     
            end
        end 
    end
    return primes_list
end

println(primosSebastián(50))

@time primosSebastián(10_000);
@time primosLucio(10_000);
@time primosArturo(10_000);
