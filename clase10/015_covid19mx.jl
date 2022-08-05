### Modelo compartimental para COVID-19 en México
### Parte 1 de 2: Preparar los datos

using CSV, DataFrames, Dates, LinearAlgebra


## Cargar datos

# Descargar primero archivo «Base de Datos» COVID-19 de:
# https://www.gob.mx/salud/documentos/datos-abiertos-152127
# junto con su «Diccionario de Datos» y actualizar la
# fecha que corresponda en la siguiente instrucción:

fechaDate = Date(2022,8,4)

# Requiere al menos 8Gb en memoria RAM para leerlo

@time begin # 39 seg en mi compu
    archivo = "220804COVID19MEXICO.csv"
    df = DataFrame(CSV.File(archivo))
end 

begin
    @info "Tamaño del data frame:"
    println("(filas, columnas) = ", size(df))
    println(round(filesize(archivo) / (1024^3), digits = 1), "Gb en archivo")
    println(round(Base.summarysize(df) / (1024^3), digits = 1), "Gb en memoria RAM")
    resumen = describe(df)[:, [begin, end]]
    show(resumen, allrows = true)
end

# Quedarse solo con los datos que necesitaremos

select!(df, :FECHA_SINTOMAS, :FECHA_DEF, :CLASIFICACION_FINAL)

begin
    @info "Tamaño del data frame:"
    println("(filas, columnas) = ", size(df))
    println(round(Base.summarysize(df) / (1024^3), digits = 1), "Gb en memoria RAM")
    resumen = describe(df)[:, [begin, end]]
end

varinfo()

begin
    CSV.write("covid.csv", df) # guardar en archivo
    df = nothing # liberar memoria RAM
    varinfo()
end

# cargando el archivo nuevo de datos covid.csv

begin
    archivo = "covid.csv"
    df = DataFrame(CSV.File(archivo))
    @info "Tamaño del data frame:"
    println("(filas, columnas) = ", size(df))
    println(round(filesize(archivo) / (1024^3), digits = 1), "Gb en archivo")
    println(round(Base.summarysize(df) / (1024^3), digits = 1), "Gb en memoria RAM")
    resumen = describe(df)[:, [begin, end]]
    println(resumen)
    df
end

# ¿Y si no tengo suficente memoria RAM para hacer lo anterior?

begin
    f = open("220804COVID19MEXICO.csv")
        L1 = readline(f)
        L2 = readline(f)
    close(f)
end

L1
L1r = replace(L1, "\"" => "")
L1rs = split(L1r, ",")
L2
L2r = replace(L2, "\"" => "")
L2rs = split(L2r, ",")

println(L1rs)
id = findall(x -> x ∈ ["FECHA_SINTOMAS", "FECHA_DEF", "CLASIFICACION_FINAL"], L1rs)
L1rs[id]
join(L1rs[id], ",")
L2rs[id]
join(L2rs[id], ",")
nl = countlines("220804COVID19MEXICO.csv")

@time begin # en mi compu tarda 15 minutos
f = open("covid2.csv", "w")
    println("Inicia escritura de $nl registros...")
    i = 0
    for renglón ∈ eachline("220804COVID19MEXICO.csv")
        i += 1
        ℓ = split(replace(renglón, "\"" => ""), ",")
        write(f, join(ℓ[id], ",") * "\n")
        print(i, "\r")
    end
    println("\n Escritura finalizada.")
close(f)
end

df2 = DataFrame(CSV.File("covid2.csv"));
df == df2
varinfo()
df2 = nothing # liberarmemoria RAM
varinfo()

begin
    @info "Tamaño del data frame:"
    println("(filas, columnas) = ", size(df))
    println(round(Base.summarysize(df) / (1024^3), digits = 1), "Gb en memoria RAM")
    resumen = describe(df)[:, [begin, end]]
end


## Mejorar codificación en FECHA_DEF

df
df[findall(df.FECHA_DEF .≠ "9999-99-99")[1:10], :]
replace!(df.FECHA_DEF, "9999-99-99" => "2200-01-01")
df
formatoFecha = Date("2200-01-01", dateformat"yyyy-mm-dd")
typeof(formatoFecha)
fechaConvertir(vector_texto) = Date.(vector_texto, dateformat"yyyy-mm-dd") 
select!(df, :FECHA_SINTOMAS, :FECHA_DEF => fechaConvertir => :FECHA_DEF, :CLASIFICACION_FINAL => :CLASIF) 

begin
    @info "Tamaño del data frame:"
    println("(filas, columnas) = ", size(df))
    println(round(Base.summarysize(df) / (1024^3), digits = 1), "Gb en memoria RAM")
    resumen = describe(df)[:, [begin, end]]
end


## Valores iniciales y factores

begin
    censo2020 = 126_014_024 # Población mexicana 15-marzo-2020 (INEGI censo 2020)
    factor_anual_crec_pobl = 1.011 # 1.1% de tasa anual de crecimiento poblacional pre-pandemia
    factor_diario_crec = factor_anual_crec_pobl ^ (1/365)
    PobMex = Int(round(censo2020 / (factor_diario_crec ^ 75))) # pobl mex estimada al 01-enero-2020
    factorPos = 30.0 # factor que mutiplicado por los casos confirmados da los estimados
    factorMue = 2.1 # factor que multiplicado por muertes confirmadas da las estimadas (SE19: 14-Mayo-2022)
    dact = 14 # número de días que se considera una infección activa a partir del inicio de síntomas
end;


## Fechas
begin
    fechaInicio = Date(2020,1,1) # inicio de la epidemia
    fechaFinal = fechaDate # fecha final últimos datos
    serieFechas = collect(fechaInicio:Day(1):fechaFinal)
    n = length(serieFechas)
end;


## Construir series de tiempo históricas

@time begin # 53 seg en mi compu
    P = zeros(Int, n) # Positivos por fecha de inicio de síntomas
    M = zeros(Int, n) # Muertos por fecha de defunción
    S = zeros(Int, n) # Susceptibles
    S[1] = PobMex 
    II = zeros(Int, n) # Infectados activos
    fPos(x) = x ∈ [1,2,3]
    Pos = fPos.(df.CLASIF)
    for t ∈ 2:n
        d = serieFechas[t]
        nP = (df.FECHA_SINTOMAS .== d) ⋅ Pos
        P[t] = Int(round(nP * factorPos))
        nM = (df.FECHA_DEF .== d) ⋅ Pos 
        M[t] = Int(round(nM * factorMue))
        nI = ((d - Day(dact) .< df.FECHA_SINTOMAS .≤ d) .&& (df.FECHA_DEF .> d)) ⋅ Pos
        II[t] = Int(round(nI * factorPos))
        S[t] = Int(round(factor_diario_crec * S[t-1])) - (II[t] - II[t-1]) - M[t]
    end
    PP = cumsum(P); RR = PP .- II
end; 


## Archivo de series históricas
begin
    serieHist = DataFrame(fecha = serieFechas, nuevos = P, activos = II, muertos = M, susceptibles = S, recuperados = RR)
    CSV.write("serieHist.csv", serieHist)
end

describe(serieHist)


## Paquete para bases de datos muy grandes: JuliaDB
## https://juliadb.juliadata.org/stable/ 
