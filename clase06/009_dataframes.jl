### DataFrames

using CSV, DataFrames


## Crear un DataFrame

df = DataFrame(Nombre = ["Abigail", "Beatriz", "Caritina", "Delia"],
               Edad = [21, 19, 23, 24],
               Estatura = [1.56, 1.74, 1.65, 1.69]
)

typeof(df)


## Información del DataFrame
#  size  nrow  ncol  describe  names  propertynames  eachcol 

size(df)
size(df, 1)
size(df, 2)

nrow(df)
ncol(df)

describe(df)
describe(df, cols = [1,3])
describe(df, cols = 2:3)
describe(df, cols = [:Nombre, :Estatura])

names(df)
names(df, Number)
names(df, String)
names(df, Char)
names(df, r"a") # que contengan la letra `a` (regex = regular expressions)
names(df, Not(r"a")) # que NO contengan la letra `a` (regex)
names(df, r"da") # que contengan "da"
propertynames(df)

eltype(df.Edad)
eachcol(df)
eltype.(eachcol(df))
hcat(propertynames(df), eltype.(eachcol(df)))
DataFrame(campo = propertynames(df), tipo = eltype.(eachcol(df)))
describe(df)[:, [1, end]]


## Desplegar partes del DataFrame
#  ! vs :   first  last

df.Estatura
df[!, 3]
df.Estatura === df[!, 3] # misma ubicación en memoria (si lo modificas, se modifica el df original)
df[:, 3]
df.Estatura === df[:, 3]  # porque df[:, 3] es una copia (no vinculada)

first(df, 2)
last(df, 2)
first(df)
last(df)


## Visualizar dataframe con uso eficiente de memoria
#  view  @view 

view(df, :, :)
view(df, :, [:Nombre])
@view df[[1,4], [:Nombre, :Estatura]]

# `view` es más rápido y eficiente en uso de memoria,
# pero apunta al mismo lugar de memoria que el df original
# y por tanto un cambio en un dataframe creado con view
# modifica el dataframe original.
# Algunas operaciones con dataframes creados con `view`
# pueden resultar más lentas porque tiene que referirse al
# dataframe original.


## Agregar campos (columnas)
#  insertcols!

df
df.Covid = [true, false, false, true]
df # se agregó la columna al final

insertcols!(df, 3, :Peso => [45,54,63,59])
insertcols!(df, 2, :Sexo => 'F')
df


## Agregar registros (filas)
#  push!  append!

push!(df, ["Ema", 'M', 20, 71, 1.81, false]) # agregar un solo registro
df
append!(df, df[1:2, :]) # agregar varios registros (mediante otro dataframe)


## Eliminar columnas
#  select  select!

df2 = copy(df)
select(df2, Not([:Sexo, :Covid]))
df2
select!(df2, Not([:Sexo, :Covid]))
df2


## Eliminar registros (filas)
#  delete!  empty  empty!

df
delete!(df, [1, 6, 7])
df

empty(df)
df
dfvaciar = copy(df)
empty!(dfvaciar)
dfvaciar
size(dfvaciar)
names(dfvaciar)
describe(dfvaciar)
df


## Extraer algunos registros
#  Not 

df2 = df[[1, 3, 4], :]
typeof(df2)

df
df[Not(4), :]
df[Not(2, 4), :]
df[Not(2:4), :]


## Extraer algunos campos
#  Not  Between  Cols

df
df3 = df[:, [1, 4]]
typeof(df3)

df
df4 = df[:, [:Nombre, :Peso]]
df3 == df4  # mismos valores
df3 === df4 # false porque están en distintas ubicaciones de memoria (es una copia)

df
df[:, Not(:Peso)]

df
df[:, Not([:Edad, :Peso])]

df
df[:, Between(:Edad, :Estatura)]

df
df[:, Cols(:Nombre, Between(:Nombre, :Peso))]


# Al extraer un solo campo puedes obtener vector o DataFrame:

v1 = df.Nombre
v2 = df[:, :Nombre]
v1 == v2
typeof(v1) # vector
df5 = df[:, [:Nombre]] # DataFrame
typeof(df5)


## Extraer valores

df
df.Nombre[3]
df[2, 3]
df[4, :Estatura]


## Modificar valores

df.Nombre[2]
df.Nombre[2] = "Carolina"
df

df[4, :Estatura]
df[4, :Estatura] = 1.73
df

df[4, 3]
df[4, 3] = 85
df

df.Covid .= false # se asigna el mismo valor a toda la columna
df


# reemplazar datos en un DataFrame

df
df.Sexo = ['M', '?', 'M', 'F']
df

replace!(df.Sexo, 'M' => 'F')
df

replace!(df.Covid, false => true)
df


# cálculos sobre columnas

mapcols(x -> x .^ 2, df)
df
df2 = copy(df)
df2.Peso = df2.Peso .^ 2
df2
mapcols!(x -> x .^ 2, df2)
df2 



## DataFrames grandes

df = DataFrame(rand(100, 15), string.(collect('A':'Z')[1:15])) # despliegue parcial
show(df, allrows = true) # forzar a que se muestren todas las filas
show(df, allcols = true) # forzar a que se muestren todas las columnas
show(df, allcols = true, allrows = true) # forzar a que muestren todas las filas y columnas 


## Escritura / lectura de archivos CSV 

df = DataFrame(Nombre = ["Abigail", "Beatriz", "Caritina", "Delia"],
               Edad = [21, 19, 23, 24],
               Estatura = [1.56, 1.74, 1.65, 1.69]
)

CSV.write("dfEjemplo.csv", df)
dfLeer = DataFrame(CSV.File("dfEjemplo.csv"))
typeof(dfLeer)
rm("dfEjemplo.csv") # eliminar archivo


## Más funciones especializadas en DataFrames, consultar:
#  https://dataframes.juliadata.org/stable/ 