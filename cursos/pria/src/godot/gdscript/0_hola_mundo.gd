@tool
extends EditorScript

func _run() -> void:
    print("¡Hola, mundo!")

# EXPLICACIÓN

# @tool                   Indica que este 'script' es una herramienta que se
#                         ejecutará dentro del editor de Godot.

# extends EditorScript    Especifica que este 'script' hereda de EditorScript,
#                         permitiendo interactuar con el editor.

# func _run() -> void:    Define la función '_run', que es el punto de entrada
#                         cuando el 'script' se ejecuta en el editor.

# print("¡Hola, mundo!")  Imprime el mensaje "¡Hola, mundo!" en la
#                         consola del editor.
