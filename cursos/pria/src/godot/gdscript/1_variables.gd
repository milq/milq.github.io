# ---------------------
# VARIABLES EN GDSCRIPT
# ---------------------

@tool
extends EditorScript

# Esto es un comentario de una línea

"""
Esto es un comentario
de múltiples líneas
"""

# VARIABLES
# Una variable es un símbolo que representa un valor que puede cambiar.
# En GDScript, podemos asignar un valor a una variable usando 'var' y
# especificar el tipo de dato si deseamos:
# var nombre_variable: Tipo = valor

var edad: int = 25  # La edad es un número entero

# TIPOS DE DATOS BÁSICOS

# Tipado estático explícito:
# - Especificamos el tipo de dato al declarar la variable
# Ventajas del tipado estático:
# - GDScript puede detectar más errores sin ejecutar el código.
# - Las anotaciones de tipo brindan más información al trabajar, mostrando los
#   tipos de argumentos al llamar a un método.
# - Mejora la autocompletación del editor y la documentación de tus scripts.

var nivel_del_mar: int = 25               # Entero (int)
var temperatura: float = -3.82            # Número real (float)
var nombre: String = "Nacho López"        # Cadena de texto (String)
var tiene_debian: bool = true             # Booleano (bool)

# Tipado estático implícito:
# - El tipo de dato se infiere automáticamente usando ':='
var altura := 182                    # 'altura' es inferido como int
var peso := 87.5                     # 'peso' es inferido como float
var saludo := "Hola"                 # 'saludo' es inferido como String
var es_mayor_de_edad := edad >= 18   # 'es_mayor_de_edad' es inferido como bool

# Tipado dinámico:
# - No definimos el tipo de dato y podemos cambiar el tipo durante la ejecución
# Ventajas y desventajas del tipado dinámico:
# - Ventajas:
#   - Mayor flexibilidad al permitir que las variables cambien de tipo.
#   - Menor cantidad de código al no tener que declarar tipos.
# - Desventajas:
#   - Puede llevar a errores difíciles de detectar en tiempo de ejecución.
#   - Menor eficiencia en la detección de errores por parte del editor.
var variable_dinamica = "Texto inicial"

# Constantes: Valores que no cambian durante la ejecución
const EULER: float = 2.71828


func _run() -> void:
    # Cambio de tipo durante la ejecución de la variable con tipado dinámico
    variable_dinamica = 42                 # Ahora 'variable_dinamica' es int
    variable_dinamica = false              # Ahora 'variable_dinamica' es bool

    # OPERACIONES ARITMÉTICAS CON NÚMEROS
    var x: int = 5
    var y: int = 2

    var z: int = x + y    # Suma. Resultado: 7
    z = x - y             # Resta. Resultado: 3
    z = x * y             # Multiplicación. Resultado: 10
    # z = x / y           # División entera. Resultado: 2   # Genera 'warning'
    z = x % y             # Módulo (resto de la división entera). Resultado: 1
    z += 1                # Incrementa el valor de z en 1
    z -= 1                # Disminuye el valor de z en 1

    var division_reales: float = 5.0 / 2.0  # División con decimales. Res.: 2.5

    # OPERACIONES BÁSICAS CON CADENAS DE TEXTO (strings)

    var a: String = "GNU/"
    var b: String = "Linux"
    var c: String = a + b        # Concatenación. Resultado: "GNU/Linux"

    # IMPRIMIR VARIABLES EN LA PANTALLA

    print("¡Hola, mundo!")              # Imprime en la pantalla: ¡Hola, mundo!
    print("El valor de x es ", x)       # Imprime el valor de x

    # Imprime en la pantalla cadenas de texto y variables usando comas
    print("He comprado ", x, " naranjas y ", y, " limones.")
    # Imprime en la pantalla cadenas de texto y variables concatenando cadenas
    print("He comprado " + str(x) + " naranjas y " + str(y) + " limones.")
    # O usando 'format'
    print("Tengo {0} naranjas y {1} limones. Sí, {0} naranjas.".format([x, y]))

    # CONVERSIÓN DE TIPOS DE DATOS

    var posicion: String = "5"       # Una cadena que representa un entero
    var calorias: String = "95.4"    # Una cadena que representa un número real
    var peso_actual: int = 85                 # Un número entero
    var altitud_actual: float = -544.432      # Un número real

    # Convertir de cadena a entero
    var posicion_int: int = int(posicion)
    print("Convertir 'posicion' de cadena a entero: ", posicion_int)

    # Convertir de cadena a número real (float)
    var calorias_flt: float = float(calorias)
    print("Convertir 'calorias' de cadena a float: ", calorias_flt)

    # Convertir de entero a cadena de caracteres
    var peso_str: String = str(peso_actual)
    print("Convertir 'peso' de entero a cadena: '", peso_str, "'")

    # Convertir de float a cadena de caracteres
    var altitud_str: String = str(altitud_actual)
    print("Convertir 'altitud' de float a cadena: '", altitud_str, "'")

    # Obtener el tipo de dato de las variables usando 'typeof'
    var tipo_posicion: int = typeof(posicion_int)   # Tipo: int
    var tipo_calorias: int = typeof(calorias_flt)   # Tipo: float
    var tipo_peso: int = typeof(peso_str)           # Tipo: String
    var tipo_altitud: int = typeof(altitud_str)     # Tipo: String

    print("El tipo de 'posicion_int' es ", type_string(tipo_posicion))
    print("El tipo de 'calorias_flt' es ", type_string(tipo_calorias))
    print("El tipo de 'peso_str' es ", type_string(tipo_peso))
    print("El tipo de 'altitud_str' es ", type_string(tipo_altitud))

    # MENSAJE FINAL PARA EVITAR VARIABLES NO USADAS

    var mensaje: String = "¡{0}! Mi nombre es {1}, tengo {2} años," + \
    " mido {3} cm y peso {4} kg." + \
    " Estoy a {5} metros sobre el nivel del mar, donde " + \
    "la temperatura es de {6} grados Celsius." + \
    " ¿Tengo Debian GNU/Linux instalado? {7}. " + \
    "¿Soy mayor de edad? {8}." + \
    " El resultado de una división que hice antes es {9}. " + \
    "Además, el valor final de z es {10} y la cadena concatenada c es '{11}'."

    print(mensaje.format([
        saludo, nombre, edad, altura, peso, nivel_del_mar, temperatura,
        tiene_debian, es_mayor_de_edad, division_reales, z, c])
    )
