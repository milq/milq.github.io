def lerp(from_value: float, to_value: float, weight: float) -> float:
    """
    Realiza una interpolación lineal entre dos valores.

    La interpolación lineal (lerp) calcula un valor intermedio entre
    `from_value` y `to_value` basado en el `weight` proporcionado. El
    `weight` debe estar en el rango [0.0, 1.0],
    donde:
        - 0.0 devuelve `from_value`.
        - 1.0 devuelve `to_value`.
        - Valores intermedios devuelven un punto proporcional
          entre `from_value` y `to_value`.

    Parámetros:
    ----------
    from_value : float
        El valor inicial de la interpolación.
    to_value : float
        El valor final de la interpolación.
    weight : float
        Un valor normalizado entre 0.0 y 1.0 que determina la cantidad
        de interpolación:
            - Un `weight` de 0.0 devuelve `from_value`.
            - Un `weight` de 1.0 devuelve `to_value`.
            - Un `weight` de 0.5 devuelve el punto medio
              entre `from_value` y `to_value`.

    Devuelve:
    -------
    float
        El valor resultante de la interpolación lineal.

    Ejemplo:
    -------
    >>> lerp(0.0, 10.0, 0.5)
    5.0
    """

    # Calcula la diferencia entre el valor final y el inicial
    diferencia = to_value - from_value
    # Multiplica la diferencia por el factor de interpolación
    diferencia_ponderada = diferencia * weight
    # Suma la diferencia ponderada al valor inicial para obtener el interpolado
    valor_interpolado = from_value + diferencia_ponderada

    return valor_interpolado


def main():
    """
    Función principal que demuestra el uso de la interpolación lineal.
    """
    # Define los valores inicial y final para la interpolación
    valor_inicial: float = 0.0
    valor_final: float = 20.0

    # Realiza interpolaciones con diferentes factores de peso
    interpolado_mitad: float = lerp(valor_inicial, valor_final, 0.5)
    interpolado_cuarto: float = lerp(valor_inicial, valor_final, 0.25)
    interpolado_tres_cuartos: float = lerp(valor_inicial, valor_final, 0.75)

    # Imprime los resultados de las interpolaciones
    print(interpolado_mitad)        # Salida esperada: 10.0
    print(interpolado_cuarto)       # Salida esperada: 5.0
    print(interpolado_tres_cuartos) # Salida esperada: 15.0


if __name__ == "__main__":
    main()
