### Archivos


## Cadenas de caracteres (texto)

# \n (new line)  \t (tab)  \v (vertical tab)  \b (backspace)  \r (return)  chomp

println("El mundo es color rosa")
println("El mundo es color\nrosa")
println("El mundo es color\trosa")
println("El mundo es color\vrosa")
println("El mundo es color\brosa")
println("El mundo es color\rrosa")

a = "Julia es lo\nmáximo\n"
typeof(a)
println(a, "fin")
chomp(a)
println(chomp(a), "fin")


## Texto que incluye comillas

texto = "A quien madruga Dios lo arruga"
println(texto)
texto2 = """Me molesta que utilicen "comillas" para todo"""
println(texto2)
texto3 = "Otra forma de utilizar \"comillas\" dentro de las comillas"
println(texto3)


## Subcadenas de caracteres
#  SubString  end  chop

println(texto)
length(texto)
println(texto[3])
println(texto[3:7])
println(texto[25:end])
println(texto[[3, end-2, end]])
println(texto[begin])

println(texto[3:7])
subtexto = SubString(texto, 3, 7)
println(subtexto)

SubString("abcdefghi", 3, 6)
chop("abcdefghi", head = 2, tail = 3)


## Concatenación

saluda = "Hola"
quien = "mundo"
frase = string(saluda, " ", quien, " cruel!")
println(frase)
println(saluda * quien)
println(saluda * " " * quien)

# repeat  join  

println(repeat(".:Z:.", 10))
println(".:Z:."^10)
println(join(["perros", "gatos", "ratones", "lombrices"], ", "))
println(join(["perros", "gatos", "ratones", "lombrices"], ", ", " y "))


## Interpolación

saluda = "Hola"
quien = "mundo"
println("$saluda $quien cruel!")

println("1 + 2 = $(1 + 2)")

v = [1, 2, 3]
println("v = $v")

println("Tengo \$1,000 pesos en mi cartera")


## Escribir cadena larga mediante separaciones

"Esto está muy largo así que \
 lo vamos a separar"


## endswith  startswith  contains

nombre_archivo_1 = "imagen01.png"
nombre_archivo_2 = "imagen02.pdf"
endswith(nombre_archivo_1, ".png")
endswith(nombre_archivo_2, ".png")
startswith(nombre_archivo_1, "imagen")
startswith(nombre_archivo_2, "imagen")
contains(nombre_archivo_1, "gen")
contains(nombre_archivo_1, "g")
contains(nombre_archivo_1, 'g')
contains(nombre_archivo_1, "gw")


## replace

println(texto)
t = replace(texto, "ga" => "gó")
println(t)

# uppercase  lowercase  titlecase  uppercasefirst  lowercasefirst

t = "el mejor lenguaje de programación es Julia"
println(t)
t_mayúsculas = uppercase(t)
t_minúsculas = lowercase(t)
t_título = titlecase(t)
t_mayúscula_inicial = uppercasefirst(t)
t_minúscula_inicial = lowercasefirst(t_mayúscula_inicial)

# split  join

r = split("hola, mi,amigo", ',')
r = split("hola, mi,amigo", ",")
r = split("hola, mi,amigo", ", ")
r = join(collect(1:10), ", ")
println(r) #> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10


## Archivos de texto -> UTF-8 encoding
#  filesize  countlines  open  sizeof  isopen  close  
#  readlines readline  read  write  eachline

archivo = "texto.txt"
filesize(archivo) # tamaño en bytes
countlines(archivo)
f = open(archivo, "r") # solo lectura, por default si se omite "r" (read only)
contenido = readlines(f)
isopen(f) # verificando si el archivo está abierto, porque hay que cerrarlo
close(f)
isopen(f) 
println(contenido)

f = open(archivo) # solo lectura, por default si se omite "r"
contenido = read(f, String)
close(f)
println(contenido)

for renglón ∈ eachline(archivo)
    println(renglón)
end

f = open(archivo)
println(readline(f))
println(readline(f))
println(readline(f))
println(readline(f))
println(readline(f))
close(f)

f = open("textoNuevo.txt", "w") # con opción a escribir (write), si ya existe sobre escribe
contenido = readlines(f)
write(f, "Adiós mundo cruel.")
close(f)

f = open("textoNuevo.txt")
contenido = readlines(f)
close(f)
println(contenido)

f = open("textoNuevo.txt", "a") # agregar al final (append)
write(f, " Me voy a Marte.\nNo me esperen a cenar.")
close(f)

f = open("textoNuevo.txt")
contenido = readlines(f)
close(f)
println(contenido)
rm("textoNuevo.txt")


## Directorios
#  pwd  readdir  cd  mkdir  rm

pwd() # directorio (o carpeta) de trabajo actual
directorio = pwd()
readdir(directorio) # nombres de archivos y carpetas en carpeta actual
elementos = readdir(directorio)
println(elementos)
for e ∈ elementos
    println(e)
end

# lo mismo pero con la dirección completa de cada archivo:
readdir(directorio, join = true)

# puedes usar las funciones `filter` junto con `endswith` o `startswith`
# o `contains` para filtrar archivos, por ejemplo:
# filter(endswith(".png"), readdir())

# crear nueva carpeta en directorio de trabajo actual 
mkdir("nuevaCarpeta")
for e ∈ readdir(directorio)
    println(e)
end

# cambiar directorio de trabajo 
pwd()
cd(pwd() * "\\nuevaCarpeta")
pwd()
readdir(pwd())
f = open("prueba.txt", "w")
write(f, "Hola amigos.")
close(f)
readdir(pwd())

# eliminar archivos o carpetas
rm("prueba.txt")
directorio = pwd()
readdir(directorio)
d = SubString(directorio, 1, length(directorio) - length("nuevaCarpeta"))
cd(d)
pwd()
"nuevaCarpeta" ∈ readdir(pwd())
rm("nuevaCarpeta")
"nuevaCarpeta" ∈ readdir(pwd())


## Archivos de datos numéricos
#  Hay que convertir a texto / desconvertir de texto

a = 1
b = 2.5
v = [1, 2, 3]
M = rand(2, 3)
X = [a, b, v, M]

f = open("valores.txt", "w")
for e ∈ X
    write(f, e)
end
close(f)

f = open("valores.txt")
contenido = readlines(f)
close(f)
println(contenido) # no es lo que esperábamos

# hay que convertir todo a texto
f = open("valores.txt", "w")
for e ∈ X
    write(f, string(e))
end
close(f)
f = open("valores.txt")
contenido = readlines(f)
close(f)
println(contenido)

# Faltó indicar los saltos de línea mediante \n
f = open("valores.txt", "w")
for e ∈ X
    write(f, string(e) * "\n")
end
close(f)
f = open("valores.txt")
contenido = readlines(f)
close(f)
println(contenido)

convertir(x) = eval(Meta.parse(x))
original = convertir.(contenido)
X
X == original
rm("valores.txt")


## Crear / leer archivos CSV sin paquetes CSV y DataFrames

# Crear CSV a partir de una matriz

A = [1, 2, 3, 4, 5]
B = ["Alma", "Betina", "Carmela", "Dionisia", "Eleuteria"]
C = rand(5)
D = [A B C] # matriz con columnas A, B y C

d = size(D)
f = open("prueba.csv", "w")
for i ∈ 1:d[1]
    for j ∈ 1:d[2]
        if j < d[2]
            write(f, string(D[i, j]) * ",")
        else
            write(f, string(D[i, j]) * "\n")
        end
    end
end
close(f)

f = open("prueba.csv")
contenido = readlines(f)
close(f)

# Convertir CSV a matriz

f = open("prueba.csv")
contenido = readlines(f)
close(f)

nfilas = length(contenido)
ncolumnas = length(findall(",", contenido[1])) + 1
E = fill(fill("", nfilas), 1)
for j ∈ 2:ncolumnas
    push!(E, fill("", nfilas))
end
E 

contenido[1]

split(contenido[1], ",")

for i ∈ 1:nfilas
    fila = split(contenido[i], ",")
     for j ∈ 1:ncolumnas
        E[j][i] = fila[j]
    end
end
E

F = [convertir.(E[1]) E[2] convertir.(E[3])]
D == F # comprobando
rm("prueba.csv")


## Descargar archivos de internet

using Downloads # paquete de la biblioteca estándar de Julia

url = "https://www.dropbox.com/s/bv1a0m74tlnj736/pruebaDescarga.txt?dl=0"

Downloads.download(url, "descarga.txt")

f = open("descarga.txt")
contenido = readlines(f)
close(f)
rm("descarga.txt")


## DelimitedFiles: paquete de la biblioteca estándar de Julia
## para leer y escribir matrices de datos

using DelimitedFiles

A = reshape(collect(1:20), 5, 4)
writedlm("archivo.txt", A, '|')

B = readdlm("archivo.txt", '|', Int64, '\n')
rm("archivo.txt")


# Abrir archivo `datos.xlsx` en Excel y guardarlo como `datos.csv` con UTF-8 encoding
# Luego abrir `datos.csv` y guardarlo como UTF-8 (sin BOM)

D = readdlm("datos.csv", ',', String, '\n', header = true)
typeof(D)
D[2]
D[1]
rm("datos.csv")
