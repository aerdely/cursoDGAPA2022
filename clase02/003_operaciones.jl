### Algunos tipos de números y operaciones


## Números enteros

typeof(-4) # tipo entero a 64 bits
typemin(Int64) # entero más pequeño representable a 64 bits
typemax(Int64) # entero más grande representable a 64 bits

# si realizas una operación cuto resultado sale del rango
# entero mínimo y máximo, obtienes un resultado incorrecto

typemax(Int64) + 1
typemin(Int64) - 1 

# para enteros fuera del rango anterior usar `BigInt` (precisión arbitraria)

b = BigInt(typemax(Int64))
typeof(b)
b + 1

# nota: en operaciones repetidas los enteros `BigInt`
#       son menos eficientes en velocidad de cálculo

3 ^ 500 # resultado erróneo
BigInt(3) ^ 500 # resultado correcto


## Números de punto flotante

typeof(3) # tipo entero a 64 bits
typeof(3.0) # tipo punto flotante a 64 bits

bitstring(3) # representación en 64 bits
bitstring(3.0) # representación en 64 bits

# Inf  -Inf  NaN

typemin(Float64)
typemax(Float64)

3 / 0
-2 / 0
4 / Inf
4 / -Inf
-4 / -Inf
3 * Inf
- 3 * Inf
- 3 * -Inf
0 / 0


# Otros tipos: racionales, irracionales y complejos

π # \pi + TAB


## Operaciones usuales

2 + 3
2 - 3
2 * 3
2 / 3
2 \ 3 
2 ^ 3
sqrt(2)
cbrt(27)

# división entera y residuo

div(9, 4)
rem(9, 4)
divrem(9, 4)
9 ÷ 4 # \div + [TAB]  
9 % 4

# incrementales

x = 3
x += 2 # equivalente a: x = x + 2
x
x *= 7 # equivalente a: x = x * 7
x
x /= 5 # equivalente a: x = x / 5
x
x ^= 2 # equivalente a: x = x ^ 2
x

# vectorizadas

[1, 2, 3] .^ 2
x = [1, 2, 3]
x .-= 1
[1, 2, 3] .* [0, 1, 2]

f(x) = x^2 - 1
x = 2
f(x)
x = [1, 2, 3]
f(x) # error
f.(x) 

x = [1, 2, 3]
y = [10, 100, 1_000]
x + y
x .+ y
x * y # error 
x .* y 
sum(x .* y) # producto interno

# comparaciones numéricas

3 == 3
3 == 4
3 != 4
3 ≠ 4 # \ne + [TAB]
-Inf < Inf
Inf <= Inf
Inf ≤ Inf # \le + [TAB]
- 3 >= -Inf
-Inf ≥ -Inf # \ge + [TAB]

x = [1, 2, 3]
2 .≤ x 
y = 2 .≤ x
typeof(y)
eltype(y)
[false, true, true]
y
y == [false, true, true]
y .== [false, true, true]

isfinite(0 / Inf)
isinf(3 / 0)
isnan(0 / 0)
iseven(10)
isodd(7)

1 < 2 ≤ 5 ≠ 3 > 0
1 < 2 ≤ 5 < 3 > 0

x = [1, 2, 3, 4, 5]
2 .< x .< 5
1 .≤ x .< 6

# redondeo 

x = 2.5
xr = round(x)
xri = round(Int64, x)

x = 3.5
xr = round(x)
xri = round(Int64, x)

x = -2.5
xr = round(x)
xri = round(Int64, x)

x = -3.5
xr = round(x)
xri = round(Int64, x)

x = -3.1
floor(x)
ceil(x)
trunc(x)

round(1.23456, digits = 2)
round(1.23456, digits = 3)


## Conjuntos

A = [1, 2, 3, 4]
B = [3, 4, 5, 6]

A ∩ B # \cap + [TAB]
intersect(A, B)

A ∪ B # \cup + [TAB]
union(A, B)

C = [100, 1000]
A ∩ B ∩ C
isempty(A ∩ B ∩ C)
length(A ∩ B ∩ C)
A ∪ B ∪ C
length(A ∪ B ∪ C)

A
B
setdiff(A, B)
setdiff(B, A)
AB = symdiff(A, B)
BA = symdiff(B, A)

AB == BA
issetequal(AB, BA)
issetequal([1,2], [2, 1, 1, 2, 2, 1])

AB
2 in AB
3 in AB

issubset([1, 2, 3], [3, 1, 2])
issubset([1, 2], [2, 3, 4])
