### Código para escribirse directamente en la terminal de Julia, línea por línea


## Modos de la terminal REPL (Repeat-Execute-Print-Loop)

# Notación: teclas [Ctrl] [Tab] [Alt] [L]
# Combinación de teclas, por ejemplo presionar simultáneamente: [Ctrl] + [L]
# julia>  cursor de la terminal de Julia

# [Alt] + [intro] para entrar/salir modo de pantalla completa


## Ejecución de instrucciones

versioninfo()

2+3

"¡Hola mundo!"

varinfo() # objetos definidos en el actual entorno global

4-7

ans # último resultado: `ans` por answer

a = 2^3

a

# Con [flecha-arriba] y [flecha-abajo] podemos regresar/adelantar
# en código previamente escrito

varinfo()

a = nothing

varinfo()

# [Ctrl] + [L] limpia la pantalla

varinfo()

# asignación sin mostrar valor en terminal

y = 4 + 9
y
z = 4 - 9;
z


## Modo ayuda

? # cambiar a modo ayuda
  # luego escribir nombre de comando, por ejemplo:
varinfo

# se puede utilizar autocompletar, por ejemplo: vari [Tab]

# si hay más de un posibilidad, por ejemplo: ? su [Tab] [Tab]

# salir del modo ayuda: tecla backspace [<-]

# Autocompletar en la terminal de Julia también


## Instalar y usar paquetes

] # entrar al modo instalar paquetes

# ? [intro] para ayuda

status # ver paquetes instalados

add OhMyREPL # instalar paquete `OhMyREPL`

status # verificar que se instaló

# salir del modo instalar paquetes: tecla basckspace [<-]

using OhMyREPL # utilizar el paquete

b = 2 + 3

varinfo()

print("valor de a = ", a)

println("valor de b = ", b)


## Entornos global y local

varinfo()

begin
    c = 5
    d = 6
    c + d
end

varinfo() # se agregaron objetos al entorno global que ocupan memoria

let 
    e = 7
    f = 8
    e + f    
end

varinfo() # NO se agregaron objetos al entorno global


## Editar código multilínea

# Con [flecha-arriba] y [flecha-abajo] podemos regresar/adelantar
# en código previamente escrito, y para insertar líneas [Esc] + [Intro]

let
    println("Comenzamos...") 
    e = 7
    f = 8
    println(e + f)
    println("Terminado.")
end


## Directorio de trabajo

pwd() # principal working directory = directorio de trabajo principal (o inicial)

readdir()

println(readdir())

carpeta = "D:\\Dropbox\\Acatlan\\DGAPA\\curso2022\\sesiones\\01"

cd(carpeta)

pwd()

readdir()

readdir(join = true)


## Ejecución de código desde un archivo

include("002_repl.jl")

exit() # cerrar terminal de Julia, o bien [Ctrl] + [D]
