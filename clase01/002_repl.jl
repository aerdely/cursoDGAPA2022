### Ejemplos de entorno local y global

using OhMyREPL, Dates 

# nota: el paquete `OhMyREPL` requiere instalación previa,
#       pero el paquete `Dates` no porque es parte de la 
#       biblioteca estándar de Julia.


println(now())

println("Probabilidad y Estadística con Julia")

println(varinfo())


# entorno local
let
   e = 9
   f = 10
   println("e = ", e, ", f = ", f, " =>  e + f = ", e + f) 
end


# entorno global
begin
    g = 30
    h = 40
    println("g = ", g, ", h = ", h, " =>  g + h = ", g + h) 
end


println(varinfo())
