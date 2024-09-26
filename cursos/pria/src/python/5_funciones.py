import math

def saludar() -> None:
    """Imprime un saludo en pantalla."""
    print("¡Hola, mundo!")

def cuadrado(numero: int) -> int:
    """Devuelve el cuadrado de un número."""
    return numero ** 2

def suma(a: int, b: int) -> int:
    """Devuelve la suma de dos números."""
    return a + b

def producto(a: int, b: int, c: int) -> int:
    """Devuelve el producto de tres números."""
    return a * b * c

def media_cuadrado_orden(numeros: list[float], n: int, cadenas: list[str]) -> tuple[float, int, list[str]]:
    """Calcula la media de una lista de números, el cuadrado de un número y ordena una lista de cadenas.

    Args:
        numeros (list[float]): Lista de números.
        n (int): Un número entero.
        cadenas (list[str]): Lista de cadenas de texto.

    Returns:
        tuple[float, int, list[str]]: Una tupla con la media, el cuadrado y las cadenas ordenadas.
    """
    media = sum(numeros) / len(numeros)
    cuadrado_n = cuadrado(n)
    cadenas_ordenadas = sorted(cadenas)
    return media, cuadrado_n, cadenas_ordenadas

def factorial(numero: int) -> int:
    """Calcula el factorial de un número entero de forma recursiva."""
    if numero <= 1:
        return 1
    else:
        return numero * factorial(numero - 1)

# Programa principal
if __name__ == "__main__":
    # Saludar al usuario
    saludar()

    # Calcular el cuadrado de un número
    x = 2
    cuadrado_x = cuadrado(x)
    print(f"El cuadrado de {x} es {cuadrado_x}.")

    # Sumar el cuadrado de 2 y 3
    suma_total = suma(cuadrado(2), 3)
    print(f"La suma de {cuadrado(2)} y 3 es {suma_total}.")

    # Calcular el producto de 4, la suma de 2 y el cuadrado de 1, y 2
    producto_total = producto(4, suma(2, cuadrado(1)), 2)
    print(f"El resultado de la función 'producto' con los valores proporcionados es {producto_total}.")

    # Lista de latitudes y climas
    latitudes = [-2.4, 7.4, 3.0, 4.6, -5.0]
    numero = suma(1, 1)
    clima = ["soleado", "nublado", "ventoso", "lluvioso"]

    # Obtener media, cuadrado y cadenas ordenadas
    resultado = media_cuadrado_orden(latitudes, numero, clima)

    # Mostrar los resultados
    print("Resultado de la función 'media_cuadrado_orden':")
    print(f"\tMedia de las latitudes: {resultado[0]}")
    print(f"\tCuadrado del número: {resultado[1]}")
    print(f"\tClimas ordenados: {', '.join(resultado[2])}")

    # Calcular el factorial del cuadrado del número
    numero_cuadrado = int(resultado[1])
    print(f"El factorial de {numero_cuadrado} es {factorial(numero_cuadrado)}.")
