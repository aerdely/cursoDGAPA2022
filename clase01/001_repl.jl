### Código para escribirse directamente en la terminal de Julia, línea por línea


## Modos de la terminal REPL (Repeat-Execute-Print-Loop)

? # modo: ayuda

] # modo: instalar paquetes

; # modo: sistema operativo

# se sale de ellos con la tecla backspace [<-]

# limpiar pantalla: [Ctrl] + [L]


## Ejecución de instrucciones

2 + 3

"¡Hola mundo!"

varinfo() # objetos definidos en el actual entorno global

4 - 7

ans # último resultado: `ans` por answer

a = 2^3

a

varinfo()

a = nothing


## Instalar paquetes

] # entrar a modo instalar paquetes

status # ver paquetes instalados

add OhMyREPL 

status # verifcar que se instaló

# tecla basckspace [<-] para salir del modo instalar paquetes

using OhMyREPL # utilizar el paquetes

b = 2 + 3

varinfo()

print("valor de b = ", b)

println("valor de b = ", b)


## Instrucciones en entorno global

varinfo()

begin
    c = 5
    d = 6
    c + d
end

varinfo() # se agregaron objetos al entorno global que ocupan memoria


## Instrucciones en entorno local

let 
    e = 7
    f = 8
    e + f    
end

varinfo() # NO se agregaron objetos al entorno global


## Directorio de trabajo

pwd() # principal working directory = directorio de trabajo principal (o inicial)

readdir()

println(readdir())

carpeta = "D:\\Dropbox\\Acatlan\\DGAPA\\curso2022\\sesiones\\01"

cd(carpeta)

pwd()

readdir()


## Ejecución de código desde un archivo

include("002_repl.jl")

2 + 3
