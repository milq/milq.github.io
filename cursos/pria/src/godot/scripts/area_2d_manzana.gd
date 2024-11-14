extends Area2D

# Método que se ejecuta automáticamente cuando el nodo está listo
func _ready() -> void:
    # Conecta la señal "body_entered" a la función '_on_body_entered'
    # Cuando un nodo entra en el área se llama a '_on_body_entered'
    connect("body_entered", _on_body_entered)

    # Añade este nodo (la manzana) al grupo llamado "manzanas"
    # Esto es útil para manejar múltiples manzanas en el juego
    add_to_group("manzanas")

# Método que se ejecuta cuando un nodo entra en el área de la manzana
# Recibe como parámetro "body", que representa al objeto que entra
func _on_body_entered(body: CharacterBody2D) -> void:
    # Comprueba si el objeto que entra tiene el nombre "Niblo"
    # Esto sirve para que solo se ejecute la acción si "Niblo" toca la manzana
    if body.name == "Niblo":
        # Elimina este nodo de la escena (en este caso, elimina la manzana)
        # La función 'queue_free()' borra el nodo y libera memoria
        queue_free()
