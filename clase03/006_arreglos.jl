### Arreglos

## Inicialización e indexación

#  zeros  ones  trues  falses

CEROS = zeros(Int, (2, 3))
UNOS = ones(Float64, (2, 3, 4))
V = trues(2, 3)
F = falses(2, 3, 4)

# reshape  copy  similar  transpose  vec

A = zeros(Int, (3, 4))
B = A
C = copy(A)
tA = transpose(A)
R = reshape(A, (6, 2))
Rvec = vec(R)
A[2, 1] = 4
A
B
B[3,3] = 99
B
A
C
tA
R
Rvec

# rand  randn  range  collect  fill  fill!

U = rand(Float64, (5, 3)) # rellenar con iid Unif[0,1)
N = randn(Float64, (5, 3)) # rellenar con iid Normal(0,1)

I = range(0, 10, length=101)
collect(I)

I = range(0, 10, step = 0.3)
collect(I)
collect(0.0:0.3:10.0)

A = zeros(Int, 2, 3)
fill!(A, 4)
A

B = fill("hola", 2, 3)

C = [1 2 3; 4 5 6]


# eltype  typeof  length  ndims  size  begin  end

A = zeros(Int, 2, 3)
typeof(A)
eltype(A)
length(A)
ndims(A)
size(A)
size(A)[1]
size(A)[2]

v = collect(1:24)
v[begin]
v[end]
v[3:5]
v[[2, 11, 17]]
v[end-2:end]
v
n = length(v)
id = collect(1:n)
v[setdiff(id, [11, 17, 23])] # ver más adelante `deleteat!`

B = reshape(v, (2, 3, 4))
B[:, :, 3]
B[:, 2, 3]
B[1, 2, 3]
B[:, [1,3], 2]
B[:, 2:3, 2]


## Concatenación
#  cat  vcat  hcat

[1 2 3]
[1, 2, 3]
[1; 2; 3]
reshape([1,2,3], 3, 1)
reshape([1 2 3], 3, 1)
transpose([1 2 3])
transpose([1, 2, 3])

A = zeros(Int, (2, 3))
B = ones(Int, (2, 3))
cat(A, B, dims = 1)
cat(A, B, dims = 2)
vcat(A, B)
hcat(A, B)
[A; B]
[A B]
[A, B]
[A B; B A]


## Elementos de distinto tipo

f(x) = x^2 + 1
A = [3, "hola", f, zeros(2, 3)]
typeof(A)
eltype(A)
A[3](8)


## Definición de arreglos por comprensión

A = [i^2 for i ∈ [2, 5, 9]]

B = [i+j for i ∈ [2, 5, 8], j ∈ [-1, Inf]]

f(n) = n * (n + 1) * (2n + 1) ÷ 6
f(1_000)
sum(i^2 for i ∈ 1:1_000)

[(i,j) for i ∈ 1:6, j ∈ 20:22]
[(i,j) for i ∈ 1:6 for j ∈ 20:22]
[(i,j) for i ∈ 1:3 for j ∈ 1:i]
[(i,j) for i ∈ 1:6 for j ∈ 1:6 if i+j==7]


## Asignación indexada

v = collect(1:20)
v[begin]
v[end]
v[2:4] .= 100
v[[7,9]] .= 999
v
v[13:15] = [3,4,5]
v
v[end-2:end] .= 1_000
v

A = reshape(collect(1:20), (5, 4))
A[3:5, [2, 4]]
A[3:5, [2, 4]] .= 999
A
A[3:5, [2, 4]] = fill(1000, (3,2))
A


# push!   pop!   pushfirst!  append!  prepend!  popfirst!
# deleteat!  popat!  splice!  insert!  replace

fib = [1, 1, 2, 3, 5, 8, 13]
push!(fib, 21)
fib
push!(fib, sum(fib[end-1:end]))
fib
a = pop!(fib)
fib
a
pushfirst!(fib, 0)
fib
popfirst!(fib)
fib

A = [1, 2, 3, 4]
append!(A, [5, 6])
A
append!(A, [7, 8, 9], [10, 11])
A
prepend!(A, [-2, -1, 0])
A

deleteat!([6,5,4,3,2,1], 3)
deleteat!([6,5,4,3,2,1], 3:5)
deleteat!([6,5,4,3,2,1], [1, 3])
deleteat!([6,5,4,3,2,1], (1, 3))
deleteat!([6,5,4,3,2,1], [true, true, false, true, false, false])

a = [4, 3, 2, 1]; popat!(a, 2)
a

A = [6, 5, 4, 3, 2, 1]; splice!(A, 5)
A 
splice!(A, 5, -1)
A
splice!(A, 2, [-1, -2, -3])
A

insert!([6, 5, 4, 2, 1], 4, 3)

B = [1, 2, 1, 3, 1, 1, 2, 2]
replace(B, 1 => 0, 2 => 99)
B
replace!(B, 1 => 0, 2 => 99)
B
replace([1, 2, 1, 3, 1, 1, 2, 2], 1 => 0, 2 => 99 , count = 3)
replace(x -> isodd(x) ? 2x : x, [1, 2, 3, 4])


## Indexación lógica
#  findall  map  findmax  findmin  findfirst  findlast

v = [1, 2, 3, 1, 2, 1, 1, 2]
id = findall(v .== 2)
findall(x -> x == 2, v)
v[id]
id = findall(v .== 0)
length(id)
v[id]

v = [1, 2, 3, 4, 5, 6]
v[[false, true, true, true, false, true]]

A = reshape(1:16, 4, 4)
A[[false, true, true, false], :]
ispow2(8)
ispow2(7)
filtro = map(ispow2, A)
A
A[filtro]

findall(filtro)
id = findall(ispow2, A)
A[id]

CartesianIndices(A)
LinearIndices(A)
CartesianIndices(A)[5]
LinearIndices(A)[1, 2]

v = [2, 1, 2, 3, 1, 3, 1]
findmin(v)
findmax(v)

v = [1, 2, 3, 4, 5, 4, 3, 2, 1]
vv = v .≥ 3
findfirst(vv)
findlast(vv)


## Arreglos, operaciones vectorizadas y funciones

A = rand(4, 3)
U = ones(4, 3)

log.(A)
A .+= 1
A + U # en este caso no es necesario vectorizar el operador
A .+ U
A .≤ 1.5

A
f(x) = x - 100
f.(A)

A
B = fill(1.5, size(A))
A .≤ B
min.(A, B)
min.(A, 1.5)

A
A .* 2
A .* A # multiplicación entreada por entrada, NO de matrices
A * A # error
A * transpose(A) # multiplicación de matrices
transpose(A) * A

C = rand(3, 3)
Cinv = inv(C)
Id = C * Cinv
round.(Id, digits = 4)

# --> buscar en la Standard Library de Julia el paquete `LinearAlgebra`
#     https://docs.julialang.org/en/v1/ 


## Broadcasting
#  broadcast  map  filter  filter!

a = [1, 2]
A = rand(2,3)
broadcast(+, a, A)
a .+ A

b = [5, 9]
broadcast(+, a, b)
a + b
a .+ b

sec = 1:10
f(x) = x^2
f.(sec)
broadcast(f, sec) # es lo mismo que f.(sec)
map(f, sec) # hace lo mismo que broadcast

v = [1, 2, 3, 4, 5, 4, 3, 2, 1, 2]
filter(iseven, v)
filter(x -> x ≥ 3, v)
v
filter!(x -> x ≥ 3, v)
v

A = [1 2 3; 4 3 2; 1 0 4]
filter(isodd, A)


## Algunas transformaciones de uso común
#  sort  sort!  reverse  reverse!  sortperm  allunique  unique  unique!  
#  any  all  count  sum  cumsum  prod  cumprod
#  min  max  minimum  maximum  extrema

A = [3, 1, 9, 5, 6]
issorted(A)
B = sort(A)
issorted(B)
sort(A, rev = true)
A
reverse(A)
A
sort!(A)
A
reverse!(A)
A

A = [-2, 0, 1, -1]
f(x) = x^2
sort(A, by = f)
A
sort!(A, by = f)
A

B = [2, 1, 4, 5, 3]
id = sortperm(B)
B[id]

allunique(A)
C = [3, 1, 2, 3, 1, 1, 2]
allunique(C)
unique(C)
sort(unique(C))
C
unique!(C)
C

any([false, false, true, false])
any([false, false, false, false])
all([true, false, true, true])
all([true, true, true, true])

v = rand(8)
all(v .≥ 0)
all(v .≥ 0.5)
any(v .≥ 0.5)

v
count(v .≥ 0.5)
id = findall(v .≥ 0.5)
v[id]

v = [2, 3, 2, 4]
sum(v)
cumsum(v)
v
prod(v)
cumprod(v)

min(2, 4, 1)
max(2, 4, 1)
v 
min(v) # ERROR
minimum(v)
maximum(v)
extrema(v)
