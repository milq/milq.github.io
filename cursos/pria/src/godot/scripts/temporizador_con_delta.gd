extends Node2D

# Variable que acumula el tiempo transcurrido
var tiempo_acumulado: float = 0.0

# Intervalo en segundos para mostrar el mensaje
var intervalo: float = 2.0

func _process(delta: float) -> void:

    # Actualiza 'tiempo_acumulado' sumando el valor de 'delta', que representa
    # el tiempo transcurrido desde el último fotograma
    tiempo_acumulado = tiempo_acumulado + delta

    # Comprueba si ha pasado el intervalo deseado (2 segundos)
    if tiempo_acumulado >= intervalo:

        # Imprime un mensaje en la consola
        print("Han pasado 2 segundos.")

        # Reinicia el contador de 'tiempo_acumulado' para empezar de nuevo
        tiempo_acumulado = 0.0
