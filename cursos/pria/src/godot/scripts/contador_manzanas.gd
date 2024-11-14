extends Node2D

# Obtiene el nodo del Label llamado 'Niblo'
# $Puntos es una forma abreviada de get_node("Puntos")
@onready var puntos_label: Label = $Puntos

# Variable que almacena la puntuación actual del jugador
var puntuacion: int = 0

# Método que se ejecuta automáticamente cuando el nodo está listo
func _ready() -> void:
    # Busca todos los nodos en el grupo "manzanas"
    for manzana in get_tree().get_nodes_in_group("manzanas"):
        # Conecta la señal "tree_exited" de cada manzana a la función
        # '_on_manzana_recogida'. La señal "tree_exited" se emite cuando
        # la manzana se elimina de la escena.
        manzana.connect("tree_exited", _on_manzana_recogida)

    # Llama a la función para mostrar la puntuación inicial en pantalla
    actualizar_puntuacion()

# Método para actualizar el texto de la etiqueta con la puntuación actual
func actualizar_puntuacion():
    # Actualiza el texto del Label con el valor de la puntuación
    puntos_label.text = "Puntos: " + str(puntuacion)

# Método que se llama cuando una manzana es recogida (eliminada de la escena)
func _on_manzana_recogida():
    # Incrementa la puntuación en 1 cuando una manzana es recogida
    puntuacion += 1
    # Llama a actualizar_puntuacion para mostrar la nueva puntuación
    actualizar_puntuacion()
