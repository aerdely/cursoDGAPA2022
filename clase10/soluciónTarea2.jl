### Tarea 2

# Utilizando los datos de COVID-19 en México de fecha 4 de Agosto de 2022 
# escribir código en Julia que calcule cuántos casos confirmados de COVID-19
# en menores de edad, residentes de la Ciudad de México o del Estado de México,
# han fallecido.


## Solución 1: En caso de que tengas suficiente memoria RAM (al menos 8Gb)
## para cargar en un DataFrame la base de datos completa.
## En caso contrario -> ver Solución 2 más adelante.

# Paquetes a utilizar (previamente instalados)

using CSV, DataFrames

# Cargar datos en un DataFrame

@time begin
    archivo = "220804COVID19MEXICO.csv"
    df = DataFrame(CSV.File(archivo))
end # 30.2 seg

# Funciones indicadoras de las características buscadas

begin 
    cdmxedomex(x) = (x ∈ [9, 15]) # claves de entidad federativa CDMX y EdoMéx (ver catálogo)
    murió(x) = (x ≠ "9999-99-99") # indicadora de fallecimiento
    menor(x) = (x < 18) # indicadora de menor de edad
    covid(x) = (x ∈ [1, 2, 3]) # indicadora de caso confirmado de COVID-19
end

# Conteo de casos e interés

@time begin 
    casos = cdmxedomex.(df.ENTIDAD_RES) .&& murió.(df.FECHA_DEF) .&& menor.(df.EDAD) .&& covid.(df.CLASIFICACION_FINAL)
    n = count(casos)
    println("")
    println("$n menores de edad residentes de CDMX y EdoMéx han fallecido por COVID-19")
end # 0.53 seg en promedio, si se mide con el paquete BenchmarkTools y la macro @btime

# otra forma: versión Sebastián Bejos

@time begin
    filtro(res, def, edad, clas) = cdmxedomex(res) && murió(def) && menor(edad) && covid(clas)
    nn = nrow(filter([:ENTIDAD_RES, :FECHA_DEF, :EDAD, :CLASIFICACION_FINAL] => filtro, df))
    println("")
    println("$nn menores de edad residentes de CDMX y EdoMéx han fallecido por COVID-19")
end # 0.57 seg en promedio, si se mide con el paquete BenchmarkTools y la macro @btime


## Solución 2: Sin cargar toda la base de datos en memoria (pero mucho más lento)
## NO utiliza los paquetes CSV ni DataFrames

# Identificar posición de columnas de interés

begin
    f = open("220804COVID19MEXICO.csv")
        L1 = readline(f)
    close(f)    
    columnas = split(replace(L1, "\"" => ""), ",") # de toda la base de datos
    variables = ["ENTIDAD_RES", "FECHA_DEF", "EDAD", "CLASIFICACION_FINAL"] # las de interés
    id = findall(x -> x ∈ variables, columnas) # posición de columnas de interés
    varid = columnas[id]
    hcat(id, varid)
end

# Conteo de casos de interés

@time begin # En mi compu tarda 13 minutos...
    cdmxedomex(x) = (x ∈ ["09", "15"]) # claves de entidad federativa CDMX y EdoMéx (ver catálogo)
    murió(x) = (x ≠ "9999-99-99") # indicadora de fallecimiento
    # parse(Int, texto) convierte a número entero un texto que solo contiene un número entero
    menor(x) = (parse(Int, x) < 18) # indicadora de menor de edad
    covid(x) = (x ∈ ["1", "2", "3"]) # indicadora de resultado confirmado de COVID-19
    caso(v) = cdmxedomex(v[1]) && murió(v[2]) && menor(v[3]) && covid(v[4]) # identificación de caso de interés
    nl = countlines("220804COVID19MEXICO.csv") # número de registros por analizar
    println("Inicia análisis de $nl registros...")
    i = 0 # contador
    suma = 0 # suma de casos de interés
    for renglón ∈ eachline("220804COVID19MEXICO.csv")
        ℓ = split(replace(renglón, "\"" => ""), ",") # leer registro
        suma += caso(ℓ[id]) # contarlo si corresponde a un caso de interés
        i += 1
        print(i, "\r") # mostrar en pantalla número de registro analizado
    end
    println("   Conteo finalizado.\n")
    println("$suma menores de edad residentes de CDMX y EdoMéx han fallecido por COVID-19") 
end;
