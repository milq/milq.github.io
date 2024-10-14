# ---------------------
# FUNCIONES EN GDSCRIPT
# ---------------------

@tool
extends EditorScript

# Función que imprime un saludo en pantalla.
func saludar() -> void:
    print("¡Hola, mundo!")

# Función que devuelve el cuadrado de un entero.
func cuadrado(entero: int) -> int:
    return entero * entero

# Función que suma dos enteros con un valor por defecto.
func suma(a: int, b: int = 0) -> int:
    return a + b

# Función que calcula el producto de tres enteros.
func producto(a: int, b: int, c: int) -> int:
    var resultado: int = a * b * c
    return resultado

# Función que calcula la media, el cuadrado y ordena cadenas.
func media_cuadrado_orden(
        reales: Array[float],
        n: int,
        cadenas: Array[String]
    ) -> Dictionary:
    var media: float = reales.reduce(func(a, b): return a + b) / reales.size()
    var cuadrado_n: int = cuadrado(n)
    var cadenas_ordenadas: Array[String] = cadenas.duplicate()
    cadenas_ordenadas.sort()
    return {
        "media": media,
        "cuadrado": cuadrado_n,
        "cadenas": cadenas_ordenadas
    }

# Función recursiva que calcula el factorial de un número.
func factorial(numero: int) -> int:
    if numero <= 1:
        return 1
    else:
        return numero * factorial(numero - 1)

func _run() -> void:

    # Saludar al usuario.
    saludar()

    # Calcular el cuadrado de un número.
    var x: int = 2
    var cuadrado_x: int = cuadrado(x)
    print("El cuadrado de %d es %d." % [x, cuadrado_x])

    # Sumar el cuadrado de 2 y 3.
    var suma_total: int = suma(cuadrado(2), 3)
    print("La suma de %d y 3 es %d." % [cuadrado(2), suma_total])

    # Calcular el producto de varios números.
    var producto_total: int = producto(4, suma(2, cuadrado(1)), 2)
    print("El resultado del producto es %d." % producto_total)

    # Listas de latitudes y climas.
    var latitudes: Array[float] = [-2.4, 7.4, 3.0, 4.6, -5.0]
    var numero: int = suma(1, 1)
    var clima: Array[String] = ["soleado", "nublado", "ventoso", "lluvioso"]

    # Obtener media, cuadrado y cadenas ordenadas.
    var resultado: Dictionary = media_cuadrado_orden(latitudes, numero, clima)

    # Mostrar los resultados.
    print("Resultado de 'media_cuadrado_orden':")
    print("\tMedia de las latitudes: %f" % resultado["media"])
    print("\tCuadrado del número: %d" % resultado["cuadrado"])
    print("\tClimas ordenados: %s" % ", ".join(resultado["cadenas"]))

    # Calcular el factorial del cuadrado del número.
    var cuadrado: int = resultado["cuadrado"]
    print("El factorial de %d es %d." % [cuadrado, factorial(cuadrado)])

    # Llamar a una función privada.
    _funcion_privada()

# Función privada que comienza con '_', usada internamente.
func _funcion_privada() -> void:
    print("Esta es una función privada.")
