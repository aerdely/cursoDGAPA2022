### Ejemplos de entorno local y global

using Dates 

# nota: el paquete `Dates` no requiere instalación previa
#       porque es parte de la biblioteca estándar de Julia.


println(now(), "\n")

println("Probabilidad y Estadística con Julia \n")

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

display(varinfo())
